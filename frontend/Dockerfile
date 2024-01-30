FROM nginx:alpine

WORKDIR /app

COPY build/web /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]