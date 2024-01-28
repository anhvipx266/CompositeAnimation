local Signal = require(script.Parent.Signal)

export type Keyframe = {
	TimePosition:number, -- điểm thời gian của Keyframe, >= 0
	Prop:string,
	Value:any,

	Reached:Signal.Signal -- Signal
}

local Keyframe = {}
Keyframe.__index = Keyframe
Keyframe.ClassName = "Keyframe"
Keyframe.__tostring = function(self)
    return `{string.rep('-', 35)} {self.ClassName} {string.rep('-', 35)}`
end
--/default props
Keyframe.Props = {}
Keyframe.TimePosition = 0

function Keyframe.new(time_position:number, prop:string, value, maker)
	local self = setmetatable({}, Keyframe)
	assert(time_position >= 0, "TimePosition must be greater or equal 0!")
	
	self.TimePosition = time_position
	self.Prop = prop
	self.Value = value

	if maker then self.Reached = Signal.new() end
	
	return self
end

return Keyframe