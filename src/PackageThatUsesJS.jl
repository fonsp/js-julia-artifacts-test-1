module PackageThatUsesJS

using Pkg
using Artifacts

greet(x) = "hello $x"

const unbundled_frontend = joinpath(@__DIR__, "..", "frontend")

const has_bundle = let 
    at = Artifacts.find_artifacts_toml(@__FILE__)
    at !== nothing && Artifacts.artifact_meta("bundle", at) !== nothing
end

const bundle_artifact_dir = has_bundle ? 
    # little trick to avoid reading the artifact during macroexpand, because it might not exist.
    @artifact_str(Ref("bundle")[]) : 
    nothing
const bundled_frontend = has_bundle ? 
    joinpath(bundle_artifact_dir, "frontend-dist") : 
    nothing

function get_code(; bundled::Bool)    
    path = if bundled
        @assert has_bundle
        joinpath(bundled_frontend, "main.bundle.mjs")
    else
        joinpath(unbundled_frontend, "main.mjs")
    end
    
    read(@show(path), String)
end


end
