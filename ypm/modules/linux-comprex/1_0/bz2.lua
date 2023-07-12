---@diagnostic disable: undefined-global
local bz2 = function()
    return argBuilder:new():add("bzip2")
end

local compress = function(opt)
    local src = opt["src"]
    local dst = opt["dst"]
    print(bz2():add("-c"):add_str(src, src):add(">"):add_str(dst, dst):build())
end

local uncompress = function(opt)
    local src = opt["src"]
    local dst = opt["dst"]
    print(bz2():add_str(src, src):add("-c"):add(">"):add_str(dst, dst):build())
end

return {
    compress = compress,
    uncompress = uncompress
}
