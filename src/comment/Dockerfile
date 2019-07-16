FROM ruby:2.4-alpine3.9

ENV APP_HOME /app
COPY . $APP_HOME
WORKDIR $APP_HOME

RUN apk update -qq \
&& apk --no-cache add alpine-sdk \
&& bundle install \
&& rm -rf /var/cache/apk/*

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

CMD ["puma"]
