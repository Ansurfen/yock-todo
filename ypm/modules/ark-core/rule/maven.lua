return function(fullpath)
    local fast_match = import("../util/match")
    local target = ""
    if env.platform.OS == "windows" then
        target = "mvn.cmd"
    else
        target = "mvn"
    end
    if path.base(fullpath) == target then
        local out, err = sh({ debug = false, redirect = false }, "mvn --version")
        yassert(err)
        return true, "maven", {
            ver = fast_match("Apache Maven (.*) \\(", out[1]),
            path = fullpath,
            spec = {
                runtime = fast_match([[runtime: (.*)]], out[1]),
                locale = fast_match([[Default locale: (\w*)]], out[1]),
                encoding = fast_match([[platform encoding: (\w*)]], out[1]),
            }
        }
    end
    return false, nil, nil
end
