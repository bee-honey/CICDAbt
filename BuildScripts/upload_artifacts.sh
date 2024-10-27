#!/bin/bash

# Github token to be pulled from the secure actions, @myself(delete this after the interview)
OWNER="bee-honey" 
REPO="CICDAbt" #Move it to a common properties file, else
DOWNLOAD_PATH="$RUNNER_TEMP/artifact.zip"

# Get the current commit SHA
CURRENT_SHA=$(git rev-parse HEAD)
echo "Current SHA: $CURRENT_SHA"

# Get list of workflow runs and find the RUN_ID that matches the current SHA, instead of the lates as .workflow_runs[0]
RUN_ID=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
              -H "Accept: application/vnd.github+json" \
              "https://api.github.com/repos/$OWNER/$REPO/actions/runs" | \
              jq '.workflow_runs[1].id')

# NOTE: Getting incorrect runid here, need to figure out the CURRENTSHA matching logic
# For now, will go with the latest run
              # jq --arg CURRENT_SHA "$CURRENT_SHA" \
              #    '.workflow_runs | sort_by(.created_at) | reverse | .[] | select(.head_sha == $CURRENT_SHA) | .id' | head -n 1)

if [ -z "$RUN_ID" ]; then
  echo "CI-ERROR: No workflow run for the SHA: $CURRENT_SHA"
  exit 1
fi

echo "CI-INFO: Run id is $RUN_ID for SHA: $CURRENT_SHA"

# Now we retrieve the artifact ID for the matching RUN_ID
ARTIFACT_ID=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
                   -H "Accept: application/vnd.github+json" \
                   "https://api.github.com/repos/$OWNER/$REPO/actions/runs/$RUN_ID/artifacts" | \
                   jq '.artifacts[0].id')

if [ -z "$ARTIFACT_ID" ]; then
  echo "CI-ERROR: No artifacts found for RUN_ID: $RUN_ID"
  exit 1
fi

echo "CI-INFO: Found ARTIFACT_ID: $ARTIFACT_ID"

# Lets create the artifact download URL
DOWNLOAD_URL="https://api.github.com/repos/$OWNER/$REPO/actions/artifacts/$ARTIFACT_ID/zip"
# FInally download the artifact zip file
curl -L -H "Authorization: token $GITHUB_TOKEN" \
     -o "$DOWNLOAD_PATH" \
     "$DOWNLOAD_URL"

echo "CI-INFO: Artifact downloaded as artifact.zip"

# Finally lets Check if the file exists and has some size
if [[ -s artifact.zip ]]; then
  echo "CI-INFO: Artifact downloaded successfully as artifact.zip"
else
  echo "CI-ERROR: Failed to download artifact."
  exit 1
fi

