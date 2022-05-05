group "default" {
  targets = ["wit"]
}

// For docker/metadata-action
target "docker-metadata-action-wit" {}


target "wit" {
  inherits = ["docker-metadata-action-wit"]
  dockerfile = "docker/autoware-universe/Dockerfile.wit"
  target = "wit"
}
