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

echo -e "${COLOR_YELLOW}${STYLE_BOLD} >>-- 📍 Fetching your project region and ID --<< ${FORMAT_RESET}"
echo

export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

export PROJECT_ID=$(gcloud config get-value project)

echo -e "${COLOR_GREEN}${STYLE_BOLD} >>-- 🪣 Creating a new Cloud Storage bucket in your region --<< ${FORMAT_RESET}"
echo

gsutil mb -l $REGION -c Standard gs://$PROJECT_ID

echo -e "${COLOR_CYAN}${STYLE_BOLD} >>-- 📥 Downloading the media file from repository --<< ${FORMAT_RESET}"
echo

curl -O https://github.com/ArcadeCrewX/Arcade_Crew_LabS/blob/main/kitten.png

echo -e "${COLOR_MAGENTA}${STYLE_BOLD} >>-- ⬆️ Uploading the file to your Cloud Storage bucket --<< ${FORMAT_RESET}"
echo

gsutil cp kitten.png gs://$PROJECT_ID/kitten.png

echo -e "${COLOR_YELLOW}${STYLE_BOLD} >>-- 🔐 Setting public access permissions for all users --<< ${FORMAT_RESET}"
echo

gsutil iam ch allUsers:objectViewer gs://$PROJECT_ID

echo
echo -e "${COLOR_MAGENTA}${STYLE_BOLD} >>-- 💖 Enjoyed this? Subscribe to Arcade Crew X for more! --<< ${FORMAT_RESET}"
echo "${COLOR_BLUE}${STYLE_BOLD}https://www.youtube.com/@ArcadeCrewX${FORMAT_RESET}"
echo
