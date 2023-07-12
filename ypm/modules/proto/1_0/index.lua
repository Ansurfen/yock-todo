---@diagnostic disable: undefined-global
local install = function(opt)
    local ark_core = import("ark-core@1.0")
    local res = ark_core.install(path.join(cur_dir(), "..", "require.json"), {
        ver = opt["ver"] or "",
        os = opt["os"] or env.platform.OS,
        arch = opt["arch"] or env.platform.Arch,
    })
    local filename
    if not CheckEnv("protoc --version", "libprotoc " .. (opt["ver"] or "")) then
        if res.url ~= nil then
            filename = fetch.file(res.url, path.ext(res.url))
        end
    end
    local cx = import("comprex@1.0")
    cx.uncompress({
        debug = opt["debug"] or false,
        redirect = opt["redirect"] or false,
        src = path.join(env.yock_path, "tmp", filename),
        dst = "test"
    })
end

return {
    install = install
}
