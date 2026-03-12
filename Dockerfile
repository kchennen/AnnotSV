# AnnotSV - Annotation and Ranking of Structural Variations
# https://github.com/lgmgeo/AnnotSV
# Based on AnnotSV v3.5.5

FROM ubuntu:22.04

LABEL maintainer="AnnotSV Container"
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
    curl \
    wget \
    tar \
    unzip \
    gzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone and install AnnotSV
WORKDIR /opt
RUN git clone --depth 1 --branch ${ANNOTSV_VERSION} https://github.com/lgmgeo/AnnotSV.git && \
    cd AnnotSV && \
    make PREFIX=. install

# Download human annotations (large ~1.5GB)
# Comment out the next line if you prefer to mount annotations at runtime
RUN cd /opt/AnnotSV && make PREFIX=. install-human-annotation

# Add AnnotSV to PATH
ENV ANNOTSV=/opt/AnnotSV
ENV PATH="${ANNOTSV}/bin:${PATH}"

WORKDIR /data

ENTRYPOINT ["AnnotSV"]
CMD ["-help"]
