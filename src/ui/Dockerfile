FROM ruby:2.4-alpine3.9

ENV APP_HOME /app
COPY . $APP_HOME

WORKDIR $APP_HOME
RUN apk update -qq \
&& apk --no-cache add alpine-sdk \
&& bundle install \
&& rm -rf /var/cache/apk/*

ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

CMD ["puma"]
