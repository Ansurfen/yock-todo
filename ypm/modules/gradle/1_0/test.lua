local gradle = import("./gradle")
local g = gradle:open("build.gradle")

g:add_deps({
    { ver = "1.0", groupId = "a",  artifactId = "a" },
    { ver = "1.0", groupId = "bc", artifactId = "b" }
})
g:rm_deps({
    { ver = "1.0",                    groupId = "bc",           artifactId = "b" },
    { groupId = "org.spockframework", artifactId = "spock-core" }
})
table.dump(g:get_deps())
