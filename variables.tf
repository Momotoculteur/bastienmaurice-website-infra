variable "domain_name" {
  type        = string
  description = "nom de domaine"
}

variable "bucket_name" {
  type        = string
  description = "nom du bucket du site"
}

variable "tags" {
  description = "common tags"
  type        = map(string)
  default = {}
}

