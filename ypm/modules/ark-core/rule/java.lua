return function(fullpath)
    local fast_match = import("../util/match")
    local target = ""
    if env.platform.OS == "windows" then
        target = "java.exe"
    else
        target = "java"
    end
    if path.base(fullpath) == target then
        local out, err = sh({ debug = false, redirect = false }, "java --version")
        yassert(err)
        return true, "java", {
            ver = fast_match([[java ((\d|\.)*)]], out[1]),
            path = fullpath,
        }
    end
    return false, nil, nil
end