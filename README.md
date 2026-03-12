# AnnotSV Container Images

[![Build Container Images](https://github.com/kchennen/AnnotSV/actions/workflows/build-containers.yml/badge.svg)](https://github.com/kchennen/AnnotSV/actions/workflows/build-containers.yml)
[![Docker Image](https://ghcr-badge.egpl.dev/kchennen/annotsv/latest_tag?trim=major&label=ghcr.io&color=blue)](https://github.com/kchennen/AnnotSV/pkgs/container/annotsv)
[![AnnotSV](https://img.shields.io/badge/AnnotSV-v3.5.5-brightgreen)](https://github.com/lgmgeo/AnnotSV)
[![License](https://img.shields.io/github/license/kchennen/AnnotSV)](LICENSE)

Docker and Singularity container definitions for [AnnotSV v3.5.5](https://github.com/lgmgeo/AnnotSV).

Annotations are **not** included in the images. They must be downloaded once on the host and mounted into the container at runtime.

## Downloading Annotations

```bash
git clone --depth 1 --branch v3.5.5 https://github.com/lgmgeo/AnnotSV.git /tmp/AnnotSV
cd /tmp/AnnotSV && make PREFIX=. install && make PREFIX=. install-human-annotation
# For mouse: make PREFIX=. install-mouse-annotation
```

This creates the annotation directory at `/tmp/AnnotSV/share/AnnotSV/`. Use this path (or move it wherever you like) as the mount source below.

## Docker

### Build

```bash
docker build -t annotsv:3.5.5 .
```

### Run

```bash
# Show help
docker run --rm annotsv:3.5.5

# Annotate a VCF (mount annotations + data)
docker run --rm \
  -v /path/to/annotations:/opt/AnnotSV/share/AnnotSV \
  -v /path/to/data:/data \
  annotsv:3.5.5 \
  -SVinputFile /data/input.vcf \
  -outputDir /data/output
```

## Singularity

### Build from Docker image (recommended)

```bash
docker build -t annotsv:3.5.5 .
singularity build annotsv.sif docker-daemon://annotsv:3.5.5
```

### Build from definition file

```bash
sudo singularity build annotsv.sif AnnotSV.def
```

### Run

```bash
# Show help
singularity run annotsv.sif -help

# Annotate a VCF (bind-mount annotations + data)
singularity run \
  -B /path/to/annotations:/opt/AnnotSV/share/AnnotSV \
  -B /path/to/data:/data \
  annotsv.sif \
  -SVinputFile /data/input.vcf \
  -outputDir /data/output
```

Alternatively, use the `-annotationsDir` flag instead of mounting to the default path:

```bash
singularity run \
  -B /path/to/annotations:/annotations \
  -B /path/to/data:/data \
  annotsv.sif \
  -annotationsDir /annotations \
  -SVinputFile /data/input.vcf \
  -outputDir /data/output
```
