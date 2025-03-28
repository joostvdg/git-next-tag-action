#!/bin/bash

set -eo pipefail

git config --global --add safe.directory /github/workspace

cd "${GITHUB_WORKSPACE}/${source}" || exit 1

# Config
# Parameters: baseTag, path, outputPath, preRelease, commit, suffix
# For each parameter, if it is not set, it will be ignored
# If the parameter is set, it will be used
# baseTag and path are required
# outputPath is optional
# preRelease is optional
# commit is optional
# suffix is optional

# baseTag
if [ -z "${BASE_TAG}" ]; then
  echo "baseTag is required"
  exit 1
fi

# path, either use TAG_PATH or workspace default
if [ -z "${TAG_PATH}" ]; then
  INPUT_PATH="${GITHUB_WORKSPACE}"
else
  INPUT_PATH="${GITHUB_WORKSPACE}/${TAG_PATH}"
fi

# construct the command
command="/work/git-next-tag --baseTag ${BASE_TAG} --path ${INPUT_PATH}"

# outputPath
if [ -n "${OUTPUT_PATH}" ]; then
  command="${command} --outputPath ${OUTPUT_PATH}"
fi

# preRelease
if [ -n "${PRE_RELEASE}" ]; then
  command="${command} --preRelease ${PRE_RELEASE}"
fi

# commit
if [ -n "${COMMIT}" ]; then
  command="${command} --commit"
fi

# suffix
if [ -n "${SUFFIX}" ]; then
  command="${command} --suffix ${SUFFIX}"
fi

# Just add debug logging as well
command="${command} -vvv"


# Run the command
eval "$command"

# After running the command, capture the output
NEXT_TAG=$(cat "${INPUT_PATH}/version.txt")

# Debug log
echo "Next tag: $NEXT_TAG"

# Set the output for the GitHub Action
echo "::set-output name=next-tag::$NEXT_TAG"
