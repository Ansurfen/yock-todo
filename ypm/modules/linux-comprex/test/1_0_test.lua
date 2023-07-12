---@diagnostic disable: undefined-global
local linuxc = import("linux-comprex@1.0")
linuxc.compress({
    src = "./test",
    dst = "a.zip"
})
linuxc.compress({
    src = "./test",
    dst = "a.tar.bz2"
})
linuxc.uncompress({
    dst = "/home/abc/",
    src = "mytxt.zip"
})
linuxc.compress({
    src = "a.txt",
    dst = "a.gz"
})
linuxc.uncompress({
    src = "a.gz",
    dst = "a"
})
linuxc.uncompress({
    src = "a.zip",
    dst = "a"
})
linuxc.uncompress({
    src = "a.tar.gz",
    dst = "a"
})
linuxc.uncompress({
    src = "a.bz2",
    dst = "a"
})
linuxc.compress({
    src = "a.txt",
    dst = "/home/user/a.bz2"
})
