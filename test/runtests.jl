using Test
using Deno_jll

import PackageThatUsesJS

@testset "Bundled: $(bundled)" for bundled in [false, true]
    filename = tempname() * ".mjs"
    write(filename, PackageThatUsesJS.get_code(; bundled))

    @test strip(read(`$(Deno_jll.deno()) run $(filename)`, String)) == "Hello artifacts!"
end