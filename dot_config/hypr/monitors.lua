-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 2

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 2 })
hl.monitor({ output = "DP-1", mode = "3840x2160@60", position = "0x0", scale = 2 })
hl.monitor({ output = "DP-2", mode = "3840x2160@60", position = "0x0", scale = 2, mirror = "DP-1" })
