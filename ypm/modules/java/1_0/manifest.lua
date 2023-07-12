local manifest = {}

function manifest:setStartClass(c)
    self.startClass = c
end

function manifest:getStartClass()
    return self.startClass
end

function manifest:setBuildJdkSpec(v)
    self.buildJdkSpec = v
end

function manifest:getBuildJdkSpec()
    return self.buildJdkSpec
end

function manifest:setBuildBy(v)
    self.buildBy = v
end

function manifest:getBuildBy()
    return self.buildBy
end

function manifest:setCreatedBy(v)
    self.createdBy = v
end

function manifest:getCreatedBy()
    return self.createdBy
end

function manifest:setBuildJdk(v)
    self.buildJdk = v
end

function manifest:getBuildJdk()
    return self.buildJdk
end

function manifest:setArchVersion(v)
    self.archVer = v
end

function manifest:getArchVersion()
    return self.archVer
end

function manifest:setMainClass(v)
    self.mainClass = v
end

function manifest:getMainClass()
    return self.mainClass
end

function manifest:setVersion(v)
    self.ver = v
end

function manifest:getVersion()
    return self.ver
end

function manifest:setClassPath(v)
    self.classPath = v
end

function manifest:getClassPath()
    return self.classPath
end

function manifest:addClassPath(v)
    table.insert(self.classPath, v)
end

function manifest:new()
    local obj = {
        ver = "1.0",
        mainClass = "",
        classPath = {},
        archVer = "",
        startClass = "",
        buildJdkSpec = "",
        buildBy = "",
        createdBy = "",
        buildJdk = ""
    }
    setmetatable(obj, { __index = self })
    return obj
end

function manifest:write()
    safe_write("MANIFEST.MF", self:toString())
end

function manifest:toString()
    local buf = ""
    if type(self.ver) == "string" and #self.ver > 0 then
        buf = buf .. string.format("Manifest-Version: %s\n", self.ver)
    end
    if type(self.archVer) == "string" and #self.archVer > 0 then
        buf = buf .. string.format("Archiver-Version: %s\n", self.archVer)
    end
    if type(self.mainClass) == "string" and #self.mainClass > 0 then
        buf = buf .. string.format("Main-Class: %s\n", self.mainClass)
    end
    if type(self.startClass) == "string" and #self.startClass > 0 then
        buf = buf .. string.format("Start-Class: %s\n", self.startClass)
    end
    if type(self.buildJdkSpec) == "string" and #self.buildJdkSpec > 0 then
        buf = buf .. string.format("Build-Jdk-Spec: %s\n", self.buildJdkSpec)
    end
    if type(self.buildBy) == "string" and #self.buildBy > 0 then
        buf = buf .. string.format("Build-By: %s\n", self.buildBy)
    end
    if type(self.createdBy) == "string" and #self.createdBy > 0 then
        buf = buf .. string.format("Created-By: %s\n", self.createdBy)
    end
    if type(self.buildJdk) == "string" and #self.buildJdk > 0 then
        buf = buf .. string.format("Build-Jdk: %s\n", self.buildJdk)
    end
    if type(self.classPath) == "table" then
        buf = buf .. string.format("Class-Path: %s\n", strings.Join(self.classPath, " "))
    end
    return string.sub(buf, 0, #buf - 1)
end

return manifest
