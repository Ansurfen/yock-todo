return function(fullpath)
    local fast_match = import("../util/match")
    local target = ""
    if env.platform.OS == "windows" then
        target = "gcc.exe"
    else
        target = "gcc"
    end
    if path.base(fullpath) == target then
        local out, err = sh({ debug = false, redirect = false }, "gcc -v")
        yassert(err)
        return true, "gcc", {
            ver = fast_match([[gcc version ((\d|\.)*)]], out[1]),
            path = fullpath,
        }
    end
    return false, nil, nil
end
