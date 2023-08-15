#!/bin/sh

set -e

git config --global --add safe.directory /github/workspace

# Fetch tags from origin
git fetch --tags

# Get the latest tag
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")

# Parse the tag to get major, minor, and patch
MAJOR=$(echo $LATEST_TAG | cut -d. -f1)
MINOR=$(echo $LATEST_TAG | cut -d. -f2)
PATCH=$(echo $LATEST_TAG | cut -d. -f3 | cut -d- -f1)

# Increment the patch version
NEW_PATCH=$((PATCH + 1))
NEW_TAG="${MAJOR}.${MINOR}.${NEW_PATCH}"

echo "Bumping tag from $LATEST_TAG to $NEW_TAG"

# Set git config
git config --global user.email "actions@github.com"
git config --global user.name "GitHub Actions"

# Create new tag
git tag $NEW_TAG
git push origin $NEW_TAG

echo "Tag $NEW_TAG created and pushed"
