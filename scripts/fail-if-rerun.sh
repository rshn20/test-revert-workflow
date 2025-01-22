#!/bin/bash

run_attempt=$1
if [ -z "$run_attempt" ]; then
  echo "Usage: fail_if_rerun.sh <run_attempt>"
  exit 1
fi

if [ $run_attempt -gt 1 ]; then
  echo "******************************************"
  echo "* You have attempted to re-run a job within the production deploy workflow"
  echo "* This is not allowed."
  echo "* Please start a new run of the entire workflow."
  echo "******************************************"
  echo "This is a rerun of a previous workflow run."
  exit 1
else
  echo "Success: not a rerun of a previous workflow run"
fi