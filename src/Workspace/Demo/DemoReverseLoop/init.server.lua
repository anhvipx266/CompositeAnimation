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

local tweenModel = workspace.Demo:WaitForChild'TweenReverseLoop'
print("init Demo Tween Speed")
-- demo Tween
local demoTween = Tween.new(
	tweenModel.Part,
	{
		Position = tweenModel.Part.Position,
		Transparency = 0
	},
	{
		Position = tweenModel.Part.Position + Vector3.yAxis * 10,
		Transparency = 1
	}, 1,
	Transition.new(0, 1),{
		{
			Position = tweenModel.Part.Position + Vector3.new(0, 5, 5),
			Transparency = .8
		}
	}
)
print("init demoKeyframeSequence")
local demoKS = KeyframeSequence.new(
	tweenModel.Part, {
		Keyframe.new(0, 'Position', tweenModel.Part.Position),
		Keyframe.new(1, 'Position', tweenModel.Part.Position + Vector3.yAxis * 10),
	},
	{
		Transition.new(0, 1)
	},
	{
		{
			{
				Position = tweenModel.Part.Position + Vector3.new(0, 5, 5)
			},
			{
				Position = tweenModel.Part.Position + Vector3.new(0, -3, 10)
			}
		}
	}
)
local demoKS2 = KeyframeSequence.new(
	tweenModel.Part, {
		Keyframe.new(0, 'Transparency', 0),
		Keyframe.new(1, 'Transparency', .5),
	},
	{
		Transition.new(0, 1)
	}, nil
)
local demoKS3 = KeyframeSequence.new(
	tweenModel.Ball, {
		Keyframe.new(0, 'Color', Color3.fromRGB(255, 0, 0)),
		Keyframe.new(1, 'Color', Color3.fromRGB(0, 255, 0)),
		Keyframe.new(2, 'Color', Color3.fromRGB(0, 0, 255)),
	},
	{
		Transition.new(0, 1),
		Transition.new(0, 1)
	}, nil
)
local demoKS4 = KeyframeSequence.new(
	tweenModel.Ball, {
		Keyframe.new(0, 'Size', Vector3.new(4, 4, 4)),
		Keyframe.new(1, 'Size', Vector3.new(4, 8, 4)),
		Keyframe.new(1.5, 'Size', Vector3.new(8, 2, 4)),
	},
	{
		Transition.new(0, 1),
		Transition.new(0, 1)
	}, nil
)
print("init demo Composite KeyframeSequence")
local demoCKS = CompositeKeyframeSequence.new({
	demoKS,
	demoKS2
})
local demoCKS2 = CompositeKeyframeSequence.new({
	demoKS3,
	demoKS4
})
print("init demo Composite Animation")
local demoAnimation = CompositeAnimation.new({
	demoCKS,
	demoCKS2
})
------------------------------------------------------------
-- demoTween.Looped = true
-- demoTween:Play()
print('>>>>>>>>>>>>>Start Demo Reverse and Loop!')
-----------------------------------------------------
print(demoTween)
print('play')
demoTween.Loop = 4
task.spawn(function()
	demoTween:Play()
end)
task.wait(demoTween.Length * 3)

print('stop')
demoTween:Stop()
demoTween.Loop = 0
---------------------------------------------------
print(demoKS)
demoKS.Loop = 4
print('play')
demoKS:Play()
task.wait(demoKS.Length * 3)
print('completed, isPlaying', demoKS.IsPlaying)
print('stop')
demoKS:Stop()
demoKS.Loop = 0
---------------------------------------------------
print(demoCKS)
demoCKS.Loop = 4
print('play')
demoCKS:Play()

task.wait(demoCKS.Length * 3)
print('stop')
demoCKS:Stop()
demoCKS.Loop = 0
---------------------------------------------------
print(demoCKS2)
demoCKS2.Loop = 4
print('play')
demoCKS2:Play()

task.wait(demoCKS2.Length * 3)
print('stop')
demoCKS2:Stop()
demoCKS2.Loop = 0
---------------------------------------------------
print(demoAnimation)
demoAnimation.Loop = 4
print('play', demoAnimation.Loop)
demoAnimation:Play()

task.wait(demoAnimation.Length * 3)
print('stop')
demoAnimation:Stop()
demoAnimation.Loop = 0
print('>>>>>>>>>>>>>>>>>>>>>>>>>Demo finished!')