-- Sand Class
-- MrAsync
-- February 14, 2020



local SandClass = {}
SandClass.__index = SandClass


function SandClass.new()
    local self = setmetatable({

    }, SandClass)

    return self
end


return SandClass