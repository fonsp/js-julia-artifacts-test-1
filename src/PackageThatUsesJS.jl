module PackageThatUsesJS

using Pkg
using Artifacts

greet(x) = "hello $x"

get_code(; bundled::Bool) = read(joinpath(@__DIR__, "..", "frontend", "main.mjs"), String)


end
