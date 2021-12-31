resource "datadog_dashboard_json" "blog_dash" {
  dashboard = <<EOF
{
  "title": "Blog",
  "description": "",
  "widgets": [
    {
      "id": 821407925491091,
      "definition": {
        "title": "Total views",
        "type": "query_value",
        "requests": [
          {
            "q": "sum:blog.audience.views{*}.rollup(sum, 3600)",
            "aggregator": "sum"
          }
        ],
        "autoscale": true,
        "precision": 2
      }
    },
    {
      "id": 5473644944622776,
      "definition": {
        "title": "Views / article / hour",
        "show_legend": false,
        "legend_size": "0",
        "type": "timeseries",
        "requests": [
          {
            "q": "avg:blog.audience.views{*} by {article}.rollup(sum, 3600)",
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "bars"
          }
        ],
        "yaxis": {
          "include_zero": true,
          "scale": "linear",
          "label": "",
          "min": "auto",
          "max": "auto"
        }
      }
    },
    {
      "id": 3377056381473567,
      "definition": {
        "title": "Views / article / day",
        "show_legend": false,
        "legend_size": "0",
        "type": "timeseries",
        "requests": [
          {
            "q": "sum:blog.audience.views{*} by {article}.rollup(sum, 86400)",
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "bars"
          }
        ],
        "yaxis": {
          "include_zero": true,
          "scale": "linear",
          "label": "",
          "min": "auto",
          "max": "auto"
        }
      }
    },
    {
      "id": 7241470308474437,
      "definition": {
        "title": "Top articles",
        "type": "toplist",
        "requests": [
          {
            "q": "sum:blog.audience.views{*} by {article}.rollup(sum, 3600)"
          }
        ]
      }
    },
    {
      "id": 7634825612360098,
      "definition": {
        "title": "Origin of visitors",
        "show_legend": false,
        "legend_size": "0",
        "type": "timeseries",
        "requests": [
          {
            "q": "sum:blog.audience.visitors_by_origin{*} by {origin}.rollup(sum, 3600)",
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "bars"
          }
        ],
        "yaxis": {
          "include_zero": true,
          "scale": "linear",
          "label": "",
          "min": "auto",
          "max": "auto"
        }
      }
    },
    {
      "id": 422758922587104,
      "definition": {
        "title": "Comments / article",
        "show_legend": false,
        "legend_size": "0",
        "type": "timeseries",
        "requests": [
          {
            "q": "avg:blog.comments{*} by {article}.rollup(avg, 3600)",
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "bars"
          }
        ],
        "yaxis": {
          "include_zero": true,
          "scale": "linear",
          "label": "",
          "min": "auto",
          "max": "auto"
        }
      }
    },
    {
      "id": 5855205989488732,
      "definition": {
        "title": "Reddit score / article",
        "show_legend": false,
        "legend_size": "0",
        "type": "timeseries",
        "requests": [
          {
            "q": "sum:reddit.post.score{*} by {article}.rollup(avg, 3600)",
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "bars"
          }
        ],
        "yaxis": {
          "include_zero": true,
          "scale": "linear",
          "label": "",
          "min": "auto",
          "max": "auto"
        }
      }
    },
    {
      "id": 3117760025303987,
      "definition": {
        "title": "Reddit comments / article",
        "show_legend": false,
        "legend_size": "0",
        "type": "timeseries",
        "requests": [
          {
            "q": "sum:reddit.post.comments{*} by {article}.rollup(avg, 3600)",
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "bars"
          }
        ],
        "yaxis": {
          "include_zero": true,
          "scale": "linear",
          "label": "",
          "min": "auto",
          "max": "auto"
        }
      }
    },
    {
      "id": 4068795320911553,
      "definition": {
        "title": "Lobsters score / article",
        "show_legend": false,
        "legend_size": "0",
        "type": "timeseries",
        "requests": [
          {
            "q": "sum:lobsters.post.score{*} by {article}.rollup(avg, 3600)",
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "bars"
          }
        ],
        "yaxis": {
          "include_zero": true,
          "scale": "linear",
          "label": "",
          "min": "auto",
          "max": "auto"
        }
      }
    },
    {
      "id": 4296785473185840,
      "definition": {
        "title": "Lobsters comments / article",
        "show_legend": false,
        "legend_size": "0",
        "type": "timeseries",
        "requests": [
          {
            "q": "avg:lobsters.post.comments{*} by {article}.rollup(avg, 3600)",
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "bars"
          }
        ],
        "yaxis": {
          "include_zero": true,
          "scale": "linear",
          "label": "",
          "min": "auto",
          "max": "auto"
        }
      }
    }
  ],
  "template_variables": [],
  "layout_type": "ordered",
  "is_read_only": false,
  "notify_list": [],
  "reflow_type": "auto",
  "id": "2bb-fmg-f2g"
}
    EOF
}


