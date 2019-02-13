#backend for terrafom to store state
terraform {
  required_version = ">= 0.11.2"

  backend "consul" {
    address      = "localhost:8500"
    path         = "tf/state/auto-scale"
    access_token = "supersecure"
    lock         = true
  }
}
