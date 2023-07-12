return function(fullpath)
    local ok = false
    return function()
        if ok then
            return false, nil, nil
        end
        local vs_installer
        path.walk([[C:\Program Files (x86)]], function(p, info, err)
            if path.base(p) == "vs_installer.exe" then
                ok = true
                vs_installer = p
                return false
            end
            return true
        end)
        if vs_installer ~= nil then
            cd("C:")
            cd(path.dir(vs_installer))
            local out, err = sh({ debug = false, redirect = false }, [[.\vswhere.exe]])
            yassert(err)
            return true, "vs", {
                ver = out[1]
            }
        end
        return false, nil, nil
    end
end
