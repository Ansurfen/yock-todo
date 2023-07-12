local query = function(require, opt)
    local fp = jsonfile:open(require)
    local tbl = fp.buf
    local max = 0
    local res = {}
    if opt ~= nil and opt.ver ~= nil then
        tbl = tbl[opt.ver]
        if tbl ~= nil then
            for _, candidate in ipairs(tbl) do
                local lmax = 0
                for key, value in pairs(opt) do
                    if key ~= "ver" then
                        local v = candidate["check"][key]
                        if v ~= nil then
                            if v == value then
                                lmax = lmax + 1
                            else
                                lmax = -1
                                break
                            end
                        end
                    end
                end
                if lmax > max then
                    res = candidate
                    max = lmax
                end
            end
        end
    end
    return res
end

return function(opt)
    local requirefile = path.join(opt["dir"], "..", opt["require"])
    local res = query(requirefile, {
        ver = opt.meta["ver"] or "",
        os = opt.meta["os"] or env.platform.OS,
        arch = opt.meta["arch"] or env.platform.Arch,
    })
    local filename
    if type(opt.check) == "function" and not opt.check() then
        if res.url ~= nil then
            filename = fetch.file(res.url, path.ext(res.url))
        end
    end
    return filename
end
