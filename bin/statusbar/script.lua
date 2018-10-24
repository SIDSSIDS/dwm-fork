require 'cairo'

bgGreen = '\\#AFD700'
fgGreen = '\\#0C6700'
bgBlue  = '\\#0087AF'
bgGray  = '\\#585858'
fgGray  = '\\#999999'
bgOrange = '\\#D75F00'
fgOrange = '\\#FFD700'

colWhite     = '\\#ffffff'
colBlack     = '\\#000000'
colRed500    = '\\#f44336'
colYellow500 = '\\#ffeb3b'
colBlue500   = '\\#2196f3'
colGrey500   = '\\#9e9e9e'
colGreen500  = '\\#4caf50'
colPink500   = '\\#e91e63'
colOrange500 = '\\#ff9800'
colIndigo500 = '\\#3f51b5'
colCyan500   = '\\#00bcd4'

FontAwesome  = 'FontAwesome5Free-12:style=Solid'
LiberBold    = 'Liberation Mono-14:style=Bold'
PowerLine    = 'PowerlineSymbols-19:style=Medium'

binPath      = '/home/sids/distributives/dwm/dwm-git/src/dwm/bin'

function drawIcon(iconChar, color, font)
    if (color == nil) then
        color = colYellow500
    end
    if (font == nil) then
        font = FontAwesome
    end
    return string.format("^fg(%s)^fn(%s)%s^fn()^fg()", color, font, iconChar)
end

function codeInProgress()
    local codeIcon   = drawIcon('', colCyan500)
    local workStatus = conky_parse('${exec '..binPath..'/toggle_work status}')
    if (workStatus == 'start') then
        return '^ca(1,'..binPath..'/toggle_work time)'..codeIcon..'^ca()'..sep()
    else
        return ''
    end
end

function getNetText()
    local lanIcon      = drawIcon('')
    local wifiIcon     = drawIcon('')
    local mobIcon      = drawIcon('')
    local downIcon     = drawIcon('', colGreen500)
    local upIcon       = drawIcon('', colRed500)
    local vpnIcon      = drawIcon('', fgOrange, PowerLine)

    local tun_int    = conky_parse('${if_up tun0}tun0${endif}')
    local lan_int    = conky_parse('${if_existing /sys/class/net/enp3s0f1/operstate up}enp3s0f1${endif}')
    local wifi_int   = conky_parse('${if_existing /sys/class/net/wlp2s0/operstate up}wlp2s0${endif}')
    local mobile_int = conky_parse('${if_up enp0s20f0u5}enp0s20f0u5${endif}')
    local net_icon   = ''
    local net_int    = ''
    local tun_icon   = ''
    local net_name   = ''

    local netText    = ''

    if (lan_int ~= nil and lan_int ~= '') then
        net_int = lan_int
        net_icon = lanIcon
    end
    if (wifi_int ~= nil and wifi_int ~= '') then
        net_int = wifi_int
        net_name = conky_parse('${wireless_essid '..wifi_int..'}')
        net_icon = wifiIcon
    end
    if (mobile_int ~= nil and mobile_int ~= '') then
        net_int = mobile_int
        net_icon = mobIcon
    end

    if (net_int ~= nil and net_int ~= '') then
      local downspeed = conky_parse('${downspeed '..net_int..'}')
      local upspeed   = conky_parse('${upspeed '..net_int..'}')
      local downtotal = conky_parse('${totaldown '..net_int..'}')
      local uptotal   = conky_parse('${totalup '..net_int..'}')

      if (tun_int ~= nil and tun_int ~= '') then
          tun_icon = '^fg('..bgOrange..')^fn('..PowerLine..')^fn()^fg()^bg('..bgOrange..') '..vpnIcon..' ^bg()'
      end

      netText = net_icon..' '
      if (net_name ~= nil and net_name ~= '') then
          netText = '^fn('..LiberBold..')'..net_name..'^fn() '..netText
      end
      netText = '^fg('..bgBlue..')^fn('..PowerLine..')^fn()^fg()^bg('..bgBlue..') '..netText;
      netText = '^fg('..bgGray..')^fn('..PowerLine..')^fn()^fg()^bg('..bgGray..') ^fn('..LiberBold..')^fg(\\#DD4000)'..string.format("%6s(%s)", upspeed, uptotal)..'^fg()^fn()'..'^fn('..LiberBold..')^fg('..colGreen500..')'..string.format("%6s(%s)", downspeed, downtotal)..'^fg()^fn() '..netText..tun_icon
    end
    return netText
end

function conky_bottom_text()

    --network
    local netText = getNetText()

    return conky_parse(netText)
end

function conky_top_text()

    -- date
    local dateText     = '^fg('..bgBlue..')^fn('..PowerLine..')^fn()^fg()^bg('..bgBlue..') ' .. drawIcon('') .. ' ^ca(1,dzen-cal -a tr --y-indent 21 --x-indent 80)^fn('..LiberBold..')${time %a %d.%m.%Y}^fn()^ca()'
    
    -- time
    local timeText     = '^ca(1,'..binPath..'/reminder all)'..drawIcon('') .. '^ca() ^ca(1,'..binPath..'/statusbar/clock.sh)^fn('..LiberBold..')${time %H:%M:%S}^fn()^ca()'
    
    -- volume
    local vol          = conky_parse('${exec pamixer --get-volume}')
    local volColor     = '${exec '..binPath..'/get_volume_symb col}'
    local volIcon      = '${exec '..binPath..'/get_volume_symb sym}'
    local volText      = drawIcon(volIcon, volColor)..'^fn('..LiberBold..')'..string.format(" %3s%%", vol)..'^fn()'

    -- power
    local powColor     = '${exec '..binPath..'/get_battery_status col}'
    local powIcon      = '${exec '..binPath..'/get_battery_status sym}'
    local powText      = drawIcon(powIcon, powColor) .. ' ^fn('..LiberBold..')${exec '..binPath..'/get_battery_status str}^fn()'

    -- memory usage
    local mem          = conky_parse('${memperc}')
    local memText      = drawIcon('')..'^fn('..LiberBold..')'..string.format(" %2d%%", mem)..'^fn()'

    -- cpu usage
    local cpu          = conky_parse('${cpu}')
    local cpuText      = drawIcon('')..'^fn('..LiberBold..')'..string.format(" %2d%%", cpu)..'^fn()'

    -- keyboard layout
    local layText      = '^fg('..bgGreen..')^fn('..PowerLine..')^bg('..bgGreen..')^fg('..fgGreen..')^fn('..LiberBold..') ${exec '..binPath..'/get_xkb_layout} ^fn()^fg()^bg()'

    --working status
    local workText     = codeInProgress()

    return conky_parse('^fg('..bgGray..')^fn('..PowerLine..')^fn()^fg()^bg('..bgGray..') ' .. workText .. cpuText .. sep() .. memText .. sep() .. volText .. sep() .. powText .. ' ' .. dateText .. sep('\\#ffffff') .. timeText .. ' ' .. layText)
end

function printTime(title, timezone)
    return string.format('${tztime %s %s}^fg('..bgGreen..')^fn('..PowerLine..')^fn()^fg()^fg('..fgGreen..')^bg('..bgGreen..')%s ^bg()^fg()', timezone, '%T ', title)
end

function sep(col)
    if (col == nil) then
        col = fgGray
    end
    return ' ^fg('..col..')^fn('..PowerLine..')^fn()^fg() '
end

function conky_clock_text()

    local mskTime = printTime("MSK", "Europe/Moscow")
    local thaTime = printTime("THD", "Asia/Bangkok")

    return conky_parse(mskTime .. '\n' .. thaTime)
end
