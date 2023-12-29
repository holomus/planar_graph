#!/bin/bash

current_version=$1

if [[ "$current_version" == *"-debug"* ]]; then
  IFS='.' read -r -a version_parts <<< "$current_version"
  major="${version_parts[0]}"
  minor="${version_parts[1]}"
  minor=$((minor + 1))
  new_version="$major.$minor.0"
else
  IFS='.' read -r -a version_parts <<< "$current_version"
  major="${version_parts[0]}"
  minor="${version_parts[1]}"
  patch="${version_parts[2]}"
  patch=$((patch + 1))
  new_version="$major.$minor.$patch"
fi

echo $new_version
