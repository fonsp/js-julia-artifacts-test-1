# js-julia-artifacts-test-1

## TODO:

There is still one manual link:
1. Get the release asset download URL from the GH Action logs
2. Open a terminal an enter this repo
3. Run this code, replace URL with what you copied:

```julia
julia> using ArtifactUtils, Artifacts

julia> add_artifact!(
            "Artifacts.toml",
            "bundle",
            "https://github.com/fonsp/js-julia-artifacts-test-2/releases/download/hello-from-32aef25cb9593425151bc7b01a922e63c42a180a/frontend-dist.tar.gz",
            force=true,
       )
```

4. Commit!