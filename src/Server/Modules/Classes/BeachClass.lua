-- Beach Class
-- MrAsync
-- February 13, 2020



local BeachClass = {}
BeachClass.__index = BeachClass

--//Services
local MetaDataService

--//Controllers

--//Classes
local SandClass

--//Data

--//Locals


--//Constructor
function BeachClass.new(beachId, beachContainer)
    local self = setmetatable({
        Id = beachId;
        Container = beachContainer;
        SpawnPad = beachContainer:FindFirstChild("SpawnPad");

        MetaData = MetaDataService:GetMetaData(beachId);

        SandMap = {};
    }, BeachClass)

    return self
end

--//Generates the initial layer of sand for the beach
function BeachClass:Setup()
    local layerMap = {}

    --Calculate sizes, cframes and rows / columns
    local sandSize = Vector3.new(3, 3, 3)

    local padSize = self.SpawnPad.Size
    local padCFrame = self.SpawnPad.CFrame

    local totalRows = (padSize.Z - (sandSize.Z * 0.5)) / 3
    local totalCols = (padSize.X - (sandSize.X * 0.5)) / 3

    --Calculate startingPosition
    local startingPosition = padCFrame - (padSize * 0.5) + (sandSize * 0.5)

    --Iterate through all rows and cols
    for row = 0, totalRows do
        local columnMap = {}

        for col = 0, totalCols do
            --Construct position
            local position = startingPosition + Vector3.new(col * 3, 0 , row * 3)

            --Construct a new SandObject and add it to array
            columnMap[#columnMap + 1] = SandClass.new(self.MetaData.Sand[1], position, Vector2.new(#layerMap + 1, #columnMap + 1))
        end

        layerMap[#layerMap + 1] = columnMap;
    end
    --
    self.SandMap[1] = layerMap;
end


function BeachClass:Start()

end


function BeachClass:Init()
    --//Services
    MetaDataService = self.Services.MetaDataService
    
    --//Controllers
    
    --//Classes
    SandClass = self.Modules.Classes.SandClass
    
    --//Data
    
    --//Locals
    
end


return BeachClass