resource "datadog_synthetics_test" "test_sophrologie_chalon" {
  type    = "api"
  subtype = "http"
  request_definition {
    method = "GET"
    url    = "https://sophrologie-chalon.com"
  }
  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }
  locations = ["aws:eu-west-3"]
  options_list {
    min_failure_duration = 300
    min_location_failed  = 1
    monitor_name         = "sophrologie-chalon.com is down"
    monitor_priority     = 2
    no_screenshot        = false
    tick_every           = 21600

    retry {
      count    = 2
      interval = 5000
    }

    monitor_options {
      renotify_interval = 360
    }
  }
  name    = "Check that sophrologie-chalon.com is up"
  message = <<EOT
  {{#is_alert}}@webhook-Discord-alert{{/is_alert}}
  {{#is_recovery}}@webhook-Discord-recovery{{/is_recovery}}
  {{#is_no_data}}@webhook-Discord-nodata {{/is_no_data}}
  EOT
  tags    = ["site:sophrologie-chalon.com"]

  status = "live"
}
