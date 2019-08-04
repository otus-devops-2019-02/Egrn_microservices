FROM ubuntu:16.04

RUN apt-get update \
&& apt-get install -y mongodb-server ruby-full ruby-dev build-essential \
&& gem install bundler

COPY . /reddit
COPY mongod.conf /etc/mongod.conf

RUN cd /reddit \
&& bundle install \
&& chmod 0777 start.sh

CMD ["/start.sh"]
