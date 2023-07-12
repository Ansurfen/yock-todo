return function(pattern, text)
    local reg = regexp.MustCompile(pattern)
    local res = reg:FindStringSubmatch(text)
    if res ~= nil and #res > 1 then
        return res[2]
    end
    return ""
end
