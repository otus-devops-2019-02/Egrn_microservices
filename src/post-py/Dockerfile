FROM python:3.6.0-alpine

COPY . /app
WORKDIR /app

RUN apk update -qq \
&& apk --no-cache add gcc build-base \
&& pip install --upgrade pip \
&& pip install thriftpy2 \
&& pip install -r /app/requirements.txt \
&& rm -rf /var/cache/apk/*

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

ENTRYPOINT ["python3", "post_app.py"]
