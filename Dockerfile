FROM frolvlad/alpine-glibc:alpine-3.12

LABEL maintainer="Wildlife Studios"

ARG BASH_VERSION=5.0.17-r0
ARG CURL_VERSION=7.69.1-r3
ARG GREP_VERSION=3.4-r0
ARG GIT_VERSION=2.26.2-r0
ARG JQ_VERSION=1.6-r1
ARG MAKE_VERSION=4.3-r0
ARG PYTHON_VERSION=3.8.5-r0
ARG PY3_PIP_VERSION=20.1.1-r0
ARG ZIP_VERSION=3.0-r8

ARG VAULT_VERSION=1.6.0
ARG CONFTEST_VERSION=0.22.0
ARG TFENV_VERSION=1.1.1
ARG KUBECTL_VERSION=v1.20.0

# Base dependencies
RUN apk update && \
    apk add --no-cache \
      bash=${BASH_VERSION} \
      curl=${CURL_VERSION} \
      grep=${GREP_VERSION} \
      git=${GIT_VERSION}   \
      python3=${PYTHON_VERSION} \
      make=${MAKE_VERSION} \
      py3-pip=${PY3_PIP_VERSION}  \
      jq=${JQ_VERSION} \
      zip=${ZIP_VERSION}


# Vault
RUN curl https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip --output - | \
      busybox unzip -d /usr/bin/ - && \
      chmod +x /usr/bin/vault

# conftest
RUN curl -L https://github.com/open-policy-agent/conftest/releases/download/v0.22.0/conftest_0.22.0_Linux_x86_64.tar.gz --output - | \
      tar -xzf - -C /usr/local/bin

# tfenv (terraform)
RUN git clone -b ${TFENV_VERSION} --single-branch --depth 1 \
      https://github.com/topfreegames/tfenv.git /opt/tfenv && \
      ln -s /opt/tfenv/bin/* /usr/local/bin

# AWS CLI
RUN curl -L https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip --output - | \
      busybox unzip -d /tmp/ - && \
      chmod +x -R /tmp/aws && \
      ./tmp/aws/install && \
      rm -rf ./tmp/aws

# Kubectl
ADD https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl /bin/kubectl
RUN chmod u+x /bin/kubectl

ENTRYPOINT [ "/bin/bash", "-c" ]
CMD [ "bash" ]
