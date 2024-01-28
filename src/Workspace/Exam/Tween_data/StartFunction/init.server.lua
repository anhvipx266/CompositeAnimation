local tw = game:GetService'TweenService'
local rs = game:GetService'RunService'
local part:Part = workspace.Exam.Data_in_tween.Function.Part

local prop = "Position"
local oriValue = part[prop]
local s = tick()
local propFunc = function()
    local t = tick() - s
    return oriValue + Vector3.new(0, 4 * math.sin(t * 2 * math.pi) ,0)
end

repeat
    for i = 1, 3 do
        part[prop] = oriValue
        s = tick()
        while tick() - s < 6 do
            task.wait()
            part[prop] = propFunc()
        end
        task.wait(3)
    end
until rs:IsClient()