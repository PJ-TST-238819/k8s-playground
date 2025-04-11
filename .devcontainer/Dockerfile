FROM ubuntu:latest

ENV USERNAME=developer

# Install Docker
RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y docker.io

# Install Docker Compose
RUN apt-get install -y docker-compose-plugin

# Install other useful tools
RUN apt-get install -y git vim curl sudo build-essential

# Create a non-root user
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN if getent group ${GROUP_ID} ; then groupmod -n ${USERNAME} $(getent group ${GROUP_ID} | cut -d: -f1); else groupadd -g ${GROUP_ID} ${USERNAME}; fi
RUN if id -u ${USER_ID} >/dev/null 2>&1; then usermod -l ${USERNAME} -d /home/${USERNAME} -m $(getent passwd ${USER_ID} | cut -d: -f1); else useradd -u ${USER_ID} -g ${USERNAME} -m ${USERNAME}; fi

# Add the user to the sudoers file
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && chmod 0440 /etc/sudoers.d/${USERNAME}

# Install kubectl
COPY install_kubectl.sh /usr/local/bin/install_kubectl.sh
RUN bash /usr/local/bin/install_kubectl.sh

# Install Kind
RUN curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
RUN chmod +x /usr/local/bin/kind

# Install Helm
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Generate SSH key
RUN mkdir -p /home/${USERNAME}/.ssh && \
  ssh-keygen -t rsa -b 4096 -f /home/${USERNAME}/.ssh/id_rsa -N "" && \
  chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh

# Copy the entrypoint script into the container
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Set ownership of the script to the non-root user
RUN chown ${USERNAME}:${USERNAME} /usr/local/bin/entrypoint.sh

# Make the script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

USER ${USERNAME}
