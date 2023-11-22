#!/bin/bash
IMAGE_NAME=kali-custom
DOCKERFILE=Dockerfile

# Build image
docker build --network=host -t kali-custom -f Dockerfile-custom .

# Function to show usage
usage() {
    echo "Usage: $0 [-i | -d | -r]"
    echo "  -i: Run container interactively"
    echo "  -d: Run container as a daemon (in the background)"
    exit 1
}

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    usage
fi

# Function to build Docker image
build_image() {
    echo "Building Docker image..."
    docker build --network=host -t $IMAGE_NAME -f $DOCKERFILE .
}

# Parse command line arguments
while getopts 'idr' flag; do
  case "${flag}" in
    i)
      build_image
      docker run -it $IMAGE_NAME bash
      exit 0
      ;;
    d)
      build_image
      docker run -d $IMAGE_NAME
      exit 0
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done
