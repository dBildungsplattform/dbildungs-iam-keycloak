# Keycloak Container Image

This repository provides a container image for running Keycloak. The container is built on Debian 12 and includes OpenJDK 17. Building different variants based on customer/project needs is supported.

## Configuration Options

### Build Arguments

* **`KEYCLOAK_VERSION`**: Version of Keycloak to be downloaded and installed. Default is `26.2.5`.
  * Example: `--build-arg KEYCLOAK_VERSION=27.0.0`

* **`KEYCLOAK_VARIANT`**: Defines the variant of Keycloak to be used. This refers to a subdirectory in `variants/` which contains an env file and supports adding more files (like themes) to keycloak.
  * `generic` (default): A general-purpose variant suitable for most use cases.
  * Example: `--build-arg KEYCLOAK_VARIANT=custom`

More basic Keycloak configurations can be found at `variants/base/env`.

### Environment Variables

During the build process, environment variables are loaded from:
* `variants/base/env`: Base environment variables common to all variants.
* `variants/<KEYCLOAK_VARIANT>/env`: Variant-specific environment variables.

These variables are used to configure Keycloak during the build process. Env vars from `base` can also be overwritten by variant env.

### Custom files

Custom files are loaded from
* `variants/base/files`: Base files common to all variants
* `variants/<KEYCLOAK_VARIANT>/files`: Variant-specific files

The files are copied to `/opt/keycloak`.

> [!TIP]
> This feature is used to deploy themes.
> To deploy a theme copy the uncompressed directory to `variants/<KEYCLOAK_VARIANT>/files/themes/<THEME_NAME>`.

## Usage

### Build the Image

To build the container image, use the following command:

```bash
podman build --build-arg KEYCLOAK_VARIANT=generic -f Dockerfile -t keycloak:dev .
```
