local keyframe = {}

keyframe.__index = keyframe

function keyframe.new(startCFrame, endCFrame, timeStart, timeEnd, timeFunc, midCFrames, prop, startProp, endProp)
	local self = setmetatable({}, keyframe)
	
	assert(timeEnd > timeStart, "timeEnd must be greater than timeStart.")
	
	self.Start = startCFrame
	self.End = endCFrame
	self.TimeFunction = timeFunc
	self.TimeStart = timeStart
	self.TimeEnd = timeEnd
    self.Prop = prop
    self.StartProp = startProp
    self.EndProp = endProp
	
	self.Middle = midCFrames or { self.Start:Lerp(self.End, 0.5) }
	
	return self
end

function keyframe:GetCFrame(alpha)
	local realAlpha = (self.TimeFunction(
			self.TimeStart + ((self.TimeEnd - self.TimeStart) * alpha)
		) - self.TimeFunction(self.TimeStart)
	) / (self.TimeFunction(self.TimeEnd) - self.TimeFunction(self.TimeStart))
	
	if realAlpha == 0 then
		return self.Start, self.StartProp
	elseif realAlpha == 1 then
		return self.End, self.EndProp
	else
		local points = { self.Start }
        local props = { self.StartProp }
		-- tổng hợp chuỗi điểm
		for _, middlePoint in self.Middle do
			table.insert(points, middlePoint)
            -- table.insert(props, )
		end
		
		table.insert(points, self.End)
        table.insert(props, self.EndProp)
		
		repeat
			local newPoints = {}
			
			for i = 1, #points - 1 do
				table.insert(newPoints, points[i]:Lerp(points[i + 1], realAlpha))
			end

			points = newPoints
		until #points == 1

        repeat
            local newProps = {}

            for i = 1, #props - 1 do
				table.insert(newProps, props[i] + (props[i + 1] - props[i]) * realAlpha)
			end
			
            props = newProps
		until #props == 1
		
		return points[1], props[1]
	end
end

return keyframe