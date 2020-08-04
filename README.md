# Check LFS

A command-line tool to check binary file committed to a repo.

## Installation

### Released Version

Find `check-lfs` in the release page, copy it to your repo.

### Manually Build

Run `./script/build.sh` to build the project. Find the `check-lfs` under the `build` folder. Copy `check-lfs` to your project.

## Usage

Just run `check-lfs` in your repo. It compares a branch (usually the branch you are working on) to a base branch (usually the `master` branch). 
If there are any binary files committed, it gives an error.

```
USAGE: check-lfs [<current-branch>] [<base-branch>]

ARGUMENTS:
  <current-branch>        The branch to check. (default: HEAD)
  <base-branch>           The base branch name. (default: master)

OPTIONS:
  -h, --help              Show help information.
```

## Recommended Usage

Put it to a `pre-push` hook, so before these changes are pushed to remote, you can have a notification to let you know 
something goes wrong.

Add this to the beginning of your `.git/pre-push` hook:

```
CHECK_LFS_PATH=./script/check-lfs
$CHECK_LFS_PATH || { echo >&2 "\n Binary files are detected in HEAD commits compared to master. Try to commit them as GitLFS and squash your commits.\n"; exit 2; }
```

> Remember to change the `CHECK_LFS_PATH` to the real path of `check-lfs`.