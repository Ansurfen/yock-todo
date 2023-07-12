return function(fullpath)
    local target = ""
    if env.platform.OS == "windows" then
        target = "node.exe"
    else
        target = "node"
    end
    if path.base(fullpath) == target then
        local out, err = sh({ debug = false, redirect = false }, "node -v")
        yassert(err)
        return true, "node", {
            ver = out[1],
            path = fullpath,
        }
    end
    return false, nil, nil
end
