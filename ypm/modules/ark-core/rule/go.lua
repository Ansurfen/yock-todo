return function(fullpath)
    local target = ""
    if env.platform.OS == "windows" then
        target = "go.exe"
    else
        target = "go"
    end
    if path.base(fullpath) == target then
        local out, err = sh({ debug = false, redirect = false }, "go version")
        yassert(err)
        local reg = regexp.MustCompile("go version (.*) ")
        local res = reg:FindStringSubmatch(out[1])
        out, err = sh({ debug = false, redirect = false }, "go env -json")
        yassert(err)
        if #res > 1 then
            return true, "go", { ver = res[2], path = fullpath, spec = json.decode(out[1]) }
        end
    end
    return false, nil, nil
end
