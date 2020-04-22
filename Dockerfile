# First Stage: Builder
FROM node:13.12.0-alpine AS client-build
LABEL maintainer="ReactTemplate - Admin <dev@admin.com>"
COPY package*.json ./
RUN npm install && mkdir /app && mv ./node_modules ./app
WORKDIR /app
COPY . .
RUN node_modules/webpack/bin/webpack.js --mode production

# Second Stage: Serve the built code via nginx
FROM nginx:alpine
COPY ./.nginx/nginx.conf /etc/nginx/nginx.conf
RUN rm -rf /usr/share/nginx/html/*
COPY --from=client-build /app/build /usr/share/nginx/html
EXPOSE 3000:8000
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]