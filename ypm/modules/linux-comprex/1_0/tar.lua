---@diagnostic disable: undefined-global
local tar = function()
    return argBuilder:new():add("tar")
end

local compress = function(opt)
    local dst = opt["dst"]
    local src = opt["src"]
    local cvf = "-cvf"
    local ext = path.ext(dst)
    if ext == ".gz" then
        cvf = "-zcvf"
    elseif ext == ".bz2" then
        cvf = "-jcvf"
    end
    print(tar():add(cvf):add_str(dst, dst):add_str(src, src):build())
    -- exec({ debug = opt["debug"] or false, redirect = opt["redirect"] or false })
end

local uncompress = function(opt)
    local dst = opt["dst"]
    local src = opt["src"]
    local xvf = "-xvf"
    local ext = path.ext(src)
    if ext == ".gz" then
        xvf = "-zxvf"
    elseif ext == ".bz2" then
        xvf = "-jxvf"
    end
    print(tar():add(xvf):add_str(dst, dst):add("-C"):add_str(src, src):build())
end

return {
    compress   = compress,
    uncompress = uncompress
}
