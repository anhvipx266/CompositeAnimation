local Keyframe = require(script.Parent.Keyframe)
local Transition = require(script.Parent.Transition)

export type Tween = {
    StartKeyframe:Keyframe.Keyframe,
    EndKeyframe:Keyframe.Keyframe,
    Start:any,
    End:any,
    Transition:Transition.Transition,
    Middles:{any}
}

local Tween:Tween = {}
Tween.__index = Tween
Tween.__tostring = function(self)
    return `{string.rep('-', 35)} {self.ClassName} {string.rep('-', 35)}`
end
Tween.ClassName = 'Tween'
Tween.IsPlaying = false
Tween.Looped = false
Tween.Speed = 1

local ANIMATION_SMOOTHNESS = 0.03

function Tween.new(obj, start_props, end_props, length, transition, middles_props, looped, speed)
    local self = setmetatable({}, Tween)

    self.Object = obj
    self.Start = start_props
    self.End = end_props
    self.Length = length
    self.Transition = transition
    self.Middles = middles_props or {}
    self.Looped = looped
    self.Speed = speed

    self.Points = {}
    self.Points[1] = self.Start
    for _, props in self.Middles do
        table.insert(self.Points, props)
    end
    table.insert(self.Points, self.End)

    self.Transition:InitLerp(self.Start)

    return self
end
-- lấy thông tin giá trị theo thời gian
function Tween:GetProps(t:number)
    local alpha = self.Transition:GetAlpha(t / self.Length)
    if alpha == 0 then return self.Start end
    if alpha == 1 then return self.End end
    -- nội suy chuỗi điểm
    local points = self.Points
    repeat
        local currentPoints = {}

        for i = 1, #points - 1 do
            currentPoints[i] = {}
            for k, v in points[i] do
                local v2 = points[i + 1][k]
                currentPoints[i][k] = self.Transition.Lerp[k](v, v2, alpha)
            end
        end

        points = currentPoints
    until #points == 1
    return points[1]
end

function Tween:SetProps(props)
    for k, v in props do
        self.Object[k] = v
    end
end
-- phát sự nới lỏng
function Tween:Play(speed)
    if self.IsPlaying then return end
    self._t = 0
    self:Continue(speed)
end
-- tạm dừng
function Tween:Pause()
    self.IsPlaying = false
    self.Paused = true
end
function Tween:Continue(speed)
    self._Speed = speed or self.Speed
    self._s = tick() - (self._t)
    self.IsPlaying = true
    self.Paused = false
    repeat
        while self.IsPlaying do
            task.wait(ANIMATION_SMOOTHNESS)
            self._t = (tick() - self._s) * self._Speed
            if self._t > self.Length then break end
            local props = self:GetProps(self._t)
            self:SetProps(props)
        end
        if self.Looped then
            self._s = tick()
            self:Cancel()
        end
    until not self.Looped
    self.IsPlaying = false
end
-- kết thúc
function Tween:Stop()
    self:Pause()
    self:Cancel()
end
-- đưa dữ liệu về ban đầu
function Tween:Cancel()
    for k, v in self.Start do
        self.Object[k] = v
    end
end

return Tween