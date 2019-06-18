## Cloud resources as terraform manifests

The following resources are defined in these manifests:

- `aws`: S3 buckets
- `datadog`: Datadog monitors
- `ovh`: DNS records (`A` and `CNAME`)
- `scaleway`: VPS instance

**Notes**:

* The `global_vars/main.tf` file contains global variables, such as DNS domains, IPs, hostnames, etc, and is purposefully not exported.
* The terraform state is stored in a private S3 bucket, itself defined under `aws`
