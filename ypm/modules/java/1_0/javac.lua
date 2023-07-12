---@diagnostic disable: undefined-global
return function(opt)
    local javac = argBuilder:new():add("javac")

    local sourcepath = opt["sourcepath"]
    if sourcepath ~= nil then
        sourcepath = strings.Join(sourcepath, " ")
    end
    local c = opt["charset"]
    local o = opt["object"]
    local mainClass = opt["mainClass"]

    javac:add_str("-sourcepath " .. (sourcepath or ""), sourcepath)
        :add_str("-d " .. (o or ""), o)
        :add_str("-encoding " .. (c or ""), c)
        :add_str(mainClass, mainClass)
    sh(javac:build())
end
