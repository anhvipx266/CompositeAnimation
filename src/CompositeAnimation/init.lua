local CompositeKeyframeSequence = require(script.CompositeKeyframeSequence)
local Signal = require(script.Signal)

export type CompositeAnimation = {
    CompositeKeyframeSequences:{CompositeKeyframeSequence.CompositeKeyframeSequence},

	Looped:boolean,
	Speed:number
}

local _prototype = {}
_prototype.__index = _prototype
_prototype.ClassName = 'CompositeAnimation'
_prototype.Speed = 1
_prototype.Looped = false

function _prototype.new(composite_keyframe_sequences)
    local self = setmetatable({}, _prototype)

    self.CompositeKeyframeSequences = composite_keyframe_sequences
    self._CKS = self.CompositeKeyframeSequences
    -- tính toán độ dài
    self.Length = 0
    for _, cks in self._CKS do
        self.Length = math.max(self.Length, cks.Length)
    end

    self.ReachedEnd = Signal.new()
    self.Completed = Signal.new()

    return self
end

function _prototype:Play()
    if self.IsPlaying then return end
    self.IsPlaying = true
    self._Completed = {}
    for i, cks in self._CKS do
        cks:Play()
        local cn
        cn = cks.Completed:Once(function()
            self._Completed[i] = cn
            if #self._Completed == #self._CKS then
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
    for _, cks in self._CKS do
        cks:Pause()
    end
end

function _prototype:Continue()
    self.IsPlaying = true
    for _, cks in self._CKS do
        cks:Continue()
    end
end

function _prototype:Cancel()
    for _, cks in self._CKS do
        cks:Cancel()
    end
end

function _prototype:Stop()
    for i, keyframeSequence in self._CKS do
        keyframeSequence:Stop()
        if self._Completed[i] then self._Completed[i]:Disconnect() end
    end
end

return _prototype