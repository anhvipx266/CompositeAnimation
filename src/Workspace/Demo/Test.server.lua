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

local tweenModel = workspace.Demo:WaitForChild'Model'
local easyFunctions = {
	Position = function(x) return x end,
	Transparency = function(x) return x end,
	Color = function(x) return x end,
	Size = function(x) return x end,
}
print("init Test")
-- demo Tween
print('-------------------------test Tween-------------------------')
local demoTween = Tween.fromSimple(tweenModel.Part, {
	Position = Vector3.zero
}, {
	Position = Vector3.yAxis * 10
}, 0, 1, Transition.new(0, 1))

demoTween:Play()
task.wait(1)
demoTween:Cancel()
task.wait(1)
print('-------------------------test KeyframeSequence-------------------------')
local ks = KeyframeSequence.new(tweenModel.Part, {
    Keyframe.new(0, {
        Position = Vector3.zero
    }),
    Keyframe.new(1, {
        Position = Vector3.yAxis * 10
    })
}, {
    Transition.new(0, 1)
})
local ks2 = KeyframeSequence.new(tweenModel.Part, {
    Keyframe.new(0, {
        Size = Vector3.zero
    }),
    Keyframe.new(2, {
        Size = Vector3.one * 5
    })
}, {
    Transition.new(0, 1)
})
local ks3 = KeyframeSequence.new(tweenModel.Ball, {
    Keyframe.new(0, {
        Color = Color3.fromRGB(255, 255)
    }),
    Keyframe.new(3, {
        Color = Color3.fromRGB(0, 255, 255)
    })
}, {
    Transition.new(0, 1)
})

ks:Play()
task.wait(ks.Length * 2)
ks:Cancel()
task.wait(1)
print('-------------------------test CompositeKeyframeSequence-------------------------')
local cks = CompositeKeyframeSequence.new({
    ks, ks2
})
local cks2 = CompositeKeyframeSequence.new({
    ks3
})

-- cks:Play()
-- task.wait(cks.Length * 2)
-- cks:Cancel()
-- task.wait(1)
print('-------------------------test CompositeAnimation-------------------------')
local ca = CompositeAnimation.new({
    cks, cks2
})

ca:Play()
task.wait(ca.Length * 2)
ca:Cancel()
task.wait(1)

print('>>>>>>>>>>>>>>>>>>>>>>>>>Test finished!')