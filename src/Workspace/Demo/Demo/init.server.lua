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

local tweenModel = workspace.Demo:WaitForChild'TweenModel'
print("init Demo Tween")
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
local demoKeyframeSequence = KeyframeSequence.new(
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
local demoKeyframeSequence2 = KeyframeSequence.new(
    tweenModel.Part, {
        Keyframe.new(0, 'Transparency', 0),
        Keyframe.new(3, 'Transparency', .5),
    },
    {
        Transition.new(0, 1)
    }
)
local demoKeyframeSequence3 = KeyframeSequence.new(
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
local demoKeyframeSequence4 = KeyframeSequence.new(
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
    demoKeyframeSequence,
    demoKeyframeSequence2
})
local demoCKS2 = CompositeKeyframeSequence.new({
    demoKeyframeSequence3,
    demoKeyframeSequence4
})
print("init demo Composite Animation")
local demoAnimation = CompositeAnimation.new({
    demoCKS,
    demoCKS2
})
------------------------------------------------------------
print(demoTween)
for i = 1, 3 do
    print('play')
    task.spawn(function()
        demoTween:Play()
    end)
    task.wait(3)
    print('pause')
    demoTween:Pause()
    task.wait(3)
    print('continue')
    task.spawn(function()
        demoTween:Continue()
    end)
    task.wait(3)
    print('cancel')
    demoTween:Cancel()
end
--------------------------------------------------------------
-- demoKeyframeSequence.Looped = true
-- print('play')
-- demoKeyframeSequence:Play()
---------------------------------------------------
print(demoKeyframeSequence)
for i = 1, 3 do
    print('play')
    demoKeyframeSequence:Play()

    task.wait(demoKeyframeSequence.Length / 2)
    demoKeyframeSequence:Pause()
    print('pause!')
    task.wait(3)
    print('continue')
    demoKeyframeSequence:Continue()

    demoKeyframeSequence.Completed:Wait()
    print('completed, isPlaying', demoKeyframeSequence.IsPlaying)
    print('cancel')
    demoKeyframeSequence:Cancel()
end
---------------------------------------------------
print(demoCKS)
for i = 1, 3 do
    print('play')
    demoCKS:Play()

    task.wait(demoCKS.Length / 2)
    demoCKS:Pause()
    print('pause!')
    task.wait(3)
    print('continue')
    demoCKS:Continue()

    demoCKS.Completed:Wait()
    print('cancel')
    demoCKS:Cancel()
end
---------------------------------------------------
print(demoCKS2)
for i = 1, 3 do
    print('play')
    demoCKS2:Play()

    task.wait(demoCKS2.Length / 2)
    demoCKS2:Pause()
    print('pause!')
    task.wait(1.5)
    print('continue')
    demoCKS2:Continue()

    demoCKS2.Completed:Wait()
    print('cancel')
    demoCKS2:Cancel()
end
---------------------------------------------------
print(demoAnimation)
for i = 1, 3 do
    print('play')
    demoAnimation:Play()

    task.wait(demoAnimation.Length / 2)
    demoAnimation:Pause()
    print('pause!')
    task.wait(3)
    print('continue')
    demoAnimation:Continue()

    demoAnimation.Completed:Wait()
    print('cancel')
    demoAnimation:Cancel()
end
print('>>>>>>>>>>>>>>>>>>>>>>>>>Demo finished!')