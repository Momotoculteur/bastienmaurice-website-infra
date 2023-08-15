locals {
  domain_name         = "bastienmaurice.fr"
  bucket_name         = "bastienmaurice.fr"
  bucket_state_name   = "bastienmaurice-website-infra-state"
  dynamodb_state_name = "bastienmaurice-website-infra-state"
  commonTags = {
    createdBy     = "terraform"
    orga          = "Momotoculteur"
    repositoryFor = "bastienmaurice-website"
  }
}
