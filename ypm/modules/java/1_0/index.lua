---@diagnostic disable: undefined-global

local dep_adapter = function(parser)
    local converter = import("./parser")
    local cvt
    local _switch = {
        ["maven"] = function(dep)
            return converter:maven(dep)
        end,
        ["gradle"] = function(dep)
            return converter:gradle(dep)
        end
    }
    local f = _switch[parser]
    if f ~= nil then
        cvt = f
    else
        cvt = function(dep)
            return dep
        end
    end
    return function(raw)
        return converter:parse(raw)
    end, cvt
end

return {
    dep_adapter = dep_adapter,
    install = import("./ark"),
    java = import("./java"),
    javac = import("./javac"),
    jar = import("./jar"),
    manifest = import("./manifest")
}
