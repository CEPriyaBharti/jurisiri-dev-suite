# Cloning the Repository
### To clone this repository along with all submodules:

```text
git clone --recursive <main-repo-url>
```
This command ensures that all submodules (backend, frontend, app) are cloned alongside the main repository.

## If You Already Cloned Without Submodules
If you cloned the repository without --recursive, initialize and fetch submodules using:

```text
git submodule init
git submodule update
```
Or, to do both steps at once (recommended):

```text
git submodule update --init
```
This will set up each submodule in the state defined by the main repository.

## Updating Submodules
If the submodules have changed upstream and you want the latest versions:

```text
git submodule update --remote
```
This fetches the latest commit from each submodule's default branch.
