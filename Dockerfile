# https://argo-cd.readthedocs.io/en/stable/operator-manual/custom_tools/

# Replace tag with the appropriate argo version
FROM argoproj/argocd:v2.6.15 

# Switch to root for the ability to perform install
USER root

# Install tools needed for your repo-server to retrieve & decrypt secrets, render manifests 
RUN apt-get update && \
    apt-get install -y envsubst && \
    apt-get clean

# Switch back to non-root user
USER $ARGOCD_USER_ID
