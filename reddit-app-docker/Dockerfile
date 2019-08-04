FROM ubuntu:16.04

RUN apt update
RUN apt install -y mongodb-server ruby-full ruby-dev build-essential
RUN gem install bundler

COPY mongod.conf /etc/mongod.conf
COPY db_config /reddit/db_config
COPY start.sh /start.sh

RUN cd ../reddit && bundle install
RUN cd ../reddit-app-docker && chmod 0777 ../start.sh
CMD ["/start.sh"]
