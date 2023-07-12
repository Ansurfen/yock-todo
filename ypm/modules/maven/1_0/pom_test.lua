local pom = import("./pom")

local p = pom:open("pom.xml")
p:set_deps({
    { ver = "1.0", groupId = "a", artifactId = "a" },
    { ver = "1.0", groupId = "b", artifactId = "b" }
})
-- p:dump()
p:add_deps({
    { ver = "1.0", groupId = "a",  artifactId = "a" },
    { ver = "1.0", groupId = "bc", artifactId = "b" }
})
p:rm_deps({
    { ver = "1.0", groupId = "a", artifactId = "a" },
})
table.dump(p:get_deps())
p:set_url("ab")
p:rm_props("maven.compiler.source")
-- p:dump()
p:add_props({
    ["project.build.sourceEncoding"] = "b"
})
p:set_props({
    ["maven.compiler.target"] = "1.7"
})
table.dump(p:get_props())
table.dump(p:get_plugins())

-- p:exist_dep()
-- p:exist_prop()
