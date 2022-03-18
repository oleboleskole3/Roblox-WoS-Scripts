--#include canvas.lua
local screen = GetPartFromPort(1, 'Screen')

canvas.prepare(screen, 150, 150, 1)
canvas.polygon(0, 0, 0, 0, 25*3-1, 0, 25*3-1, 25*3-1, 0, 25*3-1)
canvas.present()