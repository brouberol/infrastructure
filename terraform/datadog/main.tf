terraform {
  backend "s3" {}
}

provider "datadog" {}

module "global_vars" {
  source = "../global_vars"
}


resource "datadog_monitor" "gallifrey_services" {
  name = "${title(element(module.global_vars.datadog_gallifrey_monitored_processes, count.index))} is down"
  type = "service check"
  message = "{{#is_alert}}${title(element(module.global_vars.datadog_gallifrey_monitored_processes, count.index))} is down{{/is_alert}} \n{{#is_alert_recovery}}${title(element(module.global_vars.datadog_gallifrey_monitored_processes, count.index))} is back up{{/is_alert_recovery}}  @slack-notifications"
  query = "\"process.up\".over(\"host:gallifrey\",\"process:${element(module.global_vars.datadog_gallifrey_monitored_processes, count.index)}\").last(4).count_by_status()"

  thresholds = {
    ok       = 3
    critical = 3
  }

  notify_no_data    = false
  renotify_interval = 360

  notify_audit = false
  timeout_h    = 60
  include_tags = true

  tags = ["host:gallifrey"]

  count = "${length(module.global_vars.datadog_gallifrey_monitored_processes)}"
}

resource "datadog_monitor" "nginx_can_connect" {
  name = "Web service is down"
  type = "service check"
  message = "@slack-notifications"
  query = "\"nginx.can_connect\".over(\"*\").by(\"host\",\"port\", \"server\").last(4).count_by_status()"

  thresholds = {
    ok       = 3
    critical = 3
  }

  notify_no_data    = false
  renotify_interval = 360

  notify_audit = false
  timeout_h    = 60
  include_tags = true

  tags = ["role:web"]
}

resource "datadog_monitor" "ssl_certificates_expiration" {
  name = "SSL certificate is close to expiry"
  type = "service check"
  message = "@slack-notifications"
  query = "\"http.ssl_cert\".over(\"*\").by(\"host\",\"instance\").last(4).count_by_status()"

  thresholds = {
    ok       = 3
    critical = 3
  }

  notify_no_data    = false
  renotify_interval = 360

  notify_audit = false
  timeout_h    = 60
  include_tags = true

  tags = ["role:web"]
}


resource "datadog_monitor" "hosts_up" {
  name = "Host is down"
  type = "service check"
  message = "@slack-notifications"
  query = "\"datadog.agent.up\".over(\"*\").by(\"host\").last(2).count_by_status()"

  thresholds = {
    ok       = 3
    critical = 3
  }

  notify_no_data    = true
  renotify_interval = 360

  notify_audit = false
  timeout_h    = 60
  include_tags = true

}