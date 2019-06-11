variable "root_domain" {
  description = "root domain"
  type = "string"
  default = "balthazar-rouberol.com"
}

variable "root_private_subdomain" {
  default = "pi"
}

variable "subdomains" {
  description = "The balthazar-rouberol.com subdomains we CNAME to the main domain"
  type = list(string)
  default = ["stats", "blog", "irc", "ip"]
}

variable "private_subdomains" {
  description = "The balthazar-rouberol.com subdomains we CNAME to the private domain"
  type = list(string)
  default = ["bank"]
}

variable "main_domain_ip" {
  description = "The IP of the VPS behind the balthazar-rouberol.com domain"
  type = string
  default = "51.158.66.138"
}

variable "rpi_local_ip" {
  description = "local IP of the raspberry pi"
  type = string
  default = "192.168.0.30"
}
