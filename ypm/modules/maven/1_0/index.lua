---@diagnostic disable: undefined-global
local maven = {
    pom = {}
}

---@vararg string
local mvn_build = function(...)
    return cmdf("mvn", ...)
end

function maven:new()
    local obj = {
        pom = {}
    }
    setmetatable(obj, { __index = self })
    setmetatable(obj.pom, { __index = self.pom })
    local java = import("java@1.0")
    local parse, cvt = java.dep_adapter("maven")
    self.pom.cvt = cvt
    self.pom.parse = parse
    return obj
end

---@param file string
function maven:bind_pom(file)
    self.pom.file = file
end

function maven.install(opt)
    local r = true
    if opt["redirect"] ~= nil then
        r = opt["redirect"]
    end
    return exec({
        redirect = r,
        debug = opt["debug"] or false
    }, mvn_build("install"))
end

function maven:compile()

end

function maven:test()

end

function maven:clean()

end

function maven:pacakge()

end

function maven:deploy()

end

function maven:site()

end

function maven.dependency()

end

function maven:help()

end

---@return string
function maven:version()
    return mvn_build("version")
end

---@return string
function maven:v()
    local info, _ = cmd(mvn_build("-v"))
    return info
end

function maven.pom:dep_cvt(fn)
    self.cvt = fn
end

function maven.pom:open()

end

function maven.pom:dep_parse(fn)
    self.parse = fn
end

function maven.pom:get_props()

end

function maven.pom:add_props()

end

function maven.pom:rm_props()

end

function maven.pom:get_deps()
    if self.file == nil then
        yassert("no binding pom.xml")
    end
    local text, err = read_file(self.file)
    yassert(err)
    local xmlDoc = xml()
    xmlDoc:ReadFromBytes(text)
    local deps_doc = xmlDoc:SelectElement("project"):SelectElement("dependencies"):FindElements("dependency")
    local deps = {}
    for i = 1, #deps_doc, 1 do
        table.insert(deps, {
            groupId = deps_doc[i]:SelectElement("groupId"):Text(),
            artifactId = deps_doc[i]:SelectElement("artifactId"):Text(),
            version = deps_doc[i]:SelectElement("version"):Text(),
        })
    end
    return deps
end

---@vararg string
function maven.pom:add_deps(...)
    if self.deps == nil then
        self.deps = {}
    end
    for _, dep in ipairs({ ... }) do
        if self.cvt ~= nil then
            table.insert(self.deps, self.parse(dep))
        end
    end
end

---@vararg string
function maven.pom:rm_deps(...)
    if self.dels == nil then
        self.dels = {}
    end
    for _, dep in ipairs({ ... }) do
        table.insert(self.dels, dep)
    end
end

---@vararg string
function maven.pom:apply(...)
    local docs = {}
    if self.file ~= nil then
        table.insert(docs, self.file)
    end
    for _, file in ipairs({ ... }) do
        table.insert(docs, file)
    end

    for _, file in ipairs(docs) do
        local doc = xml()
        yassert(doc:ReadFromFile(file))
        local deps_doc = doc:SelectElement("project"):SelectElement("dependencies")

        for _, dep in ipairs(self.deps) do
            local dep_doc = deps_doc:CreateElement("dependency")
            dep_doc:CreateElement("groupId"):SetText(dep["groupId"])
            dep_doc:CreateElement("artifactId"):SetText(dep["artifactId"])
        end

        if #self.dels > 0 then
            local dep_doc = deps_doc:SelectElements("dependency")
            for i = 1, #dep_doc, 1 do
                local id = dep_doc[i]:SelectElement("groupId"):Text()
                for _, dep in ipairs(self.dels) do
                    if dep == id then
                        deps_doc:RemoveChild(dep_doc[i])
                    end
                end
            end
        end

        doc:IndentTabs()
        doc.WriteSettings.UseCRLF = true
        yassert(doc:WriteToFile(file))
    end
end

function maven.pom:dump()
    print("append list:")
    local row = {}
    for _, dep in ipairs(self.deps) do
        table.insert(row, { "\t" .. dep["groupId"], dep["artifactId"], dep["version"] })
    end
    printf({ "\tgroupId", "artifactId", "version" }, row)
    print("remove list:")
    for _, dep in ipairs(self.dels) do
        print("\t" .. dep .. "\n")
    end
end

function maven:archetype(opt)
    local archetype = argBuilder:new():add("mvn archetype:generate")
    for key, value in pairs(opt) do
        local v = value
        if type(value) == "boolean" then
            if value then
                v = "true"
            else
                v = "false"
            end
            archetype:add(string.format("-D%s=%s", key, v))
        else
            archetype:add(string.format("-D%s=\"%s\"", key, v))
        end
    end
    print(archetype:build())
    sh(archetype:build())
end

return { maven = maven, pom = import("./pom") }
