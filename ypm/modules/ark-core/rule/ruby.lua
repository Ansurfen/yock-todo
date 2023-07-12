return function(fullpath)
    local fast_match = import("../util/match")
    local target = ""
    if env.platform.OS == "windows" then
        target = "ruby.exe"
    else
        target = "ruby"
    end
    if path.base(fullpath) == target then
        local out, err = sh({ debug = false, redirect = false }, "ruby -v")
        yassert(err)
        return true, "ruby", {
            ver = fast_match([[ruby ((\d|\.)*)]], out[1]),
            path = fullpath,
        }
    end
    return false, nil, nil
end