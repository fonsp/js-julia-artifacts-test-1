using Test
using Deno_jll

import PackageThatUsesJS

filename = tempname() * ".mjs"
write(filename, PackageThatUsesJS.get_code(;bundled=false))

@test strip(read(`$(Deno_jll.deno()) run $(filename)`, String)) == "Hello world"