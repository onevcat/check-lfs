# Check LFS

A command-line tool to check binary files committed to a repo. It is useful for avoiding unexpected binary files in an LFS-enabled git repo.

## Installation

### Released Version

Find `check-lfs` on the release page, copy it to your executables path (such as `/usr/local/bin`).

### Manually Build

Clone and run `./script/build.sh` to build the project. Find the `check-lfs` under the `build` folder. Copy `check-lfs` to your executables path.

## Usage

Just run `check-lfs` inside your repo's folder (under git). It compares a branch (usually the branch you are working on) to a base branch (usually the `master` branch). 

```
USAGE: check-lfs [<current-branch>] [<base-branch>]

ARGUMENTS:
<current-branch> The branch to check. (default: HEAD)
<base-branch> The base branch name. (default: master)

OPTIONS:
-h, --help Show help information.
```

If there are any binary files committed, it gives an error. For example:

```sh
# Say, you added some binary files in the `test` branch. 
# Running check-lfs will compare it to `master`:
-> [repo git:(test)] check-lfs
Found binary files in the branch/commits:
binary-file
sample.png

# With an error exit for the command
-> [repo git:(test)] echo $?
127 
```

## Recommended Usage

### Git Hooks

Put it to a `post-commit` or `pre-push` hook, so before these changes can be committed or pushed to remote, you can 
have a notification to let you know something goes wrong.

Add this to the beginning of your `.git/post-commit` or `.git/pre-push` hook:

```
CHECK_LFS_PATH=./script/check-lfs
$CHECK_LFS_PATH || { echo >&2 "\n Binary files are detected in HEAD commits compared to master. Try to commit them as GitLFS and squash your commits.\n"; exit 2; }
```

> Remember to change the `CHECK_LFS_PATH` to the real path of `check-lfs`.

### Other

You can also use `check-lfs` in a CI script or any good time you think. It is just a normal command-line tool. If any 
binary files are detected in the commit, it will print these files and give a non-zero exit code.