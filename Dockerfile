# Stage 1: Get Flutter SDK and build the web app
FROM cirrusci/flutter:stable AS build

# Set the working directory
WORKDIR /app

# Copy the project files into the container
COPY . .

# Get dependencies
RUN flutter pub get

# Build the web application
RUN flutter build web --release

# Stage 2: Create a lightweight production server
FROM nginx:alpine

# Copy the built web app from the 'build' stage to the nginx server directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Command to start the nginx server when the container runs
CMD ["nginx", "-g", "daemon off;"]