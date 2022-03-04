module "website" {
  source             = "git::git@github.com:jxeldotdev/jxel.dev.git//tf-module?ref=main"
  domains            = ["jxel.dev","www.jxel.dev"]
  zone_id            = var.zone_id
  bucket_name        = "jxel-dev-website-prod-ugh"
  service_role_group = "assume-gh-actions-role"
  service_role_name  = "website-gh-actions"
  service_user       = "website-gh-actions"
  pgp_key            = "keybase:joelfreeman"

  providers = {
    aws        = aws
    cloudflare = cloudflare
  }
}
