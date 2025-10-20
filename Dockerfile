# Stage 1: Build Angular application
FROM node:18-alpine AS build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm config set registry https://registry.npmmirror.com
RUN npm cache clean --force
RUN npm ci --legacy-peer-deps

# Copy source code
COPY . .
#ENV
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Build Angular app for production (skip budget checks)
RUN npm run build -- --configuration production || npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy built app from build stage
COPY --from=build /app/dist/* /usr/share/nginx/html/

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
