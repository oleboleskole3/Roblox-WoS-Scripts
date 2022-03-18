---@diagnostic disable: undefined-global
local starmap = GetPartFromPort(1, 'StarMap')
local telescope = GetPartFromPort(2, 'Telescope')
local screen = GetPartFromPort(3, 'Screen')

Beep(1)

local out = ''
local status, err = pcall(function ()
-- for index, value in pairs(telescope:GetCoordinate(28, 84, 8, -10)) do
--     out = out .. index .. ' '
-- end
out = JSONEncode(starmap:GetSystems()())
end)

if not status then
screen:ClearElements()
screen:CreateElement('TextLabel', {
AnchorPoint = Vector2.new(0.5, 0.5);
Position = UDim2.fromScale(0.5, 0.5);
Size = UDim2.fromScale(1, 1);
--Text = 'Hello, world!';
--Text = JSONEncode();
Text = err;
--TextSize = 20;
TextScaled = true;
})
return
end


screen:ClearElements()
screen:CreateElement('TextLabel', {
AnchorPoint = Vector2.new(0, 0);
Position = UDim2.fromScale(0, 0);
Size = UDim2.fromScale(1, 1);
--Text = 'Hello, world!';
--Text = JSONEncode();
Text = out;
--TextSize = 20;
TextScaled = true;
})


