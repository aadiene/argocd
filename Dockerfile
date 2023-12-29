# https://argo-cd.readthedocs.io/en/stable/operator-manual/custom_tools/
# https://docs.docker.com/desktop/extensions-sdk/extensions/multi-arch/

# Replace tag with the appropriate argo version
FROM argoproj/argocd:v2.6.15

# Retrieve target architecture from --platform (e.g. arm64 or arm64)
ARG TARGETARCH

# Switch to root for the ability to perform install
USER root

# Install tools needed for your repo-server to retrieve & decrypt secrets, render manifests 
# Workaround for "envsubst" multi-arch binaries
# curl -L https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-`uname -s`-`uname -m`
# Previous command should be enough but does not work when "uname -m" returns "aarch64" which is the same as "arm64" 
RUN <<EOT sh
    apt-get update && \
        apt-get install -y curl && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
    if [ "$TARGETARCH" = "arm64" ]; then
        curl -L https://github.com/a8m/envsubst/releases/download/v1.4.2/envsubst-Linux-arm64 -o envsubst
    else     
        curl -L https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-`uname -s`-`uname -m` -o envsubst
    fi
    chmod +x envsubst && mv envsubst /usr/local/bin
EOT

# Switch back to non-root user
USER $ARGOCD_USER_ID
