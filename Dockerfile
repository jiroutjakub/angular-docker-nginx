# Which version of Node image to use depends on project dependencies 
FROM node:18.19-alpine AS build
# Create a Virtual directory inside the docker image
WORKDIR /app
# Run command in Virtual directory
RUN npm cache clean --force
# Copy files from local machine to virtual directory in docker image
COPY . /app
# Installs the Angular application dependencies
RUN npm install
# Compile the application
RUN npm run build --omit=dev

# Defining nginx image to be used
FROM nginx:latest AS ngi
# Copying compiled code and nginx config to different folder
COPY --from=build /app/dist/angular-docker-nginx/browser /usr/share/nginx/html
COPY /nginx.conf  /etc/nginx/conf.d/default.conf
# Exposing a port - app uses this port inside container
EXPOSE 80
