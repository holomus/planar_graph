#!/bin/bash

# Get the range of commits between the previous tag and the current tag
CHANGELOG=$(git log --pretty=format:"* [%s] by %an in %h" $(git describe --tags --abbrev=0 @^)..@)

# Print the generated changelog
echo "## What's Changed"
echo "$CHANGELOG"
