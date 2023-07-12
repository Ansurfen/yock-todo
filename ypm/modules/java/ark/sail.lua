return function(handle, opt)
    return handle({
        require = "../require.json",
        dir = debug.getinfo(1, 'S').source,
        meta = opt
    })
end
