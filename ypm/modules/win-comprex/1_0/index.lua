---@diagnostic disable: undefined-global
local compress = function(opt)
    exec({
        debug = opt["debug"] or false,
        redirect = opt["redirect"] or false,
    }, cmdf("Compress-Archive", "-Path", opt["src"], "-DestinationPath", opt["dst"]))
end

local uncompress = function(opt)
    exec({
        debug = opt["debug"] or false,
        redirect = opt["redirect"] or false,
    }, cmdf("Expand-Archive", "-Path", opt["src"], "-DestinationPath", opt["dst"]))
end

return {
    compress = compress,
    uncompress = uncompress
}
