local KeyframeSequence = require(script.Parent.KeyframeSequence)
local Signal = require(script.Parent.Signal)

export type CompositeKeyframeSequence = {
    _KS:{KeyframeSequence.KeyframeSequence}
}

local _prototype = {}
_prototype.__index = _prototype
_prototype.ClassName = 'CompositeKeyframeSequence'

function _prototype.new(keyframesequences)
    local self = setmetatable({}, _prototype)

    self._KS = keyframesequences
    self._KS = self._KS
    -- tính toán độ dài
    self.Length = 0
    for _, ks in self._KS do
        self.Length = math.max(self.Length, ks.Length)
    end

    self.ReachedEnd = Signal.new()
    self.Completed = Signal.new()

    return self
end

function _prototype:Play()
    if self.IsPlaying then return end
    self.IsPlaying = true
    self._Completed = {}
    for i, ks in self._KS do
        ks:Play()
        local cn
        cn = ks.Completed:Once(function()
            self._Completed[i] = cn
            if #self._Completed == #self._KS then
                self.IsPlaying = false
                self.ReachedEnd:Fire()
                if self.Looped then
                    self:Play()
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

function _prototype:Continue()
    self.IsPlaying = true
    for _, ks in self._KS do
        ks:Continue()
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