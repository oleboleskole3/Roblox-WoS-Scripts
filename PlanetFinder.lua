---@diagnostic disable: undefined-global
local starmap = GetPartFromPort(1, 'Starmap')
local telescope = GetPartFromPort(2, 'Telescope')
local screen = GetPartFromPort(3, 'Screen')

screen:ClearElements()
screen:CreateElement('TextLabel', {
    AnchorPoint = Vector2.new(0.5, 0.5);
    Position = UDim2.fromScale(0.5, 0.5);
    Size = UDim2.fromScale(1, 1);
    --Text = 'Hello, world!';
    Text = JSONEncode(starmap:GetBodies());
    TextSize = 20;
    TextScaled = false;
})

