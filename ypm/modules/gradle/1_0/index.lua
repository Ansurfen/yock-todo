---@diagnostic disable: undefined-global
local gradle = {}

function gradle:open(file)
    local obj = {
        segments = {},
        index = {},
    }

    setmetatable(obj, { __index = self })

    local raw, err = read_file(file)
    yassert(err)
    local scanner = bufio.NewScanner(strings.NewReader(raw))
    scanner:Split(bufio.ScanLines)

    local re = reglib:new({
        full = [[(\w+) {.*}]],
        left = [[(\w+) {]],
        right = "}$"
    })
    local curKey = 0
    local commit = true
    local keys = {}
    while scanner:Scan() do
        local text = scanner:Text()
        table.insert(obj.segments, text)
        local idx = #obj.segments
        if re:match_str("full", text) then
            local key = re:find_str("full", text)
            if #keys ~= 0 then
                key = string.format("%s.%s", keys[#keys], key)
            end
            local tmp = obj.segments[#obj.segments]
            local space_size = #tmp - #tmp:gsub("^%s+", "")
            obj.segments[#obj.segments] = strings.ReplaceAll(tmp, "}",
                string.format("\n%s}", string.rep(" ", space_size)))
            table.insert(keys, key)
            obj.index[key] = { start = idx, eof = idx }
        elseif re:match_str("left", text) then
            curKey = curKey + 1
            commit = false
            local key = re:find_str("left", text)
            if #keys ~= 0 then
                key = string.format("%s.%s", keys[#keys], key)
            end
            table.insert(keys, key)
            obj.index[key] = { start = idx }
        elseif re:match_str("right", text) then
            curKey = curKey - 1
            local k = keys[curKey + 1]
            if k ~= nil then
                obj.index[k]["end"] = idx
            end
        end

        if curKey == 0 and not commit then
            commit = true
            keys = {}
        end
    end
    yassert(scanner:Err())
    return obj
end

function gradle:add_deps(deps)
    local s = self.index["dependencies"]["start"]
    local e = self.index["dependencies"]["end"]
    if s == e then
        return
    end
    local space_size = 0
    if s + 1 == e then
        space_size = #self.segments[s] / 2
    else
        local tmp = self.segments[s + 1]
        space_size = #tmp - #tmp:gsub("^%s+", "")
    end
    for _, dep in ipairs(deps) do
        local dep_str = string.format("%simplementation '%s:%s:%s'", string.rep(" ", space_size),
            (dep["groupId"] or ""), (dep["artifactId"] or ""), (dep["ver"] or ""))
        table.insert(self.segments, e, dep_str)
        e = e + 1
    end
    self.index["dependencies"]["end"] = e
end

function gradle:get_deps()
    local re = regexp.MustCompile([[(implementation|testImplementation).*'(.*)']])
    local deps = {}
    local s = self.index["dependencies"]["start"]
    local e = self.index["dependencies"]["end"]
    for i = s + 1, e - 1, 1 do
        local res = re:FindStringSubmatch(self.segments[i])
        if res ~= nil and #res > 1 then
            local dep = strings.Split(res[3], ":")
            table.insert(deps, {
                groupId = dep[1] or "",
                artifactId = dep[2] or "",
                version = dep[3] or "",
                index = i
            })
        end
    end
    return deps
end

function gradle:rm_deps(v)
    local deps = self:get_deps()
    for _, vv in ipairs(v) do
        for _, dep in ipairs(deps) do
            if dep["groupId"] == vv["groupId"] and dep["artifactId"] == vv["artifactId"] then
                table.remove(self.segments, dep["index"])
            end
        end
    end
end

function gradle:add_repo(v)
    local s = self.index["repositories"]["start"]
    local e = self.index["repositories"]["end"]
    if s == e then
        return
    end
end

function gradle:get_repo()
    local repos = {}
    local s = self.index["repositories"]["start"]
    local e = self.index["repositories"]["end"]
    for i = s + 1, e - 1, 1 do
        local repo = strings.TrimSpace(self.segments[i])
        if #repo > 0 and unicode.IsLetter(string.byte(repo, 1)) then
            table.insert(repos, {
                repo = repo,
                index = i
            })
        end
    end
    return repos
end

function gradle:init(opt)
    local init = argBuilder:new():add("gradle init")
    init:add_str("--type " .. (opt["type"] or ""), opt["type"]):
        add_str("--dsl " .. (opt["dsl"] or ""), opt["dsl"]):
        add_str("--test-framework " .. (opt["test-framework"] or ""), opt["test-framework"]):
        add_str("--project-name " .. (opt["project-name"] or ""), opt["project-name"]):
        add_str("--package " .. (opt["package"] or ""), opt["package"])
    sh({ debug = false, redirect = false }, init:build())
end

function gradle:dump()
    for _, line in ipairs(self.segments) do
        print(line)
    end
end

return gradle
