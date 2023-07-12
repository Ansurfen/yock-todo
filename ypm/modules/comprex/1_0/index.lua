---@diagnostic disable: undefined-global

local comprex = function(opt)
    local cmp
    local checkModule
    if opt["module"] ~= nil then
        checkModule = function(m)
            return m == opt["module"]
        end
    else
        checkModule = function()
            return true
        end
    end
    optional({
        case(checkModule("win-comprex"), OS("windows", "10+"), function()
            cmp = import("win-comprex@1.0")
        end),
        case(checkModule("bandizip"), Windows(), CheckEnv("bz -v", "Bandizip console tool"), function()
            cmp = import("bandizip@1.0")
        end),
        case(checkModule("linux-comprex"), Linux(), function()
            cmp = import("linux-comprex@1.0")
        end)
    })
    return cmp
end

local compress = function(opt)
    local cmp = comprex(opt)
    if cmp ~= nil and type(cmp.compress) == "function" then
        cmp.compress(opt)
    end
end

local uncompress = function(opt)
    local cmp = comprex(opt)
    if cmp ~= nil and type(cmp.uncompress) == "function" then
        cmp.uncompress(opt)
    end
end

return {
    compress = compress,
    uncompress = uncompress
}
