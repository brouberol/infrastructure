FROM nginx:alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY ./build/ ./ypsilon14/
ENTRYPOINT ["nginx", "-g", "daemon off;"]
