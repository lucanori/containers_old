target "docker-metadata-action" {}

variable "SOURCE" {
  default = "https://github.com/lucanori/arrranger"
}

variable "VERSION" {
  default = "v1.0.1"
}

target "image" {
  inherits = ["docker-metadata-action"]
  labels = {
    "org.opencontainers.image.source" = "${SOURCE}"
  }
  dockerfile = "./Dockerfile"
  context    = "."
  platforms  = [
    "linux/amd64",
    "linux/arm64"
  ]
  args = {
    BUILD_DATE = "oci.created"
    VCS_REF    = "vcs.revision"
    VCS_URL    = "vcs.url"
  }
  cache-from = [
    "type=registry,ref=ghcr.io/lucanori/build_cache:arrranger-amd64,mode=max,ignore-error=true",
    "type=registry,ref=ghcr.io/lucanori/build_cache:arrranger-arm64,mode=max,ignore-error=true"
  ]
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
}

target "image-all" {
  inherits = ["image"]
}
