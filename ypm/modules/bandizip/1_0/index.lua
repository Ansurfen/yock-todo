---@diagnostic disable: undefined-global

local bz = function()
    return argBuilder:new():add("bz")
end

local uncompress = function(opt)
    local abs = opt["x"] or false
    local src = opt["src"]
    local dst = opt["dst"]
    if #src == 0 or #dst == 0 then
        yassert("invalid source or destination")
    end
    if not abs then
        local wd, err = pwd()
        yassert(err)
        if path.abs(src) ~= src then
            src = path.join(wd, src)
        end
        if path.abs(dst) ~= dst then
            dst = path.join(wd, dst)
        end
    end
    bz():add("x"):add_str("-o:" .. dst, dst):add_str(src, src):add_str("-p:" .. (opt["pwd"] or ""), opt["pwd"]):
        exec({ debug = opt["debug"] or false, redirect = opt["redirect"] or false })
end

local compress = function(opt)
    local src = opt["src"]
    local dst = opt["dst"]
    bz():add("c"):add_str(dst, dst):add_str(src, src):exec({
        debug = opt["debug"] or false,
        redirect = opt["redirect"] or false
    })
end

return {
    compress = compress,
    uncompress = uncompress
}
