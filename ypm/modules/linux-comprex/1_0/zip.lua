---@diagnostic disable: undefined-global
local zip = function()
    return argBuilder:new():add("zip")
end

local unzip = function()
    return argBuilder:new():add("unzip")
end

local compress = function(opt)
    local dst = opt["dst"]
    local src = opt["src"]
    print(zip():add_bool("-r", opt["r"]):add_str(dst, dst):add_str(src, src):
    build())
    -- exec({ debug = opt["debug"] or false, redirect = opt["redirect"] or false })
end

local uncompress = function(opt)
    local dst = opt["dst"]
    local src = opt["src"]
    print(unzip():add("-d"):add_str(dst, dst):add_str(src, src):build())
end

return {
    compress   = compress,
    uncompress = uncompress
}
