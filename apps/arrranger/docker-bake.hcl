variable "SOURCE" {
  default = "https://github.com/lucanori/arrranger"
}

variable "VERSION" {
  default = "rolling"
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
}

// This target is used by the app-builder workflow to get all platforms
target "image-all" {
  inherits = ["image"]
}