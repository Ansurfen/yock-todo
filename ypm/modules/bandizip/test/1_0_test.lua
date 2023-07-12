---@diagnostic disable: undefined-global
local bz = import("bandizip@1.0")
bz.uncompress({
    src = "./protoc-3.19.5-win64.zip",
    dst = "./test",
    debug = true,
})
bz.compress({
    debug = true,
    src = "test/bin test/include test/*",
    dst = "aaa.tar"
})