resource "datadog_dashboard_json" "essential_tools_dash" {
  dashboard = <<EOF
{
    "title": "Essential tools",
    "description": "",
    "widgets": [
        {
            "id": 4441056324729372,
            "definition": {
                "title": "Audience",
                "type": "group",
                "layout_type": "ordered",
                "widgets": [
                    {
                        "id": 8439556386530818,
                        "definition": {
                            "title": "Blog pageviews",
                            "show_legend": false,
                            "legend_size": "0",
                            "type": "timeseries",
                            "requests": [
                                {
                                    "q": "avg:blog.audience.views{campaign:essential-tools,$article} by {article}.rollup(sum, 3600)",
                                    "style": {
                                        "palette": "cool",
                                        "line_type": "solid",
                                        "line_width": "normal"
                                    },
                                    "display_type": "bars"
                                }
                            ],
                            "yaxis": {
                                "include_zero": true,
                                "scale": "linear",
                                "label": "",
                                "min": "auto",
                                "max": "auto"
                            }
                        }
                    },
                    {
                        "id": 748454957558065,
                        "definition": {
                            "title": "Blog unique visitors",
                            "show_legend": false,
                            "legend_size": "0",
                            "type": "timeseries",
                            "requests": [
                                {
                                    "q": "avg:blog.audience.visitors{campaign:essential-tools,$article} by {article}.rollup(sum, 3600)",
                                    "style": {
                                        "palette": "cool",
                                        "line_type": "solid",
                                        "line_width": "normal"
                                    },
                                    "display_type": "bars"
                                }
                            ],
                            "yaxis": {
                                "include_zero": true,
                                "scale": "linear",
                                "label": "",
                                "min": "auto",
                                "max": "auto"
                            }
                        }
                    },
                    {
                        "id": 4690653536882641,
                        "definition": {
                            "title": "Top articles",
                            "type": "toplist",
                            "requests": [
                                {
                                    "q": "sum:blog.audience.views{$article,campaign:essential-tools} by {article}.rollup(sum, 3600)"
                                }
                            ]
                        }
                    },
                    {
                        "id": 3388638247176929,
                        "definition": {
                            "title": "Comments on blogposts",
                            "show_legend": false,
                            "legend_size": "0",
                            "type": "timeseries",
                            "requests": [
                                {
                                    "q": "avg:blog.comments{campaign:essential-tools,$article} by {article}.rollup(avg, 3600)",
                                    "style": {
                                        "palette": "dog_classic",
                                        "line_type": "solid",
                                        "line_width": "normal"
                                    },
                                    "display_type": "bars"
                                }
                            ],
                            "yaxis": {
                                "include_zero": true,
                                "scale": "linear",
                                "label": "",
                                "min": "auto",
                                "max": "auto"
                            }
                        }
                    },
                    {
                        "id": 4373855321778107,
                        "definition": {
                            "title": "Dev.to total views / article",
                            "show_legend": false,
                            "legend_size": "0",
                            "type": "timeseries",
                            "requests": [
                                {
                                    "q": "avg:devto.audience.views{campaign:essential-tools,$article} by {article}.rollup(avg, 3600)",
                                    "style": {
                                        "palette": "dog_classic",
                                        "line_type": "solid",
                                        "line_width": "normal"
                                    },
                                    "display_type": "bars"
                                }
                            ],
                            "yaxis": {
                                "include_zero": true,
                                "scale": "linear",
                                "label": "",
                                "min": "auto",
                                "max": "auto"
                            }
                        }
                    },
                    {
                        "id": 6676615285317015,
                        "definition": {
                            "title": "Dev.to total likes / article",
                            "show_legend": false,
                            "legend_size": "0",
                            "type": "timeseries",
                            "requests": [
                                {
                                    "q": "avg:devto.audience.likes{campaign:essential-tools,$article} by {article}.rollup(avg, 3600)",
                                    "style": {
                                        "palette": "dog_classic",
                                        "line_type": "solid",
                                        "line_width": "normal"
                                    },
                                    "display_type": "bars"
                                }
                            ],
                            "yaxis": {
                                "include_zero": true,
                                "scale": "linear",
                                "label": "",
                                "min": "auto",
                                "max": "auto"
                            }
                        }
                    },
                    {
                        "id": 4253072714564429,
                        "definition": {
                            "title": "Dev.to total comments / article",
                            "show_legend": false,
                            "legend_size": "0",
                            "type": "timeseries",
                            "requests": [
                                {
                                    "q": "avg:devto.audience.comments{campaign:essential-tools,$article} by {article}.rollup(avg, 3600)",
                                    "style": {
                                        "palette": "dog_classic",
                                        "line_type": "solid",
                                        "line_width": "normal"
                                    },
                                    "display_type": "bars"
                                }
                            ],
                            "yaxis": {
                                "include_zero": true,
                                "scale": "linear",
                                "label": "",
                                "min": "auto",
                                "max": "auto"
                            }
                        }
                    },
                    {
                        "id": 779391492227971,
                        "definition": {
                            "title": "Reddit score ",
                            "show_legend": false,
                            "legend_size": "0",
                            "type": "timeseries",
                            "requests": [
                                {
                                    "q": "avg:reddit.post.score{campaign:essential-tools,$article} by {article,subreddit}.rollup(avg, 3600)",
                                    "style": {
                                        "palette": "dog_classic",
                                        "line_type": "solid",
                                        "line_width": "normal"
                                    },
                                    "display_type": "bars"
                                }
                            ],
                            "yaxis": {
                                "include_zero": true,
                                "scale": "linear",
                                "label": "",
                                "min": "auto",
                                "max": "auto"
                            }
                        }
                    },
                    {
                        "id": 3275722263635786,
                        "definition": {
                            "title": "Reddit comments",
                            "show_legend": false,
                            "legend_size": "0",
                            "type": "timeseries",
                            "requests": [
                                {
                                    "q": "avg:reddit.post.comments{campaign:essential-tools,$article} by {article,subreddit}.rollup(avg, 3600)",
                                    "style": {
                                        "palette": "dog_classic",
                                        "line_type": "solid",
                                        "line_width": "normal"
                                    },
                                    "display_type": "bars"
                                }
                            ],
                            "yaxis": {
                                "include_zero": true,
                                "scale": "linear",
                                "label": "",
                                "min": "auto",
                                "max": "auto"
                            }
                        }
                    },
                    {
                        "id": 5507084986759924,
                        "definition": {
                            "title": "Lobsters score",
                            "show_legend": false,
                            "legend_size": "0",
                            "type": "timeseries",
                            "requests": [
                                {
                                    "q": "sum:lobsters.post.score{$article,campaign:essential-tools} by {article}.rollup(avg, 3600)",
                                    "style": {
                                        "palette": "dog_classic",
                                        "line_type": "solid",
                                        "line_width": "normal"
                                    },
                                    "display_type": "bars"
                                }
                            ],
                            "yaxis": {
                                "include_zero": true,
                                "scale": "linear",
                                "label": "",
                                "min": "auto",
                                "max": "auto"
                            }
                        }
                    },
                    {
                        "id": 6189961436072455,
                        "definition": {
                            "title": "Lobsters comments",
                            "show_legend": false,
                            "legend_size": "0",
                            "type": "timeseries",
                            "requests": [
                                {
                                    "q": "avg:lobsters.post.comments{$article,campaign:essential-tools} by {article}.rollup(avg, 3600)",
                                    "style": {
                                        "palette": "dog_classic",
                                        "line_type": "solid",
                                        "line_width": "normal"
                                    },
                                    "display_type": "bars"
                                }
                            ],
                            "yaxis": {
                                "include_zero": true,
                                "scale": "linear",
                                "label": "",
                                "min": "auto",
                                "max": "auto"
                            }
                        }
                    }
                ]
            }
        },
        {
            "id": 6622405824602216,
            "definition": {
                "title": "Mailchimp",
                "type": "group",
                "layout_type": "ordered",
                "widgets": [
                    {
                        "id": 4328225908698146,
                        "definition": {
                            "title": "Subscribed members",
                            "type": "query_value",
                            "requests": [
                                {
                                    "q": "avg:mailchimp.list.member_count{campaign:essential-tools}",
                                    "aggregator": "last"
                                }
                            ],
                            "autoscale": true,
                            "precision": 2
                        }
                    },
                    {
                        "id": 2442940939323064,
                        "definition": {
                            "title": "Subscribed members",
                            "show_legend": false,
                            "legend_size": "0",
                            "type": "timeseries",
                            "requests": [
                                {
                                    "q": "avg:mailchimp.list.member_count{campaign:essential-tools}.rollup(avg, 3600)",
                                    "style": {
                                        "palette": "dog_classic",
                                        "line_type": "solid",
                                        "line_width": "normal"
                                    },
                                    "display_type": "bars"
                                }
                            ],
                            "yaxis": {
                                "include_zero": true,
                                "scale": "linear",
                                "label": "",
                                "min": "auto",
                                "max": "auto"
                            }
                        }
                    },
                    {
                        "id": 6697551379917321,
                        "definition": {
                            "title": "Members / country",
                            "show_legend": false,
                            "legend_size": "0",
                            "type": "timeseries",
                            "requests": [
                                {
                                    "q": "avg:mailchimp.members_per_country{*} by {country}.rollup(avg, 3600)",
                                    "style": {
                                        "palette": "dog_classic",
                                        "line_type": "solid",
                                        "line_width": "normal"
                                    },
                                    "display_type": "bars"
                                }
                            ],
                            "yaxis": {
                                "include_zero": true,
                                "scale": "linear",
                                "label": "",
                                "min": "auto",
                                "max": "auto"
                            }
                        }
                    },
                    {
                        "id": 5380971156105520,
                        "definition": {
                            "title": "New members / country",
                            "type": "change",
                            "requests": [
                                {
                                    "change_type": "absolute",
                                    "order_dir": "desc",
                                    "compare_to": "day_before",
                                    "q": "max:mailchimp.members_per_country{campaign:essential-tools} by {country}",
                                    "show_present": true,
                                    "increase_good": true,
                                    "order_by": "change"
                                }
                            ]
                        }
                    },
                    {
                        "id": 4784439640924849,
                        "definition": {
                            "title": "Unsubscribed members",
                            "show_legend": false,
                            "legend_size": "0",
                            "type": "timeseries",
                            "requests": [
                                {
                                    "q": "avg:mailchimp.list.unsubscribe_count{campaign:essential-tools}.rollup(avg, 3600)",
                                    "style": {
                                        "palette": "warm",
                                        "line_type": "solid",
                                        "line_width": "normal"
                                    },
                                    "display_type": "bars"
                                }
                            ],
                            "yaxis": {
                                "include_zero": true,
                                "scale": "linear",
                                "label": "",
                                "min": "auto",
                                "max": "auto"
                            }
                        }
                    },
                    {
                        "id": 7389190076352571,
                        "definition": {
                            "title": "Members since last send",
                            "show_legend": false,
                            "legend_size": "0",
                            "type": "timeseries",
                            "requests": [
                                {
                                    "q": "avg:mailchimp.list.member_count_since_send{campaign:essential-tools}.rollup(avg, 3600)",
                                    "style": {
                                        "palette": "dog_classic",
                                        "line_type": "solid",
                                        "line_width": "normal"
                                    },
                                    "display_type": "bars"
                                }
                            ],
                            "yaxis": {
                                "include_zero": true,
                                "scale": "linear",
                                "label": "",
                                "min": "auto",
                                "max": "auto"
                            }
                        }
                    },
                    {
                        "id": 2377089430881280,
                        "definition": {
                            "title": "Unsubscribes since last send",
                            "show_legend": false,
                            "legend_size": "0",
                            "type": "timeseries",
                            "requests": [
                                {
                                    "q": "avg:mailchimp.list.unsubscribe_count_since_send{campaign:essential-tools}.rollup(avg, 3600)",
                                    "style": {
                                        "palette": "warm",
                                        "line_type": "solid",
                                        "line_width": "normal"
                                    },
                                    "display_type": "bars"
                                }
                            ],
                            "yaxis": {
                                "include_zero": true,
                                "scale": "linear",
                                "label": "",
                                "min": "auto",
                                "max": "auto"
                            }
                        }
                    },
                    {
                        "id": 221883680865912,
                        "definition": {
                            "title": "Click rate",
                            "show_legend": false,
                            "legend_size": "0",
                            "type": "timeseries",
                            "requests": [
                                {
                                    "q": "avg:mailchimp.list.click_rate{campaign:essential-tools}.rollup(avg, 3600)",
                                    "style": {
                                        "palette": "dog_classic",
                                        "line_type": "solid",
                                        "line_width": "normal"
                                    },
                                    "display_type": "bars"
                                }
                            ],
                            "yaxis": {
                                "include_zero": true,
                                "scale": "linear",
                                "label": "",
                                "min": "auto",
                                "max": "auto"
                            }
                        }
                    },
                    {
                        "id": 7827368085527716,
                        "definition": {
                            "title": "Open rate",
                            "show_legend": false,
                            "legend_size": "0",
                            "type": "timeseries",
                            "requests": [
                                {
                                    "q": "avg:mailchimp.list.open_rate{campaign:essential-tools}.rollup(avg, 3600)",
                                    "style": {
                                        "palette": "dog_classic",
                                        "line_type": "solid",
                                        "line_width": "normal"
                                    },
                                    "display_type": "bars"
                                }
                            ],
                            "yaxis": {
                                "include_zero": true,
                                "scale": "linear",
                                "label": "",
                                "min": "auto",
                                "max": "auto"
                            }
                        }
                    }
                ]
            }
        }
    ],
    "template_variables": [
        {
            "name": "article",
            "default": "*",
            "prefix": "article",
            "available_values": []
        }
    ],
    "layout_type": "ordered",
    "is_read_only": false,
    "notify_list": [],
    "reflow_type": "auto",
    "id": "d25-gyz-m8v"
}
  EOF
}

