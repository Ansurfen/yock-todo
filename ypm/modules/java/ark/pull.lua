---@diagnostic disable: undefined-global
return function(handle, opt)
    return handle({
        require = "../require.json",
        meta = opt,
        check = function()
            return CheckEnv("java --version", "java " .. (opt["ver"] or ""))
        end,
        dir = debug.getinfo(1, 'S').source
    })
end
