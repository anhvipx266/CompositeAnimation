--[[
    -- thiết kế lại theo https://devforum.roblox.com/t/cframe-animator-curves-easing-and-more/2796390
    https://create.roblox.com/store/asset/16009163899/CFrame-Animator-10%3Fkeyword=&pageNumber=&pagePosition=
]]
local movementModule = {}

movementModule.__index = movementModule

local RS = game:GetService("RunService")

local keyframeModule = require(script.Keyframe)

local ANIMATION_SMOOTHNESS = 0.03

function movementModule.new(character: BasePart, keyframes, onFinished)
	local self = setmetatable({}, movementModule)
	
	assert(typeof(character) == "Instance" and character:IsA("BasePart"), "Argument one must be a BasePart.")
	assert(typeof(keyframes) == "table", "Argument two must be a table.")
	assert(typeof(onFinished) == "function" or typeof(onFinished) == "nil", "Optional argument three must be a function.")
	
	assert(#keyframes >= 1, "Must provide a least one keyframe.")
	
	self.IsPlaying = false
	self.IsPaused = false
	self.KeyframesWereInitialized = false
	
	self.Character = character
	self.OriginCFrame = self.Character:GetPivot()
	self.Keyframes = keyframes
	self.OnFinished = onFinished
	
	self.CurrentIncrement = 0
	self.CurrentKeyframe = nil
	self.CurrentAnimationThread = nil
	
	self.InternalOnFinished = function()
		self.IsPlaying = false
		
		if self.OnFinished then
			self:OnFinished()
		end
	end
	
	self:InitializeKeyFrames()
	
	return self
end

function movementModule:InitializeKeyFrames()
	local newKeyframes = {}
	
	for _, keyframeParams in self.Keyframes do
		table.insert(newKeyframes, {
			Keyframe = keyframeModule.new(
				keyframeParams[1], keyframeParams[2], -- start and end cframes
				keyframeParams[3], keyframeParams[4], -- start and end times
				keyframeParams[5], -- time func
				keyframeParams[6], -- mid points
                keyframeParams[8],
                keyframeParams[9],
                keyframeParams[10]
            ),
			Length = keyframeParams[7],
		})
	end
	
	self.Keyframes = newKeyframes
	self.KeyframesWereInitialized = true
end

function movementModule:Move(cframe)
	if not self.IsPlaying then return print("Could not move: animation isn't playing!") end
	
	self.OffsetCFrame = cframe
end

function movementModule:Play()
	if not self.KeyframesWereInitialized then return print("Could not play: did not initialize keyframes!") end
	if self.IsPlaying then return print("Could not play: animation is already playing!") end
	
	self.CurrentAnimationThread = coroutine.create(function()
		self.OriginCFrame = self.Character:GetPivot()
		
		self.IsPlaying = true
		self.IsPaused = false
		
		for _, keyframe in self.Keyframes do
			self.CurrentKeyframe = keyframe
			self.CurrentIncrement = 0
			
			while self.CurrentIncrement < keyframe.Length do
				self.CurrentIncrement += task.wait(ANIMATION_SMOOTHNESS)
				
				if not self.IsPlaying then return end
				if self.IsPaused then coroutine.yield() end
				local cf, prop = keyframe.Keyframe:GetCFrame(self.CurrentIncrement / keyframe.Length)
				self.Character:PivotTo(self.OriginCFrame * cf)
                self.Character[keyframe.Keyframe.Prop] = prop
			end
		end
		
		self:InternalOnFinished()
	end)
	
	coroutine.resume(self.CurrentAnimationThread)
end

function movementModule:Stop() -- stops and restarts
	if not self.IsPlaying then return print("Could not stop: animation isn't playing!") end
	
	self.IsPlaying = false

	self.CurrentIncrement = 0
	self.CurrentKeyframe = nil
	self.CurrentAnimationThread = nil
end

function movementModule:Pause() -- pauses animation
	if not self.IsPlaying then return print("Could not pause: animation isn't playing!") end
	
	self.IsPaused = true
end

function movementModule:Resume() -- resumes animation
	if not self.IsPaused then return print("Could not resume: animation is not paused!") end
	
	self.IsPaused = false
end

function movementModule:Destroy() -- extra named function, for organization in case you want to destroy this like it was an instance.
	self:Stop()
end

return movementModule