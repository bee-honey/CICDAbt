#!/bin/bash

# Github token to be pulled from the secure actions, @myself(delete this after the interview)
GITHUB_TOKEN=${{ secrets.GH_TOKEN }}
OWNER="bee-honey" 
REPO="CICDAbt" #Move it to a common properties file, else

# Get the current commit SHA
CURRENT_SHA=$(git rev-parse HEAD)
echo "Current SHA: $CURRENT_SHA"

# Get list of workflow runs and find the RUN_ID that matches the current SHA, instead of the lates as .workflow_runs[0]
RUN_ID=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
              -H "Accept: application/vnd.github+json" \
              "https://api.github.com/repos/$OWNER/$REPO/actions/runs" | \
              jq --arg CURRENT_SHA "$CURRENT_SHA" '.workflow_runs[] | select(.head_sha == $CURRENT_SHA) | .id' | head -n 1)

if [ -z "$RUN_ID" ]; then
  echo "CI-ERROR: No workflow run for the SHA: $CURRENT_SHA"
  exit 1
fi

echo "CI-INFO: RUN_ID: $RUN_ID for SHA: $CURRENT_SHA"

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
     -o artifact.zip \
     "$DOWNLOAD_URL"

echo "CI-INFO: Artifact downloaded as artifact.zip"

# Finally lets Check if the file exists and has some size
if [[ -s artifact.zip ]]; then
  echo "CI-INFO: Artifact downloaded successfully as artifact.zip"
else
  echo "CI-ERROR: Failed to download artifact."
  exit 1
fi


# # List of runs:
# curl -H "Authorization: token YOUR_GITHUB_TOKEN" \
#      -H "Accept: application/vnd.github+json" \
#      "https://api.github.com/repos/OWNER/REPO/actions/runs"


# # Need to check the current SHA and Extract the run_id out of all the runs, instead of the lates as .workflow_runs[0]
# RUN_ID=$(curl -s -H "Authorization: token YOUR_GITHUB_TOKEN" \
#               -H "Accept: application/vnd.github+json" \
#               "https://api.github.com/repos/OWNER/REPO/actions/runs" | \
#               jq '.workflow_runs[0].id')
# echo "Latest RUN_ID: $RUN_ID"

# # Get the artifact ID
# curl -H "Authorization: token YOUR_GITHUB_TOKEN" \
#      -H "Accept: application/vnd.github+json" \
#      https://api.github.com/repos/bee-honey/CICDAbt/actions/runs/11528317970/artifacts


# # Now create the URL from the id as "archive_download_url": "https://api.github.com/repos/bee-honey/CICDAbt/actions/artifacts/2106905073/zip",
# # and download the zip file


# {
#   "total_count": 1,
#   "artifacts": [
#     {
#       "id": 2106905073,
#       "node_id": "MDg6QXJ0aWZhY3QyMTA2OTA1MDcz",
#       "name": "app",
#       "size_in_bytes": 24209,
#       "url": "https://api.github.com/repos/bee-honey/CICDAbt/actions/artifacts/2106905073",
#       "archive_download_url": "https://api.github.com/repos/bee-honey/CICDAbt/actions/artifacts/2106905073/zip",
#       "expired": false,
#       "created_at": "2024-10-26T03:16:13Z",
#       "updated_at": "2024-10-26T03:16:13Z",
#       "expires_at": "2024-10-29T03:16:13Z",
#       "workflow_run": {
#         "id": 11528317970,
#         "repository_id": 878685937,
#         "head_repository_id": 878685937,
#         "head_branch": "main",
#         "head_sha": "19c5885fa6eaa71164c342c86398702facf0afc0"
#       }
#     }
#   ]
# }


# # Download artifact
# curl -L -H "Authorization: token YOUR_GITHUB_TOKEN" \
#      -H "Accept: application/vnd.github+json" \
#      -o artifact.zip \
#      https://api.github.com/repos/OWNER/REPO/actions/artifacts/ARTIFACT_ID/zip