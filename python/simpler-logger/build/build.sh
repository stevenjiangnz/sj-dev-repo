#!/bin/bash

# Navigate to the directory containing this script
cd "$(dirname "$0")"

# Default image name
DEFAULT_IMAGE_NAME="simple-logger"

# Check if an image name was provided as an argument
IMAGE_NAME=${1:-$DEFAULT_IMAGE_NAME}

# Display which image name will be used
echo "Using image name: $IMAGE_NAME"

# Build the Docker image
echo "Building Docker image..."
docker build -t "$IMAGE_NAME" -f Dockerfile ..

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "Build successful!"
    echo "To run the container, use: docker run $IMAGE_NAME"
    echo "To run in detached mode, use: docker run -d $IMAGE_NAME"
    echo "To view logs, use: docker logs -f <container_id>"
else
    echo "Build failed!"
    exit 1
fi#!/bin/bash

# Navigate to the directory containing this script
cd "$(dirname "$0")"

# Default image name
DEFAULT_IMAGE_NAME="simple-logger"

# Check if an image name was provided as an argument
IMAGE_NAME=${1:-$DEFAULT_IMAGE_NAME}

# Display which image name will be used
echo "Using image name: $IMAGE_NAME"

# Build the Docker image
echo "Building Docker image..."
docker build -t "$IMAGE_NAME" -f Dockerfile ..

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "Build successful!"
    echo "To run the container, use: docker run $IMAGE_NAME"
    echo "To run in detached mode, use: docker run -d $IMAGE_NAME"
    echo "To view logs, use: docker logs -f <container_id>"
else
    echo "Build failed!"
    exit 1
fi