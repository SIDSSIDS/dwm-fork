
conky.config = {
    out_to_x = false,
    out_to_console = true,
    update_interval = 1,
    lua_load = '/home/sids/distributives/dwm/dwm-git/src/dwm/bin/statusbar/script.lua'
}

conky.text = [[${lua conky_clock_text}]]
