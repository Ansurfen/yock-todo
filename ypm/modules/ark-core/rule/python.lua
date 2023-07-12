return function(fullpath)
    local target = ""
    if env.platform.OS == "windows" then
        target = "python.exe"
    else
        target = "python"
    end
    if path.base(fullpath) == target then
        local out, err = sh({ debug = false, redirect = false }, "python -v")
        yassert(err)
        local reg = regexp.MustCompile([[Python ((\d|\.)*)]])
        local res = reg:FindStringSubmatch(out[1])
        if #res > 1 then
            return true, "python", {
                ver = res[2],
                path = fullpath,
                spec = {
                }
            }
        end
    end
    return false, nil, nil
end