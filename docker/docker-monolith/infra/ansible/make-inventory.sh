#!/bin/bash

#EXEC: export TERRENV=prod; bash -x make-inventory.sh --list
#EXEC: export TERRENV=prod; ansible-playbook site.yml -i make-inventory.sh


make_yml(){

rowList=`gcloud compute instances list --format=json |
jq '.[]|{g1:.name|split("-")|.[0],g2:.name|split("-")|.[1],name,ipInt:.networkInterfaces[].networkIP, ipExt:.networkInterfaces[].accessConfigs[].natIP,tags:.tags.items|tostring,status,user:.metadata.items[].value|gsub("\n";"")}|join ("\t")' -cr`

if [ -z "$rowList" ]
	then echo "No active infrastructure in $(gcloud info | grep project). Exit"
	exit 1
fi

find . -type f -name 'inventory*' -exec rm {} \;


h2=""
IFS=$'\n'

for i in `echo "$rowList" | sort`;
do
    group1=`echo $i| awk -F'\t' '{print $1}'`
    group2=`echo $i| awk -F'\t' '{print $2}'`
    name=`echo $i| awk -F'\t' '{print $3}'`
    ipExt=`echo $i| awk -F'\t' '{print $5}'`
    user=`echo $i| awk -F'\t' '{print $8}'|sed -E 's/^([^:]+).*/\1/g'`

	if [ "$h2" != "$group1" ]; then
    	h2=`echo $group1`
		echo -e "\n[$h2]" >> ./environments/$group1/inventory
		echo -e "\n[$h2]" >> ./inventory
	fi
	
    echo "$name ansible_host=$ipExt ansible_user=$user" >> ./environments/$group1/inventory
    echo "$name ansible_host=$ipExt ansible_user=$user" >> ./inventory

done

h2=""
h3=""
IFS=$'\n'
for i in `echo "$rowList" | sort -t$'\t' -k2,1` #sort -t$'\t' -k2
do
    group1=`echo $i| awk -F'\t' '{print $1}'`
    group2=`echo $i| awk -F'\t' '{print $2}'`
    name=`echo $i| awk -F'\t' '{print $3}'`
    ipExt=`echo $i| awk -F'\t' '{print $5}'`
    user=`echo $i| awk -F'\t' '{print $8}'|sed -E 's/^([^:]+).*/\1/g'`

    if [ "$h3" != "$group2" ]; then
        h3=`echo $group2`
		echo -e "\n[$h3]" >> ./environments/$group1/inventory
		echo -e "\n[$h3]" >> ./inventory
    fi
	
	echo "$name ansible_host=$ipExt ansible_user=$user" >> ./environments/$group1/inventory
    echo "$name ansible_host=$ipExt ansible_user=$user" >> ./inventory

done

}



make_json_list(){
if [ -f ./inventory.json ]; then > ./inventory.json
fi

rowList=`gcloud compute instances list --format=json | jq '[.[]|{g1:.name|split("-")|.[0],g2:.name|split("-")|.[1],name,ip:.networkInterfaces[].accessConfigs[].natIP}]'`

hostArray=`echo $rowList |
jq '.|[{_meta: {hostvars: map({(.ip): {}})|add }}]'`

allArray=`echo $rowList |
jq '.|[{all: {hosts: map(.ip)}}]'`

groupArray1=`echo $rowList |
jq '.|group_by(.g1)|map({ g1: .[0].g1, hosts: map(.ip) })|map({(.g1):{hosts}})'`

groupArray2=`echo $rowList |
jq '.|group_by(.g2)|map({ g2: .[0].g2, hosts: map(.ip)})|map({(.g2):{hosts}})'`


jq --argjson arr1 "$hostArray" --argjson arr2 "$allArray" --argjson arr3 "$groupArray1" --argjson arr4 "$groupArray2"  --argjson arr4 "$allArray" \
-n '$arr1 + $arr2 + $arr3 + $arr4 | map(.) | add' |
tee inventory.json
}




make_json_host(){
rowList=`gcloud compute instances list --format=json | jq '[.[]|{name,ip:.networkInterfaces[].accessConfigs[].natIP}|select(.ip=="'$HOST'")]'`

hostArray=`echo $rowList |
jq '.|{_meta: {hostvars: map({(.ip): {var_name: .name, var_user: "appuser" }})|add }}'`

echo $hostArray | jq .
}



terraform_output() {
	rowOutputProd=`cd ../terraform; terraform output -json`


	#Fix ssh keys
	for i in `echo "$rowOutputProd" | jq '.[]|.value[]' -cr`;
	do
		ssh-keygen -f "/root/.ssh/known_hosts" -R $i
		#until nc -vzw 2 $ipExt 22; do sleep 1; done
	done

	#refreshing db ip
	#db_host_prod=`echo "$rowOutputProd" | jq '."ip-db-int".value[]' -r`
	#sed -E 's/(db_host:) ?([0-9.]+)?/\1 '$db_host_prod'/g' -i ./environments/infra/group_vars/app

}


while true; do
  case "$1" in
    -l | --list ) make_json_list; terraform_output; exit 0 ;;
    -h | --host ) HOST="$2"; make_json_host $HOST; break ;;
    -y | --yml ) make_yml; terraform_output; break ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done



exit 0
