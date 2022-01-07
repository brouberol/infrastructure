resource "datadog_monitor" "gallifrey_services" {
  name     = "${title(element(module.global_vars.datadog_gallifrey_monitored_processes, count.index))} is down"
  type     = "service check"
  message  = "{{#is_alert}}${title(element(module.global_vars.datadog_gallifrey_monitored_processes, count.index))} is down{{/is_alert}} \n{{#is_alert_recovery}}${title(element(module.global_vars.datadog_gallifrey_monitored_processes, count.index))} is back up{{/is_alert_recovery}}  @slack-notifications"
  query    = "\"process.up\".over(\"host:gallifrey\",\"process:${element(module.global_vars.datadog_gallifrey_monitored_processes, count.index)}\").last(4).count_by_status()"
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
  name     = "Web service nginx config is running"
  type     = "service check"
  message  = module.global_vars.dd_discord_webhook
  query    = "\"nginx.can_connect\".over(\"*\").by(\"host\",\"port\", \"server\").last(4).count_by_status()"
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
  name     = "Web service is down"
  type     = "metric alert"
  message  = module.global_vars.dd_discord_webhook
  query    = "avg(last_2h):avg:network.http.can_connect{*} by {instance,host} < 1"
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
  name     = "SSL certificate is close to expiry"
  type     = "service check"
  message  = module.global_vars.dd_discord_webhook
  query    = "\"http.ssl_cert\".over(\"*\").by(\"host\",\"instance\").last(4).count_by_status()"
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
  name     = "Host is down"
  type     = "service check"
  message  = module.global_vars.dd_discord_webhook
  query    = "\"datadog.agent.up\".over(\"*\").by(\"host\").last(3).count_by_status()"
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
  name     = "Disk is filling up"
  type     = "metric alert"
  message  = module.global_vars.dd_discord_webhook
  query    = "avg(last_4h):avg:system.disk.in_use{!host:${module.global_vars.pi_server_name}} by {host,device} > 0.85"
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
  name     = "Backup failed"
  type     = "event alert"
  message  = "{{#is_alert}}@webhook-Discord-alert{{/is_alert}}"
  query    = "events('sources:apps priority:all status:error \"Backup\"').rollup('count').last('5m') > 0"
  priority = 3

  notify_no_data      = false
  renotify_interval   = 0
  require_full_window = false

  notify_audit = false
  timeout_h    = 0
  include_tags = true

  tags = ["role:backup"]
}

resource "datadog_monitor" "ovh_service_expiry" {
  name     = "OVH service is close to expiry"
  type     = "metric alert"
  message  = module.global_vars.dd_discord_webhook
  query    = "min(last_1d):avg:ovh.service.remaining_days{*} by {service}.fill(linear) < 7"
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

resource "datadog_monitor" "new_blog_comment" {
  name     = "New comment received on blog"
  type     = "metric alert"
  message  = "A new comment has been issued on the blog. Visit the Isso admin to review. {{#is_alert}}@webhook-Discord-warning{{/is_alert}}"
  query    = "change(max(last_2h),last_4h):default_zero(sum:blog.comments{*}) >= 1"
  priority = 5

  monitor_thresholds {
    critical = 1
  }

  notify_no_data    = false
  renotify_interval = 0

  notify_audit = false
  timeout_h    = 0
  include_tags = false

  tags = []
}

resource "datadog_monitor" "chassezac_in_high_alert" {
  name    = "Chassezac in red alert"
  type    = "metric alert"
  message = "{{#is_no_data}}@webhook-Discord-nodata {{/is_no_data}} {{#is_alert}} @webhook-Discord-alert @pagerduty-Chassezac  Niveau rouge!{{/is_alert}}{{#is_warning}}@webhook-Discord-warning Niveau orange{{/is_warning}}{{#is_recovery}}@webhook-Discord-recovery{{/is_recovery}}"
  query   = "avg(last_5m):avg:river.alert_level{river:chassezac} >= 3"

  monitor_thresholds {
    critical = 3
    warning  = 2
  }

  notify_no_data    = true
  no_data_timeframe = 120
  renotify_interval = 0

  notify_audit = false
  timeout_h    = 0
  include_tags = false
  priority     = 1
  tags = [
    "river:chassezac",
    "source:weather"
  ]
}

resource "datadog_monitor" "river_level_is_high" {
  name    = "River level is high"
  type    = "metric alert"
  message = "{{#is_no_data}}@webhook-Discord-nodata {{/is_no_data}} {{#is_alert}} @webhook-Discord-alert @pagerduty-Chassezac Niveau rouge!{{/is_alert}}{{#is_warning}}@webhook-Discord-warning Niveau orange{{/is_warning}}{{#is_recovery}}@webhook-Discord-recovery{{/is_recovery}}"
  query   = "max(last_15m):avg:river.level{station:gravieres} > 5"

  monitor_thresholds {
    critical = 5
    warning  = 4
  }

  notify_no_data    = true
  no_data_timeframe = 120
  renotify_interval = 0

  notify_audit = false
  timeout_h    = 0
  include_tags = false
  priority     = 1
  tags = [
    "river:chassezac",
    "source:weather"
  ]
}


resource "datadog_monitor" "fioul_price_is_low" {
  name    = "Fioul price is low"
  type    = "metric alert"
  message = "Fioul price currently sits at {{value}}€/L. Consider buying some if required. @webhook-Discord-warning"
  query   = "max(last_1d):avg:fioul.price.1l{*} < 0.8"

  monitor_thresholds {
    critical = 0.8
    warning  = 0.9
  }

  notify_no_data      = false
  require_full_window = false
  no_data_timeframe   = 0
  renotify_interval   = 0

  notify_audit = false
  timeout_h    = 0
  include_tags = true
  priority     = 4
  tags         = []
}


resource "datadog_monitor" "cesu_reporting" {
  name     = "CESU reporting failed"
  type     = "event alert"
  message  = "{{#is_alert}}@webhook-Discord-alert{{/is_alert}}"
  query    = "events('sources:apps priority:all status:error \"CESU\"').rollup('count').last('5m') > 0"
  priority = 3

  notify_no_data      = false
  renotify_interval   = 0
  require_full_window = false

  notify_audit = false
  timeout_h    = 0
  include_tags = true

  tags = []
}


resource "datadog_monitor" "isp_router_is_down" {
  name    = "DSL Router is down"
  type    = "metric alert"
  message = "{{#is_no_data}}@webhook-Discord-nodata{{/is_no_data}}{{#is_alert}} The router for ISP {{isp.name}} is down!  {{#is_exact_match \"isp.name\" \"sosh\"}}Go to https://www.sosh.fr/tester-depanner-internet and test the state of the line, with line number ${module.global_vars.sosh_line_number}. {{/is_exact_match}} {{#is_exact_match \"isp.name\" \"ovh\"}} Go to https://www.ovh.com/manager/ and check the state of the line. {{/is_exact_match}} @webhook-Discord-alert {{/is_alert}} {{#is_recovery}} The router for ISP {{isp.name}} is up! @webhook-Discord-recovery {{/is_recovery}}"
  query   = "avg(last_15m):avg:otb.wan.status{*} by {isp} < 1"

  monitor_thresholds {
    critical = 1
  }
  notify_no_data      = true
  require_full_window = false
  no_data_timeframe   = 0
  renotify_interval   = 0

  notify_audit = false
  timeout_h    = 0
  include_tags = true
  priority     = 2
  tags         = []
}
