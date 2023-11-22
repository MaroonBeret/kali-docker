FROM kalilinux/kali-rolling

# To skip interactive stuff during install and clean up afterwards
ENV DEBIAN_FRONTEND=noninteractive

# Set the repository and install necessary tools
RUN echo 'deb http://ftp.halifax.rwth-aachen.de/kali kali-rolling main contrib non-free' > /etc/apt/sources.list && \
    apt-get update -y && \
    apt-get install -y ca-certificates apt-transport-https kali-tools-web openssh-server xrdp && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure SSH service
RUN service ssh start

# Configure RDP service (xrdp)
RUN service xrdp start

# Expose necessary ports for SSH and RDP
EXPOSE 22 3389

# Set a non-root user (optional, but recommended for security)
# RUN useradd -m kaliuser
# USER kaliuser

# Use a long-running process to keep the container alive
CMD ["tail", "-f", "/dev/null"]