terraform {
  backend "s3" {}
  required_providers {
    datadog = {
      source = "datadog/datadog"
      version = "~> 3.1.0"
    }
  }
  required_version = ">= 0.13"
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
  priority = 3

  monitor_thresholds {
    ok       = 3
    critical = 3
  }

  notify_no_data    = false
  renotify_interval = 360

  notify_audit = false
  timeout_h    = 60
  include_tags = true

  tags = ["host:gallifrey"]

  count = length(module.global_vars.datadog_gallifrey_monitored_processes)
}

resource "datadog_monitor" "nginx_can_connect" {
  name = "Web service nginx config is running"
  type = "service check"
  message = module.global_vars.dd_discord_webhook
  query = "\"nginx.can_connect\".over(\"*\").by(\"host\",\"port\", \"server\").last(4).count_by_status()"
  priority = 3

  monitor_thresholds {
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

resource "datadog_monitor" "http_can_connect" {
  name = "Web service is down"
  type = "metric alert"
  message = module.global_vars.dd_discord_webhook
  query = "avg(last_2h):avg:network.http.can_connect{*} by {instance,host} < 1"
  priority = 3

  monitor_thresholds {
    critical = 1
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
  message = module.global_vars.dd_discord_webhook
  query = "\"http.ssl_cert\".over(\"*\").by(\"host\",\"instance\").last(4).count_by_status()"
  priority = 2

  monitor_thresholds {
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
  message = module.global_vars.dd_discord_webhook
  query = "\"datadog.agent.up\".over(\"*\").by(\"host\").last(3).count_by_status()"
  priority = 1

  monitor_thresholds {
    ok       = 3
    critical = 3
  }

  notify_no_data    = true
  renotify_interval = 360

  notify_audit = false
  timeout_h    = 60
  include_tags = true

}

resource "datadog_monitor" "hosts_disk_usage" {
  name = "Disk is filling up"
  type = "metric alert"
  message = module.global_vars.dd_discord_webhook
  query = "avg(last_4h):avg:system.disk.in_use{!host:${module.global_vars.pi_server_name}} by {host,device} > 0.85"
  priority = 3

  monitor_thresholds {
    warning  = 0.80
    critical = 0.85
  }

  notify_no_data    = true
  renotify_interval = 360

  notify_audit = false
  timeout_h    = 60
  include_tags = true
}

resource "datadog_monitor" "backups" {
  name = "Backup failed"
  type = "event alert"
  message = "{{#is_alert}}@webhook-Discord-alert{{/is_alert}}"
  query = "events('sources:apps priority:all status:error \"Backup\"').rollup('count').last('5m') > 0"
  priority = 3

  notify_no_data    = false
  renotify_interval = 0
  require_full_window = false

  notify_audit = false
  timeout_h    = 0
  include_tags = true

  tags = ["role:backup"]
}


resource "datadog_monitor" "grand-cedre" {
  name = "A Grand-Cedre event failed"
  type = "event alert"
  message = module.global_vars.dd_discord_webhook
  query = "events('sources:apps priority:all status:error tags:app:grand-cedre \"Grand Cedre\"').rollup('count').last('5m') > 0"
  priority = 4

  notify_no_data    = false
  renotify_interval = 0
  require_full_window = false

  notify_audit = false
  timeout_h    = 0
  include_tags = true

  tags = ["app:grand-cedre"]
}

resource "datadog_monitor" "ovh_service_expiry" {
  name = "OVH service is close to expiry"
  type = "metric alert"
  message = module.global_vars.dd_discord_webhook
  query = "min(last_1d):avg:ovh.service.remaining_days{*} by {service}.fill(linear) < 7"
  priority = 2

  monitor_thresholds {
    warning  = 30
    critical = 7
  }

  notify_no_data    = false
  renotify_interval = 360

  notify_audit = false
  timeout_h    = 60
  include_tags = true

  tags = []
}
