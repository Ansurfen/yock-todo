---@diagnostic disable: undefined-global
local dep_converter = {}

---@param raw string
---@return table
function dep_converter:parse(raw)
    if strings.Contains(raw, "<dependency>") then
        return self:parse_maven(raw)
    end
    if strings.Contains(raw, "testImplementation group") then
        return self:parse_gradle(raw)
    end
    return {}
end

--  <dependency>
-- 	<groupId>org.springframework.boot</groupId>
-- 	<artifactId>spring-boot-starter-test</artifactId>
-- 	<version>3.0.2</version>
-- 	<scope>test</scope>
--  </dependency>
---@param raw string
---@return table
function dep_converter:parse_maven(raw)
    local doc = xml()
    doc:ReadFromBytes(raw)
    local dep = doc:SelectElement("dependency")
    return {
        groupId = dep:SelectElement("groupId"):Text() or "",
        artifactId = dep:SelectElement("artifactId"):Text() or "",
        version = dep:SelectElement("version"):Text() or ""
    }
end

-- testImplementation group: 'org.springframework.boot', name: 'spring-boot-starter-test', version: '3.0.2'
function dep_converter:parse_gradle(raw)
    local str = raw
    local reg = regexp.MustCompile("'(.*)'")
    local after, ok = strings.CutPrefix(str, "testImplementation ")
    if ok then
        local dep = {}
        for _, src in ipairs(strings.Split(after, ",")) do
            local _, subAfter, okk = strings.Cut(src, ":")
            if okk then
                table.insert(dep, reg:FindStringSubmatch(subAfter)[1])
            end
        end
        if #dep == 3 then
            return {
                groupId = string.sub(dep[1], 2, #dep[1] - 1) or "",
                artifactId = string.sub(dep[2], 2, #dep[2] - 1) or "",
                version = string.sub(dep[3], 2, #dep[3] - 1) or ""
            }
        end
    end
    return {}
end

---@return string
function dep_converter:maven(dep)
    return string.format([[<dependency>
    <groupId>%s</groupId>
    <artifactId>%s</artifactId>
    <version>%s</version>
</dependency>]], dep["groupId"], dep["artifactId"], dep["version"])
end

---@return string
function dep_converter:gradle(dep)
    return string.format([[testImplementation group: '%s', name: '%s', version: '%s']], dep["groupId"], dep
        ["artifactId"], dep["version"])
end

return dep_converter
