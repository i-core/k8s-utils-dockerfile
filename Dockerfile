FROM alpine:3.10
ENV ANSIBLE_VER="2.7.13"
ENV PYVMOMI_VER="6.7.3"
ENV RKE_VER="v0.2.8"
ENV KUBECTL_VER="v1.13.11"
ENV HELM_VER="v2.14.3"
RUN echo "===> Installing software..." && \
    apk --update add sudo openssl ca-certificates curl wget git make openssh-client && \
    \
    echo "===> Adding Python runtime..." && \
    apk --update add python py-pip && \
    apk --update add --virtual build-dependencies \
    python-dev libffi-dev openssl-dev build-base  && \
    pip install --upgrade pip cffi && \
    \
    echo "===> Installing Ansible..." && \
    pip install "ansible==${ANSIBLE_VER}" && \
    \
    echo "===> Installing pyvmomi..." && \
    pip install "pyvmomi==${PYVMOMI_VER}" && \
    \
    echo "===> Installing rke..." && \
    curl -Lo /bin/rke https://github.com/rancher/rke/releases/download/${RKE_VER}/rke_linux-amd64 && \
    chmod +x /bin/rke && \
    \
    echo "===> Installing kubectl..." && \
    curl -Lo /bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VER}/bin/linux/amd64/kubectl && \
    chmod +x /bin/kubectl && \
    \
    echo "===> Installing helm..." && \
    curl -Lo /tmp/helm-${HELM_VER}-linux-amd64.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VER}-linux-amd64.tar.gz && \
    tar -zxvf /tmp/helm-${HELM_VER}-linux-amd64.tar.gz -C /tmp && \
    mv /tmp/linux-amd64/helm /bin/helm && \
    chmod +x /bin/helm && \
    helm init --client-only && \
    helm plugin install https://github.com/chartmuseum/helm-push && \
    \
    echo "===> Cleaning..." && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*
WORKDIR /deploy/ansible
ENTRYPOINT [ "make" ]
