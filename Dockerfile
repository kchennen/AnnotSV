# AnnotSV - Annotation and Ranking of Structural Variations
# https://github.com/lgmgeo/AnnotSV
# Based on AnnotSV v3.5.5

FROM ubuntu:22.04

LABEL maintainer="kchennen@unistra.fr"
LABEL description="AnnotSV - Annotation and Ranking of Structural Variations"
LABEL version="3.5.5"

ARG ANNOTSV_VERSION=v3.5.5
ARG DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    tcl \
    tcllib \
    make \
    git \
    bedtools \
    bcftools \
    default-jre-headless \
    python3 \
    python3-pip \
    python3-venv \
    curl \
    wget \
    tar \
    unzip \
    gzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 - \
    && ln -s /root/.local/bin/poetry /usr/local/bin/poetry

# Clone and install AnnotSV (includes variantconvert via pip)
WORKDIR /opt
RUN git clone --depth 1 --branch ${ANNOTSV_VERSION} https://github.com/lgmgeo/AnnotSV.git && \
    cd AnnotSV && \
    make PREFIX=. install

# Install Exomiser REST prioritiser JAR only (USEANNODIR=1 skips phenotype data)
# Phenotype data (~2GB) is NOT bundled — mount annotations at runtime
RUN cd /opt/AnnotSV && make PREFIX=. USEANNODIR=1 install-exomiser-1

# Add AnnotSV and Poetry to PATH
ENV ANNOTSV=/opt/AnnotSV
ENV PATH="${ANNOTSV}/bin:/root/.local/bin:${PATH}"

# Annotations are NOT bundled in the image.
# Mount your annotation directory at runtime via:
#   -v /path/to/annotations:/opt/AnnotSV/share/AnnotSV
#
# To download annotations locally (includes Exomiser phenotype data):
#   git clone --depth 1 --branch v3.5.5 https://github.com/lgmgeo/AnnotSV.git /tmp/AnnotSV
#   cd /tmp/AnnotSV && make PREFIX=. install && make PREFIX=. install-human-annotation
#   Then mount /tmp/AnnotSV/share/AnnotSV into the container.

WORKDIR /data

ENTRYPOINT ["AnnotSV"]
CMD ["-help"]
