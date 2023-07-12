local factor = {
    none = 0,
    alpha = 3,
    beta = 2,
    rc = 1
}

function is_closure(func)
    local info = debug.getinfo(func, "u")
    return info and info.nups > 0
end

local INFINITY = {
    Pos = 999,
    Neg = -999
}
-- ! 注意有些版本冲突的依旧为可达的，有些是硬性要求的所以不可达，所以可达的依旧可以修复
function test()
    -- local vs_installer
    -- path.walk([[C:\Program Files (x86)]], function(fullpath, info, e)
    --     if path.base(fullpath) == "vs_installer.exe" then
    --         vs_installer = fullpath
    --         return false
    --     end
    --     return true
    -- end)
    -- cd("C:")
    -- cd(path.dir(vs_installer))
    -- local out, err = sh({ debug = false, redirect = false }, ".\\vswhere.exe")
    -- yassert(err)
    -- table.dump(out)
    -- print(vs_installer)
    local portfolios = {}

    local nodes = {}
    nodes["maven"] = {
        check = function()
            local load = 0
            if false then
                load = INFINITY.Neg
            end
            return load
        end,
        -- ! 静态代价 + 动态代价 = 实际代价
        robust = {
            app = factor.rc,
            module = factor.rc,
            favour = factor.none
        },
        cache = INFINITY.Neg
    }
    nodes["gradle"] = {
        check = function()
            local load = 0
            if env.platform.OS == "windows" then
                load = load + 1
            else
                load = INFINITY.Pos
            end
            return load
        end,
        robust = {
            app = factor.rc,
            module = factor.beta,
            favour = factor.none
        },
        cache = INFINITY.Neg
    }
    nodes["ant"] = {
        check = function()
            local load = 0
            if env.platform.OS == "windows" then
                load = load + 1
            end
            return load
        end,
        robust = {
            app = factor.rc,
            module = factor.alpha,
            favour = factor.rc
        },
        cache = INFINITY.Neg
    }
    portfolios["maven"] = { nodes["maven"] }
    portfolios["gradle"] = { nodes["gradle"] }
    portfolios["ant"] = { nodes["ant"] }
    for pn, ns in pairs(portfolios) do
        local global_cost = 0
        for _, node in ipairs(ns) do
            local real_cost
            if node.cache ~= INFINITY.Neg then
                real_cost = node.cache
            else
                local static_cost = node.robust.app + node.robust.module
                if node.robust.favour == factor.rc then
                    static_cost = static_cost - 2
                elseif node.robust.favour == factor.beta then
                    static_cost = static_cost - 1
                elseif node.robust.favour == factor.alpha then
                    static_cost = static_cost + 1
                end
                local dynamic_cost = node.check()
                real_cost = static_cost + dynamic_cost
            end
            if real_cost >= INFINITY.Pos - 3 then
                global_cost = INFINITY.Pos
            elseif real_cost <= INFINITY.Neg + 3 then

            else
                global_cost = global_cost + real_cost
            end
            node.cache = real_cost
        end
        -- 最后判断，其实在上面那部 cost 就可以判断了无穷大到不了，组合报废，无穷小没有消耗
        print(pn, global_cost)
    end
end

local inspect = function()
    local inspectCache = "./cache.json"
    if is_exist(inspectCache) then
        return jsonfile:open(inspectCache).buf
    end
    ---@diagnostic disable-next-line: undefined-global
    local rule_path = path.join(cur_dir(), "..", "rule")
    local raw_rules, err = ls({
        dir = rule_path
    })
    yassert(err)
    local rules = {}
    ---@diagnostic disable-next-line: param-type-mismatch
    for _, rule in ipairs(raw_rules) do
        local file = path.join(rule_path, rule[4])
        file = string.sub(file, 1, #file - 4)
        local fn = import(file)
        if is_closure(fn) then
            fn = fn()
        end
        table.insert(rules, fn)
    end
    local report = {}
    for _, kv in ipairs(env.environ()) do
        local res = strings.Split(kv, "=")
        if res[1] == "Path" then
            for _, root in ipairs(strings.Split(res[2], ";")) do
                -- filter layer
                if strings.Contains(root, "C:\\windows") then
                    goto continue
                end
                -- match layer
                path.walk(root, function(file, info, err)
                    if err ~= nil then
                        return true
                    end
                    if not info:IsDir() then
                        for _, rule in ipairs(rules) do
                            local ok, name, shim = rule(file)
                            if type(ok) == "boolean" and ok then
                                report[name] = shim
                            end
                        end
                    end
                    return true
                end)
                ::continue::
            end
        end
    end
    write_file(inspectCache, json.encode(report))
    return report
end

return inspect