resource "datadog_dashboard_json" "web_services_dash" {
  dashboard = <<EOF
{
    "title": "Web services",
    "description": "",
    "widgets": [
        {
            "id": 1563176117928961,
            "definition": {
                "title": "Web services UP",
                "type": "toplist",
                "requests": [
                    {
                        "q": "top(avg:network.http.can_connect{*} by {host,instance}, 25, 'mean', 'asc')",
                        "conditional_formats": [
                            {
                                "comparator": "<",
                                "palette": "white_on_red",
                                "value": 1
                            },
                            {
                                "comparator": ">=",
                                "palette": "white_on_green",
                                "value": 1
                            }
                        ]
                    }
                ]
            }
        },
        {
            "id": 7260551673026027,
            "definition": {
                "title": "Web services UP",
                "show_legend": false,
                "legend_size": "0",
                "type": "timeseries",
                "requests": [
                    {
                        "q": "avg:network.http.can_connect{$instance} by {instance,host}",
                        "style": {
                            "palette": "dog_classic",
                            "line_type": "solid",
                            "line_width": "normal"
                        },
                        "display_type": "line"
                    }
                ],
                "yaxis": {
                    "min": "0"
                },
                "markers": [
                    {
                        "value": "0 < y < 0.99",
                        "display_type": "error dashed"
                    }
                ]
            }
        },
        {
            "id": 8178478297531980,
            "definition": {
                "title": "Web service is Up",
                "type": "slo",
                "view_type": "detail",
                "time_windows": [
                    "30d"
                ],
                "slo_id": "e8a9bfd6ca995257aeca2451066aa377",
                "show_error_budget": true,
                "view_mode": "both",
                "global_time_target": "0"
            }
        },
        {
            "id": 2611123570207096,
            "definition": {
                "title": "SSL certificate expiry countdown",
                "type": "toplist",
                "requests": [
                    {
                        "formulas": [
                            {
                                "formula": "query1",
                                "limit": {
                                    "count": 10,
                                    "order": "asc"
                                }
                            }
                        ],
                        "conditional_formats": [
                            {
                                "comparator": "<=",
                                "palette": "white_on_red",
                                "value": 7
                            },
                            {
                                "comparator": "<=",
                                "palette": "white_on_yellow",
                                "value": 14
                            },
                            {
                                "comparator": ">",
                                "palette": "white_on_green",
                                "value": 14
                            }
                        ],
                        "response_format": "scalar",
                        "queries": [
                            {
                                "query": "avg:http.ssl.days_left{$instance} by {instance}",
                                "data_source": "metrics",
                                "name": "query1",
                                "aggregator": "avg"
                            }
                        ]
                    }
                ]
            }
        },
        {
            "id": 1130666663458580,
            "definition": {
                "title": "Disk usage",
                "show_legend": false,
                "legend_layout": "auto",
                "legend_columns": [
                    "avg",
                    "min",
                    "max",
                    "value",
                    "sum"
                ],
                "time": {},
                "type": "timeseries",
                "requests": [
                    {
                        "formulas": [
                            {
                                "alias": "gallifrey-block-storage",
                                "formula": "query1"
                            },
                            {
                                "alias": "gallifrey-local-data",
                                "formula": "query2"
                            },
                            {
                                "alias": "gallifrey-root-device",
                                "formula": "query3"
                            },
                            {
                                "alias": "sophro-root-device",
                                "formula": "query4"
                            },
                            {
                                "alias": "pi-root-device",
                                "formula": "query5"
                            }
                        ],
                        "queries": [
                            {
                                "data_source": "metrics",
                                "name": "query1",
                                "query": "avg:system.disk.in_use{host:gallifrey,device:/dev/sda}"
                            },
                            {
                                "data_source": "metrics",
                                "name": "query2",
                                "query": "avg:system.disk.in_use{host:gallifrey,device:/dev/vdb}"
                            },
                            {
                                "data_source": "metrics",
                                "name": "query3",
                                "query": "avg:system.disk.in_use{host:gallifrey,device:/dev/vda1}"
                            },
                            {
                                "data_source": "metrics",
                                "name": "query4",
                                "query": "avg:system.disk.in_use{host:sophro,device:/dev/vda1}"
                            },
                            {
                                "data_source": "metrics",
                                "name": "query5",
                                "query": "avg:system.disk.in_use{host:retropie,device:/dev/mmcblk0p1}"
                            }
                        ],
                        "response_format": "timeseries",
                        "style": {
                            "palette": "dog_classic",
                            "line_type": "solid",
                            "line_width": "normal"
                        },
                        "display_type": "line"
                    }
                ],
                "yaxis": {
                    "scale": "linear",
                    "include_zero": true,
                    "label": "",
                    "min": "auto",
                    "max": "auto"
                },
                "markers": [
                    {
                        "value": "0.80 < y < 0.90",
                        "display_type": "warning dashed"
                    },
                    {
                        "value": "0.90 < y < 1",
                        "display_type": "error dashed"
                    }
                ]
            }
        },
        {
            "id": 7013452597179762,
            "definition": {
                "title": "Scaleway s3 bucket usage (GB)",
                "title_size": "16",
                "title_align": "left",
                "show_legend": true,
                "legend_layout": "auto",
                "legend_columns": [
                    "avg",
                    "min",
                    "max",
                    "value",
                    "sum"
                ],
                "type": "timeseries",
                "requests": [
                    {
                        "formulas": [
                            {
                                "alias": "bucket-usage",
                                "formula": "query1"
                            }
                        ],
                        "response_format": "timeseries",
                        "on_right_yaxis": false,
                        "queries": [
                            {
                                "query": "avg:scaleway.s3.bucket.used_gb{*} by {bucket}.rollup(avg, 3600)",
                                "data_source": "metrics",
                                "name": "query1"
                            }
                        ],
                        "style": {
                            "palette": "dog_classic",
                            "line_type": "solid",
                            "line_width": "normal"
                        },
                        "display_type": "bars"
                    },
                    {
                        "formulas": [
                            {
                                "alias": "total",
                                "formula": "query0"
                            }
                        ],
                        "response_format": "timeseries",
                        "on_right_yaxis": false,
                        "queries": [
                            {
                                "query": "avg:scaleway.s3.total.used_gb{*}.rollup(avg, 3600)",
                                "data_source": "metrics",
                                "name": "query0"
                            }
                        ],
                        "style": {
                            "palette": "warm",
                            "line_type": "solid",
                            "line_width": "normal"
                        },
                        "display_type": "line"
                    }
                ],
                "yaxis": {
                    "include_zero": true,
                    "scale": "linear",
                    "label": "",
                    "min": "auto",
                    "max": "auto"
                },
                "markers": [
                    {
                        "label": " $$$ ",
                        "value": "y > 75",
                        "display_type": "warning dashed"
                    }
                ]
            }
        },
        {
            "id": 5956525457252872,
            "definition": {
                "title": "Days to expiration of OVH services",
                "title_size": "16",
                "title_align": "left",
                "show_legend": true,
                "legend_layout": "auto",
                "legend_columns": [
                    "avg",
                    "min",
                    "max",
                    "value",
                    "sum"
                ],
                "type": "timeseries",
                "requests": [
                    {
                        "q": "avg:ovh.service.remaining_days{*} by {product,service}",
                        "style": {
                            "palette": "dog_classic",
                            "line_type": "solid",
                            "line_width": "normal"
                        },
                        "display_type": "line"
                    }
                ],
                "yaxis": {
                    "include_zero": true,
                    "scale": "linear",
                    "label": "",
                    "min": "auto",
                    "max": "auto"
                },
                "markers": [
                    {
                        "value": "7 < y < 30",
                        "display_type": "warning dashed"
                    },
                    {
                        "value": "0 < y < 7",
                        "display_type": "error dashed"
                    }
                ]
            }
        }
    ],
    "template_variables": [
        {
            "name": "instance",
            "default": "*",
            "prefix": "instance",
            "available_values": []
        }
    ],
    "layout_type": "ordered",
    "is_read_only": false,
    "notify_list": [],
    "reflow_type": "auto",
    "id": "vhg-b2y-4xx"
}
  EOF
}


