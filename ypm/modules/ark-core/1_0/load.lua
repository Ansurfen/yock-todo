---@diagnostic disable: undefined-field
return function(opt)
    local filename = opt["id"]
    path.walk(env.yock_tmp, function(p, info, err)
        local f = path.filename(path.base(p))
        if strings.HasPrefix(f, filename) then
            filename = p
            return false
        end
        return true
    end)
    local cx = load_module("comprex@1.0")
    cx.uncompress({
        debug = opt["debug"] or false,
        redirect = opt["redirect"] or false,
        src = filename,
        dst = opt["path"]
    })
    print(opt["path"])
end
