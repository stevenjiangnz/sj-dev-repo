build/build.sh

#!/bin/bash

# Navigate to the directory containing this script
cd "$(dirname "$0")"

# Build the Docker image
echo "Building Docker image..."
docker build -t simple-logger -f Dockerfile ..

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "Build successful!"
    echo "To run the container, use: docker run simple-logger"
    echo "To run in detached mode, use: docker run -d simple-logger"
    echo "To view logs, use: docker logs -f <container_id>"
else
    echo "Build failed!"
fi