---@diagnostic disable: undefined-global
local gzip = function()
    return argBuilder:new():add("gzip")
end

local compress = function(opt)
    local src = opt["src"]
    local dst = opt["dst"]
    -- todo -r implement: judge file or dir to insert flag
    print(gzip():add("-c"):add_str(src, src):add(">"):add_str(dst, dst):build())
end

local uncompress = function(opt)
    local src = opt["src"]
    local dst = opt["dst"]
    print(gzip():add("-dc"):add_str(src, src):add(">"):add_str(dst, dst):build())
end

return {
    compress = compress,
    uncompress = uncompress
}
