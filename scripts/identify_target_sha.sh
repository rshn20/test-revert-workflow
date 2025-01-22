#!/bin/bash

# Function to monitor the status of the in-progress deployment
check_in_progress() {
  while true; do
    deployment_status=$(gh run list -w "Production deployment" --status="in_progress" --json conclusion -q '.[0].conclusion')
    if [ "$deployment_status" = "success" ]; then
      echo "Deployment succeeded."
      return 0
    elif [ "$deployment_status" = "failure" ]; then
      echo "Deployment failed."
      return 1
    fi
    echo "Waiting for deployment to complete..."
    sleep 300 # Check every 5 minutes
  done
}

# Fetch SHAs
inprogress_sha=$(gh run list -w "Production deployment" --status="in_progress")
latest_prod_sha=$(gh run list -w "Production deployment" --status="success" --json headSha -q '.[0].headSha')

# Logic to determine the target SHA
if [ -n "$inprogress_sha" ]; then
  echo "Found an in-progress deployment. Monitoring its status..."
  if check_in_progress; then
    echo "target_sha=$inprogress_sha" >> "$GITHUB_OUTPUT"
  else
    echo "In-progress deployment failed. Falling back to the latest successful SHA."
    echo "target_sha=$latest_prod_sha" >> "$GITHUB_OUTPUT"
  fi
else
  echo "No in-progress deployment found. Using the latest successful SHA."
  echo "target_sha=$latest_prod_sha" >> "$GITHUB_OUTPUT"
fi