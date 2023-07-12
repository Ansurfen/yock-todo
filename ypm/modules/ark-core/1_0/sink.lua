---@diagnostic disable: undefined-field
local sink = function(opt)
    local install = import("./install")
    local requirefile = path.join(debug.getinfo(2, 'S').source, "..", opt["require"])
    local res = install(requirefile, {
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
    local cx = import("comprex@1.0")
    cx.uncompress({
        debug = opt.meta["debug"] or false,
        redirect = opt.meta["redirect"] or false,
        src = path.join(env.yock_path, "tmp", filename),
        dst = path.join(env.yock_bin, opt.meta["name"], opt.meta["ver"])
    })
end

return sink
