FROM docker.io/library/nginx:alpine

RUN apk upgrade --no-cache

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 8080

USER nginx
