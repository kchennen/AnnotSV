# AnnotSV Container Images

[![Build Container Images](https://github.com/kchennen/AnnotSV/actions/workflows/build-containers.yml/badge.svg)](https://github.com/kchennen/AnnotSV/actions/workflows/build-containers.yml)
[![Docker Image](https://ghcr-badge.egpl.dev/kchennen/annotsv/latest_tag?trim=major&label=ghcr.io&color=blue)](https://github.com/kchennen/AnnotSV/pkgs/container/annotsv)
[![AnnotSV](https://img.shields.io/badge/AnnotSV-v3.5.5-brightgreen)](https://github.com/lgmgeo/AnnotSV)
[![License](https://img.shields.io/github/license/kchennen/AnnotSV)](LICENSE)

Docker and Singularity container definitions for [AnnotSV v3.5.5](https://github.com/lgmgeo/AnnotSV).

**Included in the images:**
- AnnotSV v3.5.5
- Exomiser REST prioritiser JAR (v14.1.0)
- Poetry (Python dependency manager)
- bedtools, bcftools, Java, Python 3

**Not included — mount at runtime (~3.5GB total):**
- Human/mouse annotation files
- Exomiser phenotype data (`2406_phenotype.zip`)

## Downloading Annotations

Annotations (including Exomiser phenotype data) must be downloaded once on the host:

```bash
git clone --depth 1 --branch v3.5.5 https://github.com/lgmgeo/AnnotSV.git /tmp/AnnotSV
cd /tmp/AnnotSV && make PREFIX=. install && make PREFIX=. install-human-annotation
# For mouse: make PREFIX=. install-mouse-annotation
```

This creates the annotation directory at `/tmp/AnnotSV/share/AnnotSV/` (~3.5GB). Use this path (or move it wherever you like) as the mount source below.

## Docker

### Pull from GitHub Container Registry

```bash
docker pull ghcr.io/kchennen/annotsv:3.5.5
# or latest
docker pull ghcr.io/kchennen/annotsv:latest
```

### Build locally

```bash
docker build -t annotsv:3.5.5 .
```

### Run

```bash
# Show help
docker run --rm ghcr.io/kchennen/annotsv:3.5.5

# Annotate a VCF (mount annotations + data)
docker run --rm \
  -v /path/to/annotations:/opt/AnnotSV/share/AnnotSV \
  -v /path/to/data:/data \
  ghcr.io/kchennen/annotsv:3.5.5 \
  -SVinputFile /data/input.vcf \
  -outputDir /data/output
```

## Singularity

### Pull SIF from GitHub Release (recommended)

Pre-built SIF files are attached to each [GitHub Release](https://github.com/kchennen/AnnotSV/releases).

```bash
# Download directly from the release
wget https://github.com/kchennen/AnnotSV/releases/download/v3.5.5/annotsv_3.5.5.sif

# Or convert from the GHCR Docker image
singularity pull annotsv_3.5.5.sif docker://ghcr.io/kchennen/annotsv:3.5.5
```

### Build locally from Docker image

```bash
docker build -t annotsv:3.5.5 .
singularity build annotsv_3.5.5.sif docker-daemon://annotsv:3.5.5
```

### Build from definition file

```bash
sudo singularity build annotsv_3.5.5.sif AnnotSV.def
```

### Run

```bash
# Show help
singularity run annotsv_3.5.5.sif -help

# Annotate a VCF (bind-mount annotations + data)
singularity run \
  -B /path/to/annotations:/opt/AnnotSV/share/AnnotSV \
  -B /path/to/data:/data \
  annotsv_3.5.5.sif \
  -SVinputFile /data/input.vcf \
  -outputDir /data/output
```

Alternatively, use the `-annotationsDir` flag instead of mounting to the default path:

```bash
singularity run \
  -B /path/to/annotations:/annotations \
  -B /path/to/data:/data \
  annotsv_3.5.5.sif \
  -annotationsDir /annotations \
  -SVinputFile /data/input.vcf \
  -outputDir /data/output
```
