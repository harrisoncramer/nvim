FROM ubuntu:24.04@sha256:534baea6a22c03a63003dbc8dbe78fe34bc0d7e595d9a9dc9834884ff530eb55

ARG NVIM_VERSION=0.12.4
ARG NVIM_SHA256=ceb7e88c6b681f0515d135dcdfad54f5eb4373b25ce6172197cd9a69c758063f
ARG TREE_SITTER_VERSION=0.26.9
ARG TREE_SITTER_SHA256=c8feeb32115958cb44442ca4d68f6d66cf7605dbd65681e62342181ebdd6db3b
ARG NODE_VERSION=24.18.0
ARG NODE_SHA256=6b4484c2190274175df9aa8f28e2d758a819cb1c1fe6ab481e2f95b463ab8508
ARG GO_VERSION=1.26.4
ARG GO_SHA256=ef758ae7c6cf9267c9c0ef080b8965f453d89ab2d25d9eb22de4405925238768
ARG GOLANGCI_LINT_VERSION=2.12.2
ARG GOLANGCI_LINT_SHA256=44cd40a8c76c86755375adfeea52cfd3533cb43d7bd647771e0ae065e166df3a

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates git curl unzip build-essential ripgrep \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -fsSLo /tmp/nvim.tar.gz "https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-arm64.tar.gz" \
	&& echo "${NVIM_SHA256}  /tmp/nvim.tar.gz" | sha256sum -c - \
	&& tar -xzf /tmp/nvim.tar.gz -C /opt \
	&& ln -s /opt/nvim-linux-arm64/bin/nvim /usr/local/bin/nvim \
	&& rm /tmp/nvim.tar.gz

RUN curl -fsSLo /tmp/tree-sitter.gz "https://github.com/tree-sitter/tree-sitter/releases/download/v${TREE_SITTER_VERSION}/tree-sitter-linux-arm64.gz" \
	&& echo "${TREE_SITTER_SHA256}  /tmp/tree-sitter.gz" | sha256sum -c - \
	&& gunzip -c /tmp/tree-sitter.gz > /usr/local/bin/tree-sitter \
	&& chmod +x /usr/local/bin/tree-sitter \
	&& rm /tmp/tree-sitter.gz

RUN curl -fsSLo /tmp/node.tar.gz "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-arm64.tar.gz" \
	&& echo "${NODE_SHA256}  /tmp/node.tar.gz" | sha256sum -c - \
	&& mkdir /opt/node \
	&& tar -xzf /tmp/node.tar.gz -C /opt/node --strip-components=1 \
	&& rm /tmp/node.tar.gz

RUN curl -fsSLo /tmp/go.tar.gz "https://go.dev/dl/go${GO_VERSION}.linux-arm64.tar.gz" \
	&& echo "${GO_SHA256}  /tmp/go.tar.gz" | sha256sum -c - \
	&& tar -xzf /tmp/go.tar.gz -C /usr/local \
	&& rm /tmp/go.tar.gz

RUN curl -fsSLo /tmp/golangci-lint.tar.gz "https://github.com/golangci/golangci-lint/releases/download/v${GOLANGCI_LINT_VERSION}/golangci-lint-${GOLANGCI_LINT_VERSION}-linux-arm64.tar.gz" \
	&& echo "${GOLANGCI_LINT_SHA256}  /tmp/golangci-lint.tar.gz" | sha256sum -c - \
	&& tar -xzf /tmp/golangci-lint.tar.gz -C /usr/local/bin --strip-components=1 "golangci-lint-${GOLANGCI_LINT_VERSION}-linux-arm64/golangci-lint" \
	&& rm /tmp/golangci-lint.tar.gz

ENV PATH=/opt/node/bin:/usr/local/go/bin:$PATH

RUN mkdir -p /var/lib/komrad && useradd --create-home --home-dir /var/lib/komrad/home komrad
USER komrad
WORKDIR /var/lib/komrad/home
