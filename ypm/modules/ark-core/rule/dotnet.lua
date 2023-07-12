return function(fullpath)
    local target = ""
    if env.platform.OS == "windows" then
        target = "dotnet.exe"
    else
        target = "dotnet"
    end
    if path.base(fullpath) == target then
        local out, err = sh({ debug = false, redirect = false }, "dotnet --version")
        yassert(err)
        return true, "dotnet", {
            ver = out[1],
            path = fullpath,
        }
    end
    return false, nil, nil
end
