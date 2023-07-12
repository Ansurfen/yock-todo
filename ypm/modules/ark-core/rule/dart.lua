return function(fullpath)
    local target = ""
    if env.platform.OS == "windows" then
        target = "dart.exe"
    else
        target = "dart"
    end
    if path.base(fullpath) == target then
        local out, err = sh({ debug = false, redirect = false }, "dart --version")
        yassert(err)
        local reg = regexp.MustCompile("Dart SDK version: ((\\d|\\.)*) \\(")
        local res = reg:FindStringSubmatch(out[1])
        if #res > 1 then
            return true, "dart", { ver = res[2], path = fullpath }
        end
    end
    return false, nil, nil
end
