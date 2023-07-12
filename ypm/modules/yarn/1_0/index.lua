local add_deps = function(...)
    print("yarn add", ...)
end

local rm_deps = function()
    print("yarn uninstall")
end

local run = function()
    print("yarn run")
end

return {
    run = run,
    add_deps = add_deps,
    rm_deps = rm_deps
}
