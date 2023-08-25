## How to use the samples

1. Use these commands to import the dashboard.

    First, set your environment variables, replacing the following values with your values:

    *  PROJECT_ID you wish to import the dashboard to
    *  FILE_NAME with the input filename for the dashboard JSON config

    ```bash
    export PROJECT_ID=<PROJECT_ID>

    export FILE_NAME=<DASH_FILE_NAME>
    ```

1. Use the provided [script](scripts/dashboard/dashboard.sh) to create a dashboard.

    ```bash
    scripts/dashboard/dashboard.sh import $PROJECT_ID $FILE_NAME
    ```

Alternatively, you can run the following command via curl. Use the [projects.dashboards.create](https://cloud.google.com/monitoring/api/ref_v3/rest/v1/projects.dashboards/create) to call the Dashboards API with the sample JSON and create a new dashboard.
Make sure you replace the __[project-id]__ and __[file-name.json]__ in the command:

```bash
curl -X POST -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
-H "Content-Type: application/json; charset=utf-8" \
https://monitoring.googleapis.com/v1/projects/[project-id]/dashboards -d @[file-name.json]
```

### metadata.yaml content

In order for sample dashboards to appear in the Cloud Console, the `metadata.yaml` file in your dashboard's directory needs
to be updated to include any new dashboards you are adding.

The top level of this file should include a single `sample_dashboards:` key, whose value is a list of dashboard objects.

Example:

```yaml
sample_dashboards:
  -
    category: Nginx
    id: overview
    display_name: Nginx Overview
    description: |-
      This dashboard has charts for viewing Nginx when monitored by [Google's Ops Agent](https://cloud.google.com/stackdriver/docs/solutions/agents/ops-agent/third-party/nginx#monitored-metrics), Request Rate, Current Connections, and Connections Rate from NGINX as well as charts of infrastructure related metrics for the running NGINX VMs: CPU % Top 5 VMs, Memory % Top 5 VMs, and NGINX VMs by Region for a count of VMs over time. 

      There is also a card with links to docs and Nginx logs in Cloud Logging.
    related_integrations:
      - id: nginx
        platform: GCE
```

The dashboard object is described by the following values:

| Field name | Description |
|:-----------|-------------|
| `category` | Sets the group name the dashboard will appear under in the Cloud Console. |
| `id`       | Should match the dashboard file name without the extension.         |
| `display_name` | Will be the name of the dashboard shown in the samples list of the Cloud Console. |
| `description`  | A brief description of the dashboard and its contents. Supports markdown-formatted links only. Include empty newlines for paragraph breaks. |
| `related_integrations`  | Optional. A list of integrations which collect the metrics displayed on this dashboard. |
| `related_integrations.platform` | Required for integration. For an Ops Agent application integration, use platform code `'GCE'`. |
| `related_integrations.id` | Required for integration. Should match the integration's id. |
| `related_integrations.version` | Optional. If this dashboard requires a specific revision of an integration include the version here. |

### Update README

Please also update the README.md file in the same directory of your dashboard file.

### For MSP

You can deploy these dashboards individually through the GCP Console.
  1. GCP Console > Monitoring Project
  2. Select Dashboard
  3. Create Dashboard
  4. Select the Dashboard Setting option > JSON > JSON Editor
  5. Copy code into Editor
  6. Edit to meed the needs of client/support

You can deploy alerts very similarily if you have access through the GCP Console CLI or CLI.
  1. Ensure you have alpha components installed
    a. gcloud components install alpha
  2. Through your CLI method, run the similar command to add your Alert Policy
    a. example: gcloud alpha monitoring policies create --policy-from-file=nameOfAlertPolicyHere.v1.json