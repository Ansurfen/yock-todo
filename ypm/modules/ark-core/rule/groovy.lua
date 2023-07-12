return function(fullpath)
    local fast_match = import("../util/match")
    local target = ""
    if env.platform.OS == "windows" then
        target = "groovy.bat"
    else
        target = "groovy"
    end
    if path.base(fullpath) == target then
        local out, err = sh({ debug = false, redirect = false }, "groovy -v")
        yassert(err)
        local reg = regexp.MustCompile([[Groovy Version: ((\d|\.)*)]])
        local res = reg:FindStringSubmatch(out[1])
        if #res > 1 then
            return true, "groovy", {
                ver = res[2],
                path = fullpath,
                spec = {
                    jvm = fast_match([[ JVM: ((\d|\.)*)]], out[1])
                }
            }
        end
    end
    return false, nil, nil
end
