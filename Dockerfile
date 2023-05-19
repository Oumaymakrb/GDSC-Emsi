# Base image
FROM node:alpine as build

WORKDIR /app

# Copy package.json and yarn.lock to container
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy all files to container
COPY . .

# Build the app
RUN yarn build

# Use Nginx as base image
FROM nginx:alpine

# Remove the default Nginx configuration
RUN rm -rf /etc/nginx/conf.d/*

# Copy the custom Nginx configuration to container
COPY /nginx/nginx.conf /etc/nginx/conf.d/

# Copy the built React app to the default Nginx public directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
