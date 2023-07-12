return function(fullpath)
    local fast_match = import("../util/match")
    local target = ""
    if env.platform.OS == "windows" then
        target = "perl.exe"
    else
        target = "perl"
    end
    if path.base(fullpath) == target then
        local out, err = sh({ debug = false, redirect = false }, "perl -v")
        yassert(err)
        return true, "perl", {
            ver = fast_match([[\(v((\d|\.)*)\)]], out[1]),
            path = fullpath,
        }
    end
    return false, nil, nil
end