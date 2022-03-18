local modem = GetPartFromPort(1, 'Modem')
local screen = GetPartFromPort(2, 'Screen')

Beep(1)

function showMsg(msg)
    screen:ClearElements()
    screen:CreateElement('TextLabel', {
        AnchorPoint = Vector2.new(0.5, 0.5);
        Position = UDim2.fromScale(0.5, 0.5);
        Size = UDim2.fromScale(1, 1);
        --Text = 'Hello, world!';
        --Text = JSONEncode();
        Text = JSONEncode(msg);
        --TextSize = 20;
        TextScaled = true;
    })
    -- error('Done!')
end

function done(response)
    showMsg(response)
end

function main()
    local response = modem:RealPostRequest('https://eoizyt7lh3grvk8.m.pipedream.net', '{"content": "Message"}', false, done, {["Content-Type"] = "application/json"; Accept = "application/json"})
    showMsg(response:sub(0, 70))
end

local success, errMessage = xpcall(main, debug.traceback)

if not success then
    wait(3)
    showMsg(errMessage:sub(0, 70))
end