#!/bin/bash

# Script to install kubectl on Ubuntu arm64
echo "Starting kubectl installation..."

# Create directory for kubernetes keyring if it doesn't exist
sudo mkdir -p /etc/apt/keyrings

# Download the kubectl binary for arm64
echo "Downloading kubectl binary for arm64..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"

# Validate the binary (optional)
echo "Downloading kubectl checksum file..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl.sha256"
echo "Validating kubectl binary..."
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

# Make kubectl executable
echo "Making kubectl executable..."
chmod +x ./kubectl

# Move kubectl to a directory in PATH
echo "Moving kubectl to /usr/local/bin/..."
sudo mv ./kubectl /usr/local/bin/kubectl

# Clean up the checksum file
rm -f kubectl.sha256

# Verify installation
echo "Verifying kubectl installation..."
kubectl version --client

echo "kubectl installation complete!"
