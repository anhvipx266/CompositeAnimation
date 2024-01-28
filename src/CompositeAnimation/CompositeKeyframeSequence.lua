local KeyframeSequence = require(script.Parent.KeyframeSequence)
local Signal = require(script.Parent.Signal)

export type CompositeKeyframeSequence = {
    _KS:{KeyframeSequence.KeyframeSequence}
}

local _prototype = {}
_prototype.__index = _prototype
_prototype.__tostring = function(self)
    return `{string.rep('-', 35)} {self.ClassName} {string.rep('-', 35)}`
end
_prototype.ClassName = 'CompositeKeyframeSequence'
_prototype.Looped = false
_prototype.Speed = 1

function _prototype.new(keyframesequences, looped, speed)
    local self = setmetatable({}, _prototype)

    self._KS = keyframesequences
    self._KS = self._KS
    self.Looped = looped
    self.Speed = speed
    -- tính toán độ dài
    self.Length = 0
    for _, ks in self._KS do
        self.Length = math.max(self.Length, ks.Length)
    end

    self.ReachedEnd = Signal.new()
    self.Completed = Signal.new()

    return self
end

function _prototype:Play(speed)
    self._Speed = speed or self.Speed
    if self.IsPlaying then return end
    self.IsPlaying = true
    self._Completed = {}
    for i, ks in self._KS do
        ks:Play(self._Speed * ks.Speed)
        local cn
        cn = ks.Completed:Once(function()
            self._Completed[i] = cn
            if #self._Completed == #self._KS then
                self.IsPlaying = false
                self.ReachedEnd:Fire()
                if self.Looped then
                    self:Play(self._Speed * ks.Speed)
                else
                    self.Completed:Fire()
                end
            end
        end)
    end
end

function _prototype:Pause()
    self.IsPlaying = false
    for _, ks in self._KS do
        ks:Pause()
    end
end

function _prototype:Continue(speed)
    self._Speed = speed or self.Speed
    self.IsPlaying = true
    for _, ks in self._KS do
        ks:Continue(self._Speed * ks.Speed)
    end
end

function _prototype:Cancel()
    for _, ks in self._KS do
        ks:Cancel()
    end
end

function _prototype:Stop()
    for i, ks in self._KS do
        ks:Stop()
        if self._Completed[i] then self._Completed[i]:Disconnect() end
    end
end

local CompositeKeyframeSequence = _prototype
return CompositeKeyframeSequence