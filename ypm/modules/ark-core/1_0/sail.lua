---@diagnostic disable: undefined-global
return function(opt)
    local requirefile = path.join(opt["dir"], "..", opt["require"])
    local fp = jsonfile:open(requirefile)
    local tbl = fp.buf
    local meta = {
        os = env.platform.OS,
        arch = env.platform.Arch
    }
    local rows = {}
    for k, v in pairs(tbl) do
        for _, vv in ipairs(v) do
            local match = "✔"
            for attr, got in pairs(meta) do
                local want = vv["check"][attr]
                if want ~= nil and want ~= got then
                    match = ""
                    break
                end
            end
            table.insert(rows, { k, (vv["check"]["os"] or ""), (vv["check"]["arch"] or ""), match })
        end
    end
    printf({ "Version", "OS", "Arch", "Match" }, rows)
end
