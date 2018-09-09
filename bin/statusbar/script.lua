require 'cairo'

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

binPath      = '/home/sids/distributives/dwm/dwm-git/src/dwm/bin'

function drawIcon(iconChar, color)
    if (color == nil) then
        color = colYellow500
    end
    return string.format("^fg(%s)^fn(%s)%s^fn()^fg()", color, FontAwesome, iconChar)
end

function codeInProgress()
    local codeIcon   = drawIcon('', colCyan500)
    local workStatus = conky_parse('${exec '..binPath..'/toggle_work status}')
    if (workStatus == 'start') then
        return '^ca(1,'..binPath..'/toggle_work time)'..codeIcon..'^ca() '
    else
        return ''
    end
end

function getNetText()
    local lanIcon      = drawIcon('')
    local wifiIcon     = drawIcon('')
    local mobIcon      = drawIcon('')
    local downIcon     = drawIcon('')
    local upIcon       = drawIcon('')
    local vpnIcon      = drawIcon('')

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
      local tundowntotal = ''
      local tunuptotal   = ''

      if (tun_int ~= nil and tun_int ~= '') then
          tun_icon = vpnIcon..' '
          --tundowntotal = '('..conky_parse('${totaldown '..tun_int..'}')..')'
          --tunuptotal   = '('..conky_parse('${totalup '..tun_int..'}')..')'
      end

      netText = tun_icon .. net_icon..' '
      if (net_name ~= nil and net_name ~= '') then
          netText = netText..net_name..' '
      end
      netText = netText..string.format("%6s(%s)", upspeed, uptotal)..' '..upIcon..string.format(" %6s(%s)", downspeed, downtotal)..' '..downIcon
    end
    return netText
end

function conky_bottom_text()

    --network
    local netText = getNetText()

    return conky_parse(netText..'  ')
end

function conky_top_text()

    -- date
    local dateText     = drawIcon('') .. ' ^ca(1,dzen-cal -a tr --y-indent 21 --x-indent 80)${time %a %d.%m.%Y}^ca()'
    
    -- time
    local timeText     = drawIcon('') .. ' ${time %H:%M:%S}'
    
    -- volume
    local vol          = conky_parse('${exec pamixer --get-volume}')
    local volColor     = '${exec '..binPath..'/get_volume_symb col}'
    local volIcon      = '${exec '..binPath..'/get_volume_symb sym}'
    local volText      = drawIcon(volIcon, volColor)..string.format(" %3s%%", vol)

    -- power
    local powColor     = '${exec '..binPath..'/get_battery_status col}'
    local powIcon      = '${exec '..binPath..'/get_battery_status sym}'
    local powText      = drawIcon(powIcon, powColor) .. ' ${exec '..binPath..'/get_battery_status str}'

    -- memory usage
    local mem          = conky_parse('${memperc}')
    local memText      = drawIcon('')..string.format(" %2d%%", mem)

    -- cpu usage
    local cpu          = conky_parse('${cpu}')
    local cpuText      = drawIcon('')..string.format(" %2d%%", cpu)

    -- keyboard layout
    local layText      = '^bg('..colYellow500..')^fg('..colBlack..') ${exec '..binPath..'/get_xkb_layout} ^fg()^bg()'

    --working status
    local workText     = codeInProgress()

    return conky_parse(workText .. cpuText .. ' ' .. memText .. ' ' .. volText .. ' ' .. powText .. ' ' .. dateText .. ' ' .. timeText .. ' ' .. layText)
end
