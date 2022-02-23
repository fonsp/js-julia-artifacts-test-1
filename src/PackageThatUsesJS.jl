module PackageThatUsesJS

using Pkg
using Artifacts

greet(x) = "hello $x"

const unbundled_frontend = joinpath(@__DIR__, "..", "frontend")

const bundle_artifact_dir = artifact"bundle"
const bundled_frontend = joinpath(bundle_artifact_dir, "frontend-dist")

function get_code(; bundled::Bool)    
    path = bundled ? joinpath(bundled_frontend, "main.bundle.mjs") : joinpath(unbundled_frontend, "main.mjs")
    
    read(@show(path), String)
end


end
