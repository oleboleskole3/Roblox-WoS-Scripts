local Container = GetPartFromPort(1, 'Container')
local State = GetPartFromPort(3, 'Sign')
local DispensersPort = 2

local states = {
--Idle
["0"] = function ()
if Container:GetAmount() <= 100 then
TriggerPort(DispensersPort)

State.
end
end;
--Reach 1000
["1"] = function ()

end;
--Reach 5000
["2"] = function ()

end;
}

-- while wait(1) do
if Container:GetAmount() <= 100 then
TriggerPort(DispensersPort)
-- while Container:GetAmount() <= 0 do
--     wait(5)
-- end
-- while Container:GetAmount() <= 1000 do
--     wait(1)
-- end
end
if Container:GetAmount() >= 6000 then
TriggerPort(DispensersPort)

while Container:GetAmount() >= 5000 do
wait(1)
end
TriggerPort(DispensersPort)
end

-- end
