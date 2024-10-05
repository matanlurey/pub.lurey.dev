# Moving projects into this monorepo

- Install `git-filter-repo` (<https://github.com/newren/git-filter-repo>)
- Go into a temporary directory and clone the repo to merge into the monorepo
- In the directory, run `git filter-repo --to-subdirectory-filter <subdir>`
- Alter the commits so issues point to the right (historic) repo:

  ```sh
  git filter-repo --commit-callback '
  msg = commit.message.decode("utf-8")
  newmsg = re.sub("\(#(?=\d+\))", "(org-name/cool-demo#", msg)
  commit.message = newmsg.encode("utf-8")
  '
  ```

- Now go back to the monorepo and merge:

  ```sh
  git checkout -b integrate-oath.dart
  git remote add temp /tmp/monorepo/oath.dart
  git fetch temp
  git merge temp/main --allow-unrelated-histories
  ```

_See also: <https://developers.netlify.com/guides/migrating-git-from-multirepo-to-monorepo-without-losing-history>._
