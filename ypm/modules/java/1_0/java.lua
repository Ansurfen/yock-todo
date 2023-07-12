---@diagnostic disable: undefined-global
return function(opt)
    local java = argBuilder:new():add("java")

    local cp = opt["cp"]
    local mainClass = opt["mainClass"]

    java:add_str("-cp " .. (cp or ""), cp)
        :add_str(mainClass, mainClass)
    sh(java:build())
end
