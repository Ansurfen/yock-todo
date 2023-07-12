local pom = {}

local blankPom = [[<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
</project>]]

function pom:create(file)
    safe_write(file, blankPom)
    local obj = {
        doc = xmlFile:open(file)
    }
    setmetatable(obj, { __index = self })
    return obj
end

function pom:open(file)
    local obj = {
        doc = xmlFile:open(file)
    }
    setmetatable(obj, { __index = self })
    return obj
end

function pom:get_modelVersion()
    return self.doc:select("project.modelVersion"):Text()
end

function pom:set_modelVersion(v)
    self.doc:select("project.modelVersion"):SetText(v)
end

function pom:get_groupId()
    return self.doc:select("project.groupId"):Text()
end

function pom:set_groupId(v)
    self.doc:select("project.groupId"):SetText(v)
end

function pom:get_artifactId()
    return self.doc:select("project.artifactId"):Text()
end

function pom:set_artifactId(v)
    self.doc:select("project.artifactId"):SetText(v)
end

function pom:get_version()
    return self.doc:select("project.version"):Text()
end

function pom:set_version(v)
    self.doc:select("project.version"):SetText(v)
end

function pom:get_name()
    return self.doc:select("project.name"):Text()
end

function pom:set_name(v)
    self.doc:select("project.name"):SetText(v)
end

function pom:get_url()
    return self.doc:select("project.url"):Text()
end

function pom:set_url(v)
    self.doc:select("project.url"):SetText(v)
end

function pom:add_deps(v)
    local deps = self:get_deps()
    for _, vv in ipairs(v) do
        local exist = false
        for _, dep in pairs(deps) do
            if dep["groupId"] == vv["groupId"] and dep["artifactId"] == vv["artifactId"] then
                exist = true
            end
        end
        if not exist then
            local c = self.doc:create_element("project.dependencies.dependency")
            c:CreateElement("groupId"):SetText(vv["groupId"])
            c:CreateElement("artifactId"):SetText(vv["artifactId"])
            c:CreateElement("version"):SetText(vv["ver"])
        end
    end
end

function pom:rm_deps(v)
    local deps_doc = self.doc:selects("project.dependencies.dependency")
    for _, vv in ipairs(v) do
        for i = 1, #deps_doc, 1 do
            local groupId = deps_doc[i]:SelectElement("groupId"):Text()
            local artifactId = deps_doc[i]:SelectElement("artifactId"):Text()
            if vv["groupId"] == groupId and vv["artifactId"] == artifactId then
                self.doc:select("project.dependencies"):RemoveChild(deps_doc[i])
            end
        end
    end
end

function pom:get_deps()
    local deps_doc = self.doc:selects("project.dependencies.dependency")
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

function pom:set_deps(deps)
    local deps_doc = self.doc:select("project.dependencies")
    self.doc:select("project"):RemoveChild(deps_doc)
    deps_doc = self.doc:create_element("project.dependencies")
    for _, dep in ipairs(deps) do
        local c = deps_doc:CreateElement("dependency")
        c:CreateElement("groupId"):SetText(dep["groupId"])
        c:CreateElement("artifactId"):SetText(dep["artifactId"])
        c:CreateElement("version"):SetText(dep["ver"])
    end
end

function pom:add_props(v)
    local props = self:get_props()
    for k, vv in pairs(v) do
        if props[k] == nil then
            self.doc:select("project.properties"):CreateElement(k):SetText(vv)
        end
    end
end

function pom:rm_props(...)
    for _, v in ipairs({ ... }) do
        local props_doc = self.doc:select("project.properties"):ChildElements()
        for i = 1, #props_doc, 1 do
            if v == props_doc[i].Tag then
                self.doc:select("project.properties"):RemoveChild(props_doc[i])
            end
        end
    end
end

function pom:get_props()
    local props = {}
    local props_doc = self.doc:select("project.properties"):ChildElements()
    for i = 1, #props_doc, 1 do
        props[props_doc[i].Tag] = props_doc[i]:Text()
    end
    return props
end

function pom:set_props(v)
    for k, vv in pairs(v) do
        self.doc:select("project.properties"):CreateElement(k):SetText(vv)
    end
end

function pom:get_plugins()
    local plugins = {}
    local plugins_doc
    plugins_doc = self.doc:select("project.build.plugins")
        or self.doc:select("project.build.pluginManagement.plugins")
    plugins_doc = plugins_doc:ChildElements()
    for i = 1, #plugins_doc, 1 do
        table.insert(plugins, {
            artifactId = plugins_doc[i]:SelectElement("artifactId"):Text(),
            version = plugins_doc[i]:SelectElement("version"):Text()
        })
    end
    return plugins
end

function pom:dump()
    self.doc:dump()
end

return pom
