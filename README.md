# AnnotSV Container Images

Docker and Singularity container definitions for [AnnotSV v3.5.5](https://github.com/lgmgeo/AnnotSV).

## Docker

### Build

```bash
docker build -t annotsv:3.5.5 .
```

To skip downloading annotations during build (mount them at runtime instead), comment out the `install-human-annotation` line in the Dockerfile.

### Run

```bash
# Show help
docker run --rm annotsv:3.5.5

# Annotate a VCF
docker run --rm -v /path/to/data:/data annotsv:3.5.5 \
  -SVinputFile /data/input.vcf \
  -outputDir /data/output
```

## Singularity

### Build from Docker image (recommended)

```bash
# Build the Docker image first, then convert to SIF
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

# Annotate a VCF
singularity run -B /path/to/data:/data annotsv.sif \
  -SVinputFile /data/input.vcf \
  -outputDir /data/output
```

## Notes

- Human annotations (~1.5GB) are downloaded during build by default. To use external annotations instead, comment out the `install-human-annotation` line and bind-mount your annotation directory.
- For mouse annotations, add `make PREFIX=. install-mouse-annotation` to the build.
