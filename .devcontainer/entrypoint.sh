#!/bin/bash
set -e

echo "Setting up local Kubernetes cluster with Argo CD..."

# Create a K3d cluster if it doesn't exist
if ! kind get clusters | grep -q "argocd-cluster"; then
  echo "Creating kind cluster..."
  kind create cluster --name argocd-cluster --wait 5m
  
  # Configure kubectl to use the new cluster
  kind get kubeconfig --name argocd-cluster > /home/developer/.kube/config
  
  echo "Kubernetes cluster is ready."
else
  echo "Using existing kind cluster."
fi

# Create namespace for Argo CD
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

# Install Argo CD
echo "Installing Argo CD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for Argo CD to be ready
echo "Waiting for Argo CD pods to be ready..."
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s || echo "Not all pods are ready, but continuing..."

# Get the initial admin password
echo "Initial admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo ""

# Port forward the Argo CD API server
echo "Port forwarding Argo CD API server to localhost:8080..."
echo "Access the Argo CD UI at http://localhost:8080"
echo "Use username: admin and the password shown above"
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address 0.0.0.0
