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
Tween.Loop = 0
Tween.Speed = 1
Tween.Reverse = false

local ANIMATION_SMOOTHNESS = 0.03

function Tween.new(obj, start_props, end_props, length, transition, middles_props, loop, speed, reverse)
    local self = setmetatable({}, Tween)

    self.Object = obj
    self.Start = start_props
    self.End = end_props
    self.Length = length
    self.Transition = transition
    self.Middles = middles_props or {}
    self.Loop = loop
    self.Speed = speed
    self.Reverse = reverse

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
function Tween:GetProps(t:number, reverse:boolean)
    local alpha = self.Transition:GetAlpha(t / self.Length)
    -- nội suy chuỗi điểm
    local points = self.Points
    -- nghịch đảo chuỗi điểm nếu cần
    if reverse then
        points = {}
        local len = #self.Points
        for i = 1, len do
            points[len - i + 1] = self.Points[i]
        end
    end
    if alpha == 0 then return points[1] end
    if alpha == 1 then return points[#self.Points] end
    
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
function Tween:Play(speed, reverse)
    if self.IsPlaying then return end
    self._t = 0
    -- số vòng còn lại, dừng khi số vòng chạm -1, hoặc vô hạn khi nhỏ hơn -1
    self._loop = self.Loop
    self:Continue(speed, reverse)
end
-- tạm dừng
function Tween:Pause()
    self.IsPlaying = false
    self.Paused = true
end

function Tween:GoForward()
    local props
    if self.Reverse then
        if self._t > self.Length * 2 then return true end
        if self._t <= self.Length then
            props = self:GetProps(self._t)
        else
            props = self:GetProps(self._t - self.Length, self.Reverse)
        end
    else
        if self._t > self.Length then return true end
        props = self:GetProps(self._t)
    end
    self:SetProps(props)
end
-- chỉ có chiều nghịch và time > Length
function Tween:GoReverse()
    local props
    if self._t > self.Length * 2 then return true end
    props = self:GetProps(self._t - self.Length, true)
    self:SetProps(props)
end

function Tween:Continue(speed, reverse)
    self._Speed = speed or self.Speed
    self._s = tick() - (self._t)
    self.IsPlaying = true
    self.Paused = false
    repeat
        while self.IsPlaying do
            task.wait(ANIMATION_SMOOTHNESS)
            self._t = (tick() - self._s) * self._Speed
            if reverse and self._t > self.Length then
                if self:GoReverse() then break end
            else
                if self:GoForward() then break end
            end
        end
        self._loop -= 1
        if self._loop ~= -1 then
            self._s = tick()
            self:Cancel()
        end
    until self._loop == -1 or (not self.IsPlaying)
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