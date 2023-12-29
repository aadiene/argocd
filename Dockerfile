# https://argo-cd.readthedocs.io/en/stable/operator-manual/custom_tools/

# Replace tag with the appropriate argo version
FROM argoproj/argocd:v2.6.15

# Switch to root for the ability to perform install
USER root

# Install tools needed for your repo-server to retrieve & decrypt secrets, render manifests 
RUN apt-get update && \
    apt-get install -y curl && \
    curl -L https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-`uname -s`-`uname -m` -o envsubst && \
    chmod +x envsubst && \
    mv envsubst /usr/local/bin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Switch back to non-root user
USER $ARGOCD_USER_ID
