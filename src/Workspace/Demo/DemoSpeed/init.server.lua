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

local tweenModel = workspace.Demo:WaitForChild'TweenSpeed'
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
	}, 5,
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
		Keyframe.new(5, 'Position', tweenModel.Part.Position + Vector3.yAxis * 10),
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
		Keyframe.new(3, 'Transparency', .5),
	},
	{
		Transition.new(0, 1)
	}
)
local demoKS3 = KeyframeSequence.new(
	tweenModel.Ball, {
		Keyframe.new(0, 'Color', Color3.fromRGB(255, 0, 0)),
		Keyframe.new(3, 'Color', Color3.fromRGB(0, 255, 0)),
		Keyframe.new(6, 'Color', Color3.fromRGB(0, 0, 255)),
	},
	{
		Transition.new(0, 1),
		Transition.new(0, 1)
	}
)
local demoKS4 = KeyframeSequence.new(
	tweenModel.Ball, {
		Keyframe.new(0, 'Size', Vector3.new(4, 4, 4)),
		Keyframe.new(3, 'Size', Vector3.new(4, 8, 4)),
		Keyframe.new(4, 'Size', Vector3.new(8, 2, 4)),
	},
	{
		Transition.new(0, 1),
		Transition.new(0, 1)
	}
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
-----------------------------
print('------------------Tween---------------')
for i = 1, 3 do
    print('play')
    -- task.spawn(function()
        demoTween:Play(i ^ 1.2)
    -- end)
    -- task.wait(3)
    -- print('pause')
    -- demoTween:Pause()
    -- task.wait(3)
    -- print('continue')
    -- task.spawn(function()
    --     demoTween:Continue()
    -- end)
    task.wait(3)
    print('cancel')
    demoTween:Cancel()
end
--------------------------------------------------------------
-- demoKeyframeSequence.Looped = true
-- print('play')
-- demoKeyframeSequence:Play()
---------------------------------------------------
print('------------------KeyframeSequence---------------')
for i = 1, 3 do
    print('play')
    demoKS:Play(i ^ 1.2)

    -- task.wait(demoKS.Length / 2)
    -- demoKS:Pause()
    -- print('pause!')
    -- task.wait(3)
    -- print('continue')
    -- demoKS:Continue()

    demoKS.Completed:Wait()
    print('completed, isPlaying', demoKS.IsPlaying)
    print('cancel')
    demoKS:Cancel()
end
---------------------------------------------------
print('------------------CompositeKeyframeSequence---------------')
for i = 1, 3 do
    print('play')
    demoCKS:Play(i ^ 1.3)

    -- task.wait(demoCKS.Length / 2)
    -- demoCKS:Pause()
    -- print('pause!')
    -- task.wait(3)
    -- print('continue')
    -- demoCKS:Continue()

    demoCKS.Completed:Wait()
    print('cancel')
    demoCKS:Cancel()
end
---------------------------------------------------
print('------------------CompositeKeyframeSequence---------------')
for i = 1, 3 do
    print('play')
    demoCKS2:Play(i ^ 1.3)

    -- task.wait(demoCKS2.Length / 2)
    -- demoCKS2:Pause()
    -- print('pause!')
    -- task.wait(1.5)
    -- print('continue')
    -- demoCKS2:Continue()

    demoCKS2.Completed:Wait()
    print('cancel')
    demoCKS2:Cancel()
end
---------------------------------------------------
print('------------------CompositeAnimation---------------')
for i = 1, 3 do
    print('play')
    demoAnimation:Play(i ^ 1.3)

    -- task.wait(demoAnimation.Length / 2)
    -- demoAnimation:Pause()
    -- print('pause!')
    -- task.wait(3)
    -- print('continue')
    -- demoAnimation:Continue()

    demoAnimation.Completed:Wait()
    print('cancel')
    demoAnimation:Cancel()
end
print('>>>>>>>>>>>>>>>>>>>>>>>>>Demo finished!')