# https://gist.githubusercontent.com/mpneuried/0594963ad38e68917ef189b4e6a269db/raw/bd7c5a45b2eea7b0dbf4cfb1e7a70cec214418b3/Makefile

#docker build -t reddit:latest .
#docker login
#docker tag reddit:latest <your-login>/otus-reddit:1.0
#docker push <your-login>/otus-reddit:1.0


# DOCKER TASKS
push: build tag publish


# Build images
build: build-mongo build-prom


#docker build -t mongodb_exporter:latest ./mongodb_exporter/.
build-mongo:
	@echo 'build mongodb_exporter'
	git clone https://github.com/percona/mongodb_exporter;
	sed -E 's#.*ENTRYPOINT.*#ENTRYPOINT [ "/bin/mongodb_exporter","--collect.database", "--collect.collection", "--collect.topmetrics", "--collect.indexusage" ]\nENV MONGODB_URI mongodb://r_db:27017#g' -i ./mongodb_exporter/Dockerfile
	make docker -C ./mongodb_exporter

build-prom:
	@echo 'build prometheus'
	if grep -Fxq 'mongo' ./prometheus/prometheus.yml; then echo -e "  - job_name: 'mongo'\n    static_configs:\n      - targets:\n        - 'mongodb-exporter:9216'" >> prometheus/prometheus.yml; fi
	docker build -t prometheus:latest ./prometheus/.


#Tag images
tag: tag-latest

tag-latest:
	@echo 'create tag latest for  mongodb_exporter'
	docker tag mongodb_exporter:latest egrn/mongodb_exporter:latest
	@echo 'create tag latest for prometheus'
	docker tag prometheus:latest egrn/prometheus:latest


# Publish images
publish: publish-latest

publish-latest:
	@echo 'publish mongodb_exporter'
	docker push egrn/mongodb_exporter:latest
	@echo 'publish prometheus'
	docker push egrn/prometheus:latest
