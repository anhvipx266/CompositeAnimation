local tw = game:GetService'TweenService'
local rs = game:GetService'RunService'
local part:Part = workspace.Exam.Data_in_tween.Lerb.Part

local prop = "Position"
local oriValue = part[prop]
local value = oriValue + Vector3.new(0, 4, 0)
local info = TweenInfo.new(1)

local tween = tw:Create(part, info, {
    [prop] = value
})

repeat
    
    for i = 1, 3 do
        tween:Play()
        tween.Completed:Wait()
        part[prop] = oriValue
        task.wait(1)
    end
until rs:IsClient()
-- print(rs:IsClient(), rs:IsServer(), rs:IsStudio())