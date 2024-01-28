local tw = game:GetService'TweenService'
local rs = game:GetService'RunService'
local part:Part = workspace.Exam.Data_in_tween.Boolean.Part

local prop = "CastShadow"
local oriValue = part[prop]
local value = false
local info = TweenInfo.new(1)

local tween = tw:Create(part, info, {
    [prop] = value
})

repeat
    print('CastShadow boolean!')
    for i = 1, 3 do
        part[prop] = value
        task.wait(1)
        part[prop] = oriValue
        task.wait(1)
    end
until rs:IsClient()
-- print(rs:IsClient(), rs:IsServer(), rs:IsStudio())