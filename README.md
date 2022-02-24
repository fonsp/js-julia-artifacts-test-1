# js-julia-artifacts-test-1

This Julia package contains a folder `frontend/` with unbundled JS files. You can run `bundle_frontend.sh` to bundle it, creating a `frontend-dist/` folder. 

Because this contains binary outputs, we want to `.gitignore` it. But when releasing a new version of our package, we need the folder, panic!

The solution (suggested by @staticfloat) is to use a combination of GitHub Actions, GitHub releases (on a [dummy repository](https://github.com/fonsp/js-julia-artifacts-test-2)) and Julia Artifacts. It works!

# How to release

## Step 1
Change the version number in Project.toml. Make a commit that you want to release. 

## Step 2
Go to [Actions](https://github.com/fonsp/js-julia-artifacts-test-1/actions), then to the [Bundle action](https://github.com/fonsp/js-julia-artifacts-test-1/actions/workflows/prepare-release.yml). Dispatch the workflow.

![Schermafbeelding 2022-02-24 om 15 36 40](https://user-images.githubusercontent.com/6933510/155544974-d834d5ee-899c-4ab0-a369-52b7a3842156.png)

## Step 3
Wait for a GitHub notification to come in (you will be `@mentioned`). Follow the instructions!

![Schermafbeelding 2022-02-24 om 15 26 32](https://user-images.githubusercontent.com/6933510/155545832-84338f64-0589-4793-af72-f2ebb6b9e757.png)

A commit was created on a separate branch with the bundled frontend included as artifact! Ready to release :)

# How does it work?

All of the magic is in our [GitHub action](https://github.com/fonsp/js-julia-artifacts-test-1/blob/main/.github/workflows/prepare-release.yml). It does the following:
1. Run the `frontend_bundle.sh` script.
2. Archive the output folder to create `frontend-dist.tar.gz`
3. On a dummy repository (https://github.com/fonsp/js-julia-artifacts-test-2), a dummy release is created and this tarball is uploaded as release binary. ([Example release](https://github.com/fonsp/js-julia-artifacts-test-2/releases/tag/hello-from-ff76e0a0f3b9ffe8b25a9deef9f2b81feb8b1522))
4. Using [ArtifactUtils.jl](https://github.com/simeonschaub/ArtifactUtils.jl), an Artifacts.toml file is created/updated to include this release download URL as dependency, with the right hashes. ([Example (old example from the wrong branch)](https://github.com/fonsp/js-julia-artifacts-test-1/blob/95f3cd3758eac79822bded602ec7e7bd2df955cb/Artifacts.toml))
5. We `git checkout` the `bundled` branch, and do `reset --hard` to make it exactly match `main` (or whatever branch you triggered the workflow from), removing any old commits.
6. A new commit is added with the new Artifacts.toml file.
7. The bot writes a comment on that commit, tagging the `actor` who initiated the action, with instructions to release. ([Example (might be garbage-collected in the future)](https://github.com/fonsp/js-julia-artifacts-test-1/commit/f0726fce57ba51c1dbf1a7cb315c2b3b37f624a0))

For more info, see the [workflow file](https://github.com/fonsp/js-julia-artifacts-test-1/blob/main/.github/workflows/prepare-release.yml).

## About `reset --hard`
Doing `reset --hard` on the `bundled` branch means that we can use any branch as the original, not just `main`. 

This means that old bot-generated commits will be removed, leaving them "dangling" without a branch, and git will eventually garbage-collect them. However! If I release that dangling commit, a git tag will be created (by tagbot), so it will never be removed!


# TODO

The Artifacts.toml file can still get out of date. Some ideas:
- [ ] `.gitignore` the file on `main`, and force push it into the `bundle` branch. This is perfect, unless you want to use additional artifacts.
- [ ] Store a hash of the original `frontend` folder in the artifact, so that you can verify that the build corresponds to the current state of the folder.