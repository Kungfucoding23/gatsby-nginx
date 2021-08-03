# Multi-stage
# 1) Node image for building frontend assets
# 2) nginx stage to serve frontend assets

# Name the node stage "builder"
FROM node:12.18.2 AS builder
# Set working directory
WORKDIR /app
# Copy all files from current directory to working dir in image
# install node modules and build assets
COPY . .
RUN npm install -g gatsby-cli && npm install & npm run build

# nginx state for serving content
FROM nginx:alpine
# Set working directory to nginx asset directory
WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

EXPOSE 80

COPY nginx.conf /etc/nginx/conf.d/default.conf
# Copy static assets from builder stage
COPY --from=builder /app/public /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
# CMD ["nginx", "-c", "nginx.conf"]