#!/bin/bash
IMAGE_NAME=kali-custom
DOCKERFILE=Dockerfile
FORCE_BUILD=false

# Function to check if Docker or Podman is installed
container_tool() {
    if which docker &> /dev/null; then
        echo "docker"
    elif which podman &> /dev/null; then
        echo "podman"
    else
        echo ""
    fi
}

# Function to build image
build_image() {
    local tool=$(container_tool)
    if [ "$tool" = "" ]; then
        echo "Neither Docker nor Podman is installed. Exiting..."
        exit 1
    fi

    if $FORCE_BUILD || ! $tool image inspect $IMAGE_NAME &> /dev/null; then
        echo "Building image with $tool..."
        $tool build --network=host -t $IMAGE_NAME -f $DOCKERFILE .
    else
        echo "Skipping build: Image already exists. For a forced rebuild, use '-b' flag (e.g., $0 -b -i)."
    fi
}

# Function to run container
run_container() {
    local tool=$(container_tool)
    if [ "$tool" = "" ]; then
        echo "Neither Docker nor Podman is installed. Exiting..."
        exit 1
    fi

    $tool run "$@"
}

# Function to show usage
usage() {
    echo "Usage: $0 [-b] [-i | -d | -r]"
    echo "  -b: Force rebuild of the Docker image"
    echo "  -i: Run container interactively"
    echo "  -d: Run container as a daemon (in the background)"
    exit 1
}

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    usage
fi

# Parse command line arguments
while getopts 'bidr' flag; do
  case "${flag}" in
    b)
      FORCE_BUILD=true
      ;;
    i)
      build_image
      run_container -it $IMAGE_NAME bash
      exit 0
      ;;
    d)
      build_image
      run_container -d $IMAGE_NAME
      exit 0
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

