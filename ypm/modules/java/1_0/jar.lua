---@diagnostic disable: undefined-global
return function(opt)
    local jar = argBuilder:new():add("jar")

    local v = opt["verbose"]
    local o = opt["object"]
    local m = opt["manifest"]
    local d = opt["dir"]

    if v ~= nil and o ~= nil and m ~= nil then
        jar:add("-cvfm"):add_str(o, o):add_str(m, m):add_str(d, d)
        goto exec
    end

    if v ~= nil and o ~= nil then
        jar:add("-cvf"):add_str(o, o)
        goto exec
    end
    ::exec::
    sh(jar:build())
end
