local Keyframe = require(script.Parent.Keyframe)
local Transition = require(script.Parent.Transition)
local Tween = require(script.Parent.Tween)
local Signal = require(script.Parent.Signal)

export type KeyframeSequence = {
    Object:Instance,
    Keyframes:{Keyframe.Keyframe},
    Transitions:{Transition.Transition}
}

local _prototype = {}
_prototype.__index = _prototype
_prototype.__tostring = function(self)
    return `{string.rep('-', 35)} {self.ClassName} {string.rep('-', 35)}`
end
_prototype.ClassName = 'KeyframeSequence'
_prototype.Looped = false
_prototype.Speed = 1

function _prototype.new(obj:Instance, keyframes, transitions, middles, looped, speed)
    local self = setmetatable({}, _prototype)

    assert(#keyframes - #transitions == 1, "Keyframes Length must be greater 1 than Transitions Length!")

    self.Object = obj
    self.Keyframes = keyframes
    self.Transitions = transitions
    self.Middles = middles or {}
    self.Tweens = {}
    self.Length = self.Keyframes[#self.Keyframes].TimePosition
    self.Looped = looped
    self.Speed = speed

    self.Completed = Signal.new()
    self.ReachedEnd = Signal.new()
    -- khởi tạo các Tween tương ứng
    for i = 1, #self.Transitions do
        local startKeyframe = self.Keyframes[i]
        local endKeyframe = self.Keyframes[i + 1]
        self.Tweens[i] = Tween.new(obj, {
            [startKeyframe.Prop] = startKeyframe.Value
        }, {
            [endKeyframe.Prop] = endKeyframe.Value
        }, endKeyframe.TimePosition - startKeyframe.TimePosition, self.Transitions[i], self.Middles[i])
    end
    
    return self
end

function _prototype:Play(speed)
    if self.IsPlaying then return end
    -- đặt lại giá trị về ban đầu
    self.Current = self.Tweens[1]
    self._idx = 1
    self:Continue(speed)
end

function _prototype:Pause()
    self.IsPlaying = false
    if self.PlayThread then
        local status = coroutine.status(self.PlayThread)
        if status ~= 'dead' and status ~= 'normal' then
            coroutine.close(self.PlayThread)
            self.Current:Pause()
        end
    end
end

function _prototype:Continue(speed)
    self._Speed = speed or self.Speed
    self.IsPlaying = true
    -- tạo mới luồng Play mới và đóng cũ nếu có
    if self.PlayThread then
        local status = coroutine.status(self.PlayThread)
        if status ~= 'dead' and status ~= 'normal' then
            coroutine.close(self.PlayThread)
        end
    end
    self.PlayThread = coroutine.create(function()
        repeat
            for i = self._idx, #self.Tweens do
                self._idx = i
                self.Current = self.Tweens[i]
                if self.Current.Paused then
                    self.Current:Continue(self._Speed * self.Current.Speed)
                else
                    self.Current:Play(self._Speed * self.Current.Speed)
                end
            end
            self.ReachedEnd:Fire()
        until not self.Looped
        self.IsPlaying = false
        self.Completed:Fire()
    end)
    task.spawn(self.PlayThread)
end

function _prototype:Stop()
    self:Pause()
    self:Cancel()
end

function _prototype:Cancel()
    self.Current:Pause()
    self.Current.Paused = false
    self.Current = self.Tweens[1]
    self._idx = 1
    self.Current:Cancel()
end

return _prototype