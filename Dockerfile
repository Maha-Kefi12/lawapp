# Stage 1: Build Angular application
FROM node:18-alpine AS build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --legacy-peer-deps || npm install --legacy-peer-deps

# Copy source code
COPY . .

# Set Node options for more memory
ENV NODE_OPTIONS=--max_old_space_size=4096

# Build Angular app
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy built app from workspace (dist is at root level)
COPY dist/lawapp/* /usr/share/nginx/html/

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
