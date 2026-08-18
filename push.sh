#!/bin/bash
set -e

cd "$(dirname "$0")"

echo "Current changes:"
git status -sb
echo

read -r -p "Commit message: " msg

if [ -z "$msg" ]; then
  echo "No message. Cancelled."
  exit 1
fi

git add .
git commit -m "$msg"
git push

echo
echo "Pushed!"
