return function(fullpath)
    local fast_match = import("../util/match")
    local target = ""
    if env.platform.OS == "windows" then
        target = "lua.exe"
    else
        target = "lua"
    end
    if path.base(fullpath) == target then
        local out, err = sh({ debug = false, redirect = false }, "lua -v")
        yassert(err)
        return true, "lua", {
            ver = fast_match([[Lua ((\d|\.)*)]], out[1]),
            path = fullpath,
        }
    end
    return false, nil, nil
end
