-- vim: ts=4 sw=4 noet ai cindent syntax=lua

--[[
Conky, a system monitor, based on torsmo
]]

conky.config = {
	out_to_x = false,
	out_to_console = true,
    short_units = true,
    update_interval = 1,
	lua_load = '/home/sids/distributives/dwm/dwm-git/src/dwm/bin/statusbar/script.lua'
}

conky.text = [[${lua conky_top_text}]]
