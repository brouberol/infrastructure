variable "subdomains" {
  description = "The balthazar-rouberol.com subdomains we CNAME to the main domain"
  type = list(string)
  default = ["stats", "blog", "irc", "bank", "ip"]
}

variable "main_domain_ip" {
  description = "The IP of the VPS behind the balthazar-rouberol.com domain"
  type = string
  default = "51.158.66.138"
}