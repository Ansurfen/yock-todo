---@diagnostic disable: undefined-global
local compress = function(opt)
    local src = opt["src"]
    local dst = opt["dst"]
    if #src == 0 or #dst == 0 then
        yassert("invalid source or destination")
    end
    local cmp
    local _switch = {
        [".zip"] = function()
            cmp = import("./zip")
        end,
        [".tar"] = function()
            cmp = import("./tar")
        end,
        [".tar.gz"] = function()
            cmp = import("./tar")
        end,
        [".tar.bz2"] = function()
            cmp = import("./tar")
        end,
        [".gz"] = function()
            cmp = import("./gz")
        end,
        [".bz2"] = function()
            cmp = import("./bz2")
        end
    }
    for name, fn in pairs(_switch) do
        if strings.HasSuffix(dst, name) then
            fn()
            if cmp ~= nil and type(cmp.compress) == "function" then
                cmp.compress(opt)
            end
            return
        end
    end
end

local uncompress = function(opt)
    local src = opt["src"]
    local dst = opt["dst"]
    if #src == 0 or #dst == 0 then
        yassert("invalid source or destination")
    end
    local ucmp
    local _switch = {
        [".zip"] = function()
            ucmp = import("./zip")
        end,
        [".tar"] = function()
            ucmp = import("./tar")
        end,
        [".tar.gz"] = function()
            ucmp = import("./tar")
        end,
        [".tar.bz2"] = function()
            ucmp = import("./tar")
        end,
        [".gz"] = function()
            ucmp = import("./gz")
        end,
        [".bz2"] = function()
            ucmp = import("./bz2")
        end
    }
    for name, fn in pairs(_switch) do
        if strings.HasSuffix(src, name) then
            fn()
            if ucmp ~= nil and type(ucmp.uncompress) == "function" then
                ucmp.uncompress(opt)
            end
            return
        end
    end
end

return {
    compress = compress,
    uncompress = uncompress
}
