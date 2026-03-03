#!/bin/bash
# ============================================================
#  Copyright © 2026 Arcade Crew X
#  This script is a proprietary work of Arcade Crew X.
#  All rights reserved.
#
#  This script is intended solely for execution via "curl" command only.
#
#  You are NOT permitted to:
#    ❌ Copy
#    ❌ Modify
#    ❌ Redistribute
#    ❌ Host or mirror this script elsewhere
#
#  Unauthorized use constitutes copyright infringement and may
#  result in a DMCA takedown or legal action.
# ============================================================

COLOR_BLACK=$'\033[0;90m'
COLOR_RED=$'\033[0;91m'
COLOR_GREEN=$'\033[0;92m'
COLOR_YELLOW=$'\033[0;93m'
COLOR_BLUE=$'\033[0;94m'
COLOR_MAGENTA=$'\033[0;95m'
COLOR_CYAN=$'\033[0;96m'
COLOR_WHITE=$'\033[0;97m'
STYLE_DIM=$'\033[2m'
STYLE_STRIKE=$'\033[9m'
STYLE_BOLD=$'\033[1m'
FORMAT_RESET=$'\033[0m'
BG_BLUE=$'\033[44m'
BG_YELLOW=$'\033[43m'
FG_BLACK=$'\033[30m'
FG_WHITE=$'\033[97m'

clear

echo -e "                     ${COLOR_CYAN}▲${FORMAT_RESET}"
echo -e "                    ${COLOR_CYAN}▲ ▲${FORMAT_RESET}"
echo -e "   ${COLOR_WHITE}${STYLE_BOLD}🚀  LET'S GET STARTED WITH THIS LAB!  🚀${FORMAT_RESET}"
echo -e "${COLOR_BLUE}${STYLE_BOLD}▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃${FORMAT_RESET}"
echo

echo -e "${COLOR_GREEN}${STYLE_BOLD} >>-- 🔐 Verifying your GCP authentication status --<< ${FORMAT_RESET}"
gcloud auth list

echo
echo -e "${COLOR_YELLOW}${STYLE_BOLD} >>-- 📍 Retrieving your zone configuration --<< ${FORMAT_RESET}"
export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")

echo
echo -e "${COLOR_YELLOW}${STYLE_BOLD} >>-- 🌍 Fetching your region information --<< ${FORMAT_RESET}"
export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")

echo
echo -e "${COLOR_CYAN}${STYLE_BOLD} >>-- 🆔 Setting up your project identifier --<< ${FORMAT_RESET}"
export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

echo
echo -e "${COLOR_MAGENTA}${STYLE_BOLD} >>-- 📊 Creating custom logging metric for responses --<< ${FORMAT_RESET}"
gcloud logging metrics create 200responses --description="subscribe to arcadecrewx" --log-filter='resource.type="gae_app" AND resource.labels.module_id="default" AND (protoPayload.status=200 OR httpRequest.status=200)'

echo
echo -e "${COLOR_BLUE}${STYLE_BOLD} >>-- ⏱️  Preparing latency distribution configuration --<< ${FORMAT_RESET}"
cat > latency_metric.json <<EOF
{
    "name": "latency_metric",
    "description": "latency distribution",
    "filter": "resource.type=\"gae_app\" AND resource.labels.module_id=\"default\" AND logName=(\"projects/${DEVSHELL_PROJECT_ID}/logs/cloudbuild\" OR \"projects/${DEVSHELL_PROJECT_ID}/logs/stderr\" OR \"projects/${DEVSHELL_PROJECT_ID}/logs/%2Fvar%2Flog%2Fgoogle_init.log\" OR \"projects/${DEVSHELL_PROJECT_ID}/logs/appengine.googleapis.com%2Frequest_log\" OR \"projects/${DEVSHELL_PROJECT_ID}/logs/cloudaudit.googleapis.com%2Factivity\") AND severity>=DEFAULT",
    "valueExtractor": "EXTRACT(protoPayload.latency)",
    "metricDescriptor": {
        "metricKind": "DELTA",
        "valueType": "DISTRIBUTION",
        "unit": "s",
        "labels": []
    },
    "bucketOptions": {
        "explicitBuckets": {
            "bounds": [0.01, 0.1, 0.5, 1, 2, 5]
        }
    }
}
EOF

echo "Awaiting system response..."
tput civis
trap 'tput cnorm; exit' SIGINT
duration=5
pulse_chars=("○" "◌" "●" "◌")
for i in $(seq $duration -1 1); do
    index=$(( (duration - i) % 4 ))
    echo -ne "${COLOR_CYAN}${STYLE_BOLD}${pulse_chars[$index]}${FORMAT_RESET} Synchronizing... ${i}s remaining \r"
    sleep 1
done
tput cnorm
echo -e "\n✔️ System synchronized."

echo -e "${COLOR_GREEN}${STYLE_BOLD} >>-- 🚀 Uploading latency metrics to Cloud Logging --<< ${FORMAT_RESET}"
curl -X POST \
    -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
    -H "Content-Type: application/json" \
    -d @latency_metric.json \
    "https://logging.googleapis.com/v2/projects/${DEVSHELL_PROJECT_ID}/metrics"

echo
echo -e "${COLOR_CYAN}${STYLE_BOLD} >>-- 💻 Launching compute instance with web server --<< ${FORMAT_RESET}"
gcloud compute instances create arcadecrewx --zone=$ZONE --project=$DEVSHELL_PROJECT_ID --machine-type=e2-micro --image-family=debian-11 --image-project=debian-cloud --tags=http-server --metadata=startup-script='#!/bin/bash sudo apt update && sudo apt install -y apache2 && sudo systemctl start apache2' --scopes=https://www.googleapis.com/auth/cloud-platform --labels=env=lab --quiet

echo
echo -e "${COLOR_YELLOW}${STYLE_BOLD} >>-- 📝 Creating BigQuery sink for audit logs --<< ${FORMAT_RESET}"
gcloud logging sinks create AuditLogs --project=$DEVSHELL_PROJECT_ID bigquery.googleapis.com/projects/$PROJECT_ID/datasets/AuditLogs --log-filter='resource.type="gce_instance"'

echo
echo -e "${COLOR_BLUE}${STYLE_BOLD} >>-- 📦 Setting up BigQuery dataset for logs storage --<< ${FORMAT_RESET}"
bq --location=US mk --dataset ${DEVSHELL_PROJECT_ID}:AuditLogs


echo
echo "${BG_YELLOW}${STYLE_BOLD}${FG_WHITE}  * * .         .         * *   * * .         .         * * ${FORMAT_RESET}"
echo "${BG_YELLOW}${STYLE_BOLD}${FG_WHITE}      ${STYLE_BOLD}   KINDLY FOLLOW VIDEO INSTRUCTIONS CAREFULLY         ${FORMAT_RESET}"
echo "${BG_YELLOW}${STYLE_BOLD}${FG_WHITE} .       .      * * .           .  .       .      * * .   . ${FORMAT_RESET}"
echo

echo -e "\033[1;33mClick this link\033[0m \033[1;34mhttps://console.cloud.google.com/appengine?serviceId=default&inv=1&invt=AbxmyA&project=$DEVSHELL_PROJECT_ID\033[0m"

echo
echo -e "${COLOR_MAGENTA}${STYLE_BOLD} >>-- 💖 Enjoyed this? Subscribe to Arcade Crew X for more! --<< ${FORMAT_RESET}"
echo "${COLOR_BLUE}${STYLE_BOLD}https://www.youtube.com/@ArcadeCrewX${FORMAT_RESET}"
echo
