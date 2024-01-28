local ui = workspace.Exam.CloneSurface.SurfaceGui

for _, child1 in pairs(workspace.Exam:GetChildren()) do
    for _, child2 in pairs(child1:GetChildren()) do
        if child2:IsA'BasePart' and child2.Name == 'Background' then
            local sur = child2:FindFirstChild('SurfaceGui')
            if not sur then sur = ui:Clone() end
            sur.Parent = child2
            sur.TextLabel.Text = child1.Name
            continue
        end
        local part = child2:FindFirstChild("Part")
        if not part then continue end
        local sur = part:FindFirstChild('SurfaceGui')
        if not sur then sur = ui:Clone() end
        sur.Parent = part
        sur.TextLabel.Text = child2.Name
    end
end