resource "datadog_dashboard_json" "fioul_dash" {
  dashboard = <<EOF
{
    "title": "Fioul",
    "description": "",
    "widgets": [
        {
            "id": 4835288157595439,
            "definition": {
                "title": "Prix d'1L de fioul",
                "title_size": "16",
                "title_align": "left",
                "time": {},
                "type": "query_value",
                "requests": [
                    {
                        "formulas": [
                            {
                                "formula": "query1"
                            }
                        ],
                        "response_format": "scalar",
                        "queries": [
                            {
                                "query": "avg:fioul.price.1l{*}",
                                "data_source": "metrics",
                                "name": "query1",
                                "aggregator": "last"
                            }
                        ]
                    }
                ],
                "autoscale": true,
                "custom_unit": "\u20ac",
                "precision": 3
            },
            "layout": {
                "x": 0,
                "y": 0,
                "width": 3,
                "height": 3
            }
        },
        {
            "id": 5285908177757594,
            "definition": {
                "title": "Prix d'1L de fioul",
                "title_size": "16",
                "title_align": "left",
                "show_legend": false,
                "legend_layout": "auto",
                "legend_columns": [
                    "avg",
                    "min",
                    "max",
                    "value",
                    "sum"
                ],
                "time": {},
                "type": "timeseries",
                "requests": [
                    {
                        "formulas": [
                            {
                                "formula": "query1"
                            }
                        ],
                        "queries": [
                            {
                                "query": "avg:fioul.price.1l{*}.rollup(avg, 86400)",
                                "data_source": "metrics",
                                "name": "query1"
                            }
                        ],
                        "response_format": "timeseries",
                        "style": {
                            "palette": "grey",
                            "line_type": "solid",
                            "line_width": "normal"
                        },
                        "display_type": "bars"
                    }
                ],
                "yaxis": {
                    "include_zero": true,
                    "scale": "linear",
                    "label": "",
                    "min": "auto",
                    "max": "auto"
                },
                "markers": [
                    {
                        "label": "Buy!",
                        "value": "y = 0.8",
                        "display_type": "ok dashed"
                    },
                    {
                        "label": "Buy?",
                        "value": "y = 0.9",
                        "display_type": "warning dashed"
                    }
                ]
            },
            "layout": {
                "x": 3,
                "y": 0,
                "width": 4,
                "height": 3
            }
        }
    ],
    "template_variables": [],
    "layout_type": "ordered",
    "is_read_only": false,
    "notify_list": [],
    "reflow_type": "fixed",
    "id": "ax9-87v-fkf"
}
EOF
}
