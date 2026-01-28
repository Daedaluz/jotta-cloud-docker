# Jotta Cloud CLI Container

A Docker container for running the Jotta Cloud CLI (`jotta-cli`) daemon. This container provides a lightweight way to run Jotta Cloud's backup and sync service in a containerized environment.

## What is Jotta Cloud?

Jotta Cloud is a cloud storage and backup service. The `jotta-cli` provides command-line access to Jotta Cloud services, allowing you to sync and backup files.

## Pre-built Images

Pre-built multi-architecture images (amd64 and arm64) are available on GitHub Container Registry:

```bash
docker pull ghcr.io/daedaluz/jottad:latest
```

Or use a specific tag:

```bash
docker pull ghcr.io/daedaluz/jottad:main
```

## Building the Container

### Local Build

```bash
docker build -t jottad .
```

### Multi-architecture Build

To build for both amd64 and arm64 locally (requires Docker Buildx):

```bash
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64 -t jottad .
```

## Running the Container

### Basic Usage

Using the pre-built image:

```bash
docker run -d \
  --name jottad \
  -v /path/to/your/data:/data \
  ghcr.io/daedaluz/jottad:latest
```

Or using a locally built image:

```bash
docker run -d \
  --name jottad \
  -v /path/to/your/data:/data \
  jottad
```

### With Environment Variables

```bash
docker run -d \
  --name jottad \
  -e DATA_DIR=/custom/data \
  -v /path/to/your/data:/custom/data \
  jottad
```

## Configuration

### Environment Variables

- `DATA_DIR` (default: `/data`): Directory where Jotta Cloud stores its data and configuration

### Volumes

- `/data`: Mount point for Jotta Cloud data directory. This should be a persistent volume to preserve configuration and sync state.

## First-Time Setup

After starting the container for the first time, you'll need to authenticate with Jotta Cloud:

```bash
# Enter the container
docker exec -it jottad bash

# Run the setup/authentication command
jotta-cli setup
```

Follow the prompts to authenticate with your Jotta Cloud account.

## Usage Examples

### View Status

```bash
docker exec jottad jotta-cli status
```

### Sync a Directory

```bash
docker exec jottad jotta-cli sync /path/to/sync
```

### View Logs

```bash
docker logs jottad
```

## Docker Compose Example

```yaml
version: '3.8'

services:
  jottad:
    image: ghcr.io/daedaluz/jottad:latest
    # Or build locally:
    # build: .
    container_name: jottad
    volumes:
      - ./jotta-data:/data
    environment:
      - DATA_DIR=/data
    restart: unless-stopped
```

## CI/CD

This repository includes a GitHub Actions workflow (`.github/workflows/build.yml`) that automatically builds and pushes multi-architecture Docker images (amd64 and arm64) to GitHub Container Registry on:
- Pushes to `main` or `master` branches
- Tagged releases (e.g., `v1.0.0`)
- Manual workflow dispatch

The workflow uses Docker Buildx for multi-platform builds and GitHub Actions cache for faster builds.

## Notes

- The container runs `jottad` (Jotta daemon) with stdout logging enabled
- Data persistence is important - ensure the `/data` volume is properly mounted
- The container is based on Debian Bookworm Slim for a minimal footprint
- Pre-built images support both amd64 and arm64 architectures

## License

This container image includes the Jotta Cloud CLI, which is subject to Jotta Cloud's terms of service and licensing.
