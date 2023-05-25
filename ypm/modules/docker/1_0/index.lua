---@diagnostic disable: undefined-global
local docker = {}

local docker_builder = function(...)
    return argBuilder:new():add("docker")
end

function docker:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function docker:pull(image)
    return docker_builder():add("pull"):add_str(image, image)
end

function docker:run(opt)
    return docker_builder():add("run"):add_str("-p " .. (opt["port"] or ""), opt["port"]):add_bool("-d", opt["d"])
    :add_str(
        "-v " .. (opt["voulme"] or ""), opt["voulme"]):add_str("--name=" .. (opt["name"] or ""), opt["name"]):add_str(
        opt["image"],
        opt["image"])
end

return docker
