local rs = game:GetService'RunService'

local mod = game.ReplicatedStorage:WaitForChild'CompositeAnimation'

local Keyframe = require(mod:WaitForChild('Keyframe'))
local Tween = require(mod:WaitForChild("Tween"))
local KeyframeSequence = require(mod:WaitForChild("KeyframeSequence"))
local Transition = require(mod:WaitForChild("Transition"))
local CompositeKeyframeSequence = require(mod:WaitForChild("CompositeKeyframeSequence"))
local CompositeAnimation = require(mod)

if not rs:IsClient() then
	task.wait(10)
end

local tweenModel = workspace.Demo:WaitForChild'TweenSetProp'

local easyFunctions = {
	Position = function(x) return x end,
	Transparency = function(x) return x end,
	Color = function(x) return x end,
	Size = function(x) return x end,
}
local easyFunction = function(x) return x end

print("init Demo Tween Set Prop")
-- demo Tween
local demoTween = Tween.new(
	tweenModel.Part,
	{
		Position = Vector3.new(),
		Transparency = 0
	},
	{
		Position = Vector3.yAxis * 10,
		Transparency = 1
	}, 1,
	Transition.new(0, 1),{
		{
			Position = Vector3.new(0, 5, 5),
			Transparency = .8
		}
	}, 0, 1, true
)
print("init demoKeyframeSequence")
local demoKS = KeyframeSequence.new(
	tweenModel.Part, {
		Keyframe.new(0, 'Position', Vector3.zero, nil, function(v:Vector3, ori)
			return ori + (if v ~= Vector3.zero then v.Unit * (v.Magnitude ^ 2) else Vector3.zero)
		end),
		Keyframe.new(1, 'Position', Vector3.yAxis * 10, nil, easyFunction),
	},
	{
		Transition.new(0, 1)
	},
	{
		{
			{
				Position = Vector3.new(0, 5, 5)
			},
			{
				Position = Vector3.new(0, -3, 10)
			}
		}
	}, 0, 1, false
)
local demoKS2 = KeyframeSequence.new(
	tweenModel.Part, {
		Keyframe.new(0, 'Transparency', 0, nil, function(v, ori, al)
			local ten = math.floor(al * 10)
			if ten % 2 == 0 then return 0 else return 1 end
		end),
		Keyframe.new(1, 'Transparency', .5, nil, easyFunction),
	},
	{
		Transition.new(0, 1)
	}, nil, 0, 1, false
)
local demoKS3 = KeyframeSequence.new(
	tweenModel.Ball, {
		Keyframe.new(0, 'Color', Color3.fromRGB(255, 0, 0), nil, function(v, ori, al, t)
			return v:Lerp(Color3.new(t * 100, t ^ 2 * 100, t  ^ .5 * 100), al)
		end),
		Keyframe.new(1, 'Color', Color3.fromRGB(0, 255, 0), nil, function(v, ori, al, t, len)
			return v:Lerp(Color3.new(t * 100, t ^ 2 * 100, t  ^ .5 * 100), math.sin(t/len * math.pi/2))
		end),
		Keyframe.new(2, 'Color', Color3.fromRGB(0, 0, 255), nil, easyFunction),
	},
	{
		Transition.new(0, 1),
		Transition.new(0, 1)
	}, nil, 0, 1, false
)
local demoKS4 = KeyframeSequence.new(
	tweenModel.Ball, {
		Keyframe.new(0, 'Size', Vector3.new(4, 4, 4), nil, function(v, ori, al, t, len, rev)
			if rev then
				return v * t
			else
				return v:Lerp(ori, 1 - al)
			end
		end),
		Keyframe.new(1, 'Size', Vector3.new(4, 8, 4), nil, function(v, ori, al, t, len, rev)
			if rev then
				return v * len
			else
				return v
			end
		end),
		Keyframe.new(1.5, 'Size', Vector3.new(8, 2, 4), nil, easyFunction),
	},
	{
		Transition.new(0, 1),
		Transition.new(0, 1)
	}, nil, 0, 1, false
)
local demoKS5 = KeyframeSequence.new(
	tweenModel.Ball, {
		Keyframe.new(0, 'Position', Vector3.xAxis * (-5), nil, function(v:Vector3, ori)
			return tweenModel.Part.Position + v
		end),
		Keyframe.new(1, 'Position', Vector3.xAxis * 5, nil, easyFunction),
	},
	{
		Transition.new(0, 1)
	}, nil, 0, 1, false
)
print("init demo Composite KeyframeSequence")
local demoCKS = CompositeKeyframeSequence.new({
	demoKS,
	demoKS2
}, 0, 1, false)
local demoCKS2 = CompositeKeyframeSequence.new({
	demoKS3,
	demoKS4,
	demoKS5
}, 0, 1, false)
print("init demo Composite Animation")
local demoAnimation = CompositeAnimation.new({
	demoCKS,
	demoCKS2
}, 0, 1, true)
------------------------------------------------------------
-- demoTween.Looped = true
-- demoTween:Play()
print('>>>>>>>>>>>>>Start Demo Reverse and Loop!')
-----------------------------------------------------
print(demoTween)
print('play')
demoTween.Loop = 2
task.spawn(function()
	demoTween:Play()
end)
task.wait(demoTween.Length * 6)

print('stop')
-- demoTween:Stop()
demoTween.Loop = 0
---------------------------------------------------
-- print(demoKS)
-- demoKS.Loop = 2
-- print('play')
-- demoKS:Play()
-- task.wait(demoKS.Length * 6)
-- print('completed, isPlaying', demoKS.IsPlaying)
-- print('stop')
-- -- demoKS:Stop()
-- demoKS.Loop = 0
---------------------------------------------------
-- print(demoCKS)
-- demoCKS.Loop = 2
-- print('play')
-- demoCKS:Play()

-- task.wait(demoCKS.Length * 6)
-- print('stop')
-- -- demoCKS:Stop()
-- demoCKS.Loop = 0
---------------------------------------------------
-- print(demoCKS2)
-- demoCKS2.Loop = 2
-- print('play')
-- demoCKS2:Play()

-- task.wait(demoCKS2.Length * 6)
-- print('stop')
-- -- demoCKS2:Stop()
-- demoCKS2.Loop = 0
---------------------------------------------------
print(demoAnimation)
demoAnimation.Loop = 2
print('play', demoAnimation.Loop)
demoAnimation:Play()

task.wait(demoAnimation.Length * 6)
print('stop')
-- demoAnimation:Stop()
demoAnimation.Loop = 0
print('>>>>>>>>>>>>>>>>>>>>>>>>>Demo finished!')