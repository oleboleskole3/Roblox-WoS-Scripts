---@diagnostic disable: undefined-global
local instrument = GetPartFromPort(3, 'Instrument')

while wait(10) do
    if instrument:GetReading(2) < 4000 then
        TriggerPort(1)
    end
    if instrument:GetReading(2) > 5000 then
        TriggerPort(2)
    end
end