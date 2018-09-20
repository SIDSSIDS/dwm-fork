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

binPath      = '/home/sids/distrs/dwm/dwm-git/src/dwm/bin'

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

function formatBytes(bytes)
    suffix = 'B'
    if (bytes >= 1000) then
        bytes = bytes / 1024
        suffix = 'K'
        if (bytes >= 1000) then
            bytes = bytes / 1024
            suffix = 'M'
            if (bytes >= 1000) then
                bytes = bytes / 1024
                suffix = 'G'
                if (bytes >= 1000) then
                    bytes = bytes / 1024
                    suffix = 'T'
                end
            end
        end
    end
    return string.format("%6.2f%s", bytes, suffix);
end

function getNetText()
    local lanIcon      = drawIcon('')
    local downIcon     = drawIcon('')
    local upIcon       = drawIcon('')

    local downspeed = conky_parse('${downspeed enp3s0}')
    local upspeed   = conky_parse('${upspeed enp3s0}')

    local totaldownbytes = tonumber(conky_parse('${head /sys/class/net/enp3s0/statistics/rx_bytes 1 1}'))
    local totalupbytes   = tonumber(conky_parse('${head /sys/class/net/enp3s0/statistics/tx_bytes 1 1}'))
    local resetdownbytes = tonumber(conky_parse('${head /home/sids/.enp3s0_rx_bytes 1 1}'))
    local resetupbytes   = tonumber(conky_parse('${head /home/sids/.enp3s0_tx_bytes 1 1}'))

    if (resetdownbytes ~= nil and totaldownbytes >= resetdownbytes) then
        totaldownbytes = totaldownbytes - resetdownbytes
    end

    if (resetupbytes ~= nil and totalupbytes >= resetupbytes) then
        totalupbytes = totalupbytes - resetupbytes
    end

    local downtotal      = formatBytes(totaldownbytes)
    local uptotal        = formatBytes(totalupbytes)

    netText = lanIcon..' '..string.format("%6s(%s)", upspeed, uptotal)..' '..upIcon..string.format(" %6s(%s)", downspeed, downtotal)..' '..downIcon
    return netText
end

function conky_bottom_text()

    --network
    local netText = getNetText()

    return conky_parse(netText..'  ')
end

function conky_top_text()

    -- date
    local dateText     = drawIcon('') .. ' ^ca(1,dzen-cal -a tr --y-indent 21 --x-indent 1760)${time %a %d.%m.%Y}^ca()'
    
    -- time
    local timeText     = '^ca(1,'..binPath..'/reminder all)'..drawIcon('') .. '^ca() ${time %H:%M:%S}'
    
    -- volume
    local vol          = conky_parse('${exec pamixer --get-volume}')
    local volColor     = '${exec '..binPath..'/get_volume_symb col}'
    local volIcon      = '${exec '..binPath..'/get_volume_symb sym}'
    local volText      = drawIcon(volIcon, volColor)..string.format(" %3s%%", vol)

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

    return conky_parse(workText .. cpuText .. ' ' .. memText .. ' ' .. volText .. ' ' .. dateText .. ' ' .. timeText .. ' ' .. layText)
end
