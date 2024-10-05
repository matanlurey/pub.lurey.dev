#!/usr/bin/env sh

# Clones and imports an external repository into this monorepo.
# Requires the tool "git-filter-repo" to be installed.

# Fail fast.
set -e

# The only arguments should be in the format of:
# [1] "https://github.com/org/repo"
# [2] "subdir/in/this/repo"
#
# For example:
# ./scripts/import-into-mono-repo.sh https://github.com/matanlurey/package packages/package

# Check for the correct number of arguments.
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <url> <subdir>"
  exit 1
fi

# Extract the arguments.
URL=$1
SUBDIR=$2

# Make sure the URL is valid, i.e. is in the format https://github.com/ORG/REPONAME.
# Use regular expression to match the URL format and extract org and repo names
if [[ "$URL" =~ ^https://github\.com/([^/]+)/([^/]+)$ ]]; then
  ORG=${BASH_REMATCH[1]}
  REPO=${BASH_REMATCH[2]}
else
  echo "Invalid URL: $URL"
  exit 1
fi

# Print the repo and org names and then confirm the user wants to proceed.
echo "$URL -> $SUBDIR"
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

# Ensure "git filter-repo" is installed by running it with the --version flag.
if ! git filter-repo --version; then
  echo "Please install 'git filter-repo' to continue."
  echo "See: https://github.com/newren/git-filter-repo"
  exit 1
fi

# Ensure the remote "monorepo" does not already exist.
#
# This command will intentionally fail if the remote does not exist, so make
# sure to ignore the error so -e does not exit the script.
if git remote get-url monorepo 2>/dev/null; then
  echo "Please remove the remote 'monorepo' before continuing."
  exit 1
fi

# Ensure the current branch is not "main".
if [ "$(git branch --show-current)" = "main" ]; then
  echo "Please switch to a different branch before continuing."
  exit 1
fi

# Create temporary directory to clone the external repository into.
TEMP_DIR=$(mktemp -d)

# Add a trap to cleanup the temporary directory.
trap 'rm -rf $TEMP_DIR' EXIT

# Clone the external repository.
git clone $URL $TEMP_DIR

# Move into the temporary directory.
pushd $TEMP_DIR

# Ensure there are files in the cloned repository.
# Print the root files and directories and ask the user to confirm.
echo "Root files and directories:"
ls -a $TEMP_DIR
read -p "Continue? (y/n) " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

# Run git-filter-repo to move the external repository into the monorepo.
git filter-repo --to-subdirectory-filter="$SUBDIR"

# Rewrite the commit history to include the original repository URL.
git filter-repo --commit-callback '
msg = commit.message.decode("utf-8")
newmsg = re.sub(r"\(#(?=\d+\))", f"('$ORG'/'$REPO'#", msg)
commit.message = newmsg.encode("utf-8")
'

# Move back to the root of the monorepo.
popd

# Add the temporary repository as a remote.
git remote add monorepo $TEMP_DIR

# Add a trap to cleanup the temporary remote.
trap 'git remote remove monorepo' EXIT

git remote -v
git fetch monorepo
git merge monorepo/main --allow-unrelated-histories
