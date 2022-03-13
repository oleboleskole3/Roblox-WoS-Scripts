---@diagnostic disable: undefined-global
local Screen = GetPartFromPort(1, 'Screen') -- assigning the screen on port 1 to a variable
Screen:ClearElements() -- clear all elements already on the screen so there arent any old elements on it
local TextLabel = Screen:CreateElement('TextLabel', {
    AnchorPoint = Vector2.new(0, 0);
    Position = UDim2.fromScale(0.5, 0.5);
    Size = UDim2.fromScale(1, 1);
    Text = 'Hello, world!';
    TextSize = 20;
    TextScaled = false;
})

wait(5)

TextLabel:ChangeProperties({ -- change the text and size
    Text = 'Goodbye, world!';
    TextSize = 25
})

wait(2.5)

Screen:ClearElements() -- remove everything from the screen