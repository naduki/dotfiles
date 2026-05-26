local wezterm = require 'wezterm'
local config  = wezterm.config_builder()
local act     = wezterm.action

-- ══════════════════════════════════════════════
--  Utility functions
-- ══════════════════════════════════════════════

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
local function basename(s)
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- Shorten parent directory components to first character, like fish shell
-- e.g. /home/user/documents/projects/foo -> ~/d/p/foo
local function shorten_path(cwd)
    -- Replace $HOME with ~
    local home = os.getenv('HOME') or ''
    if home ~= '' and cwd:sub(1, #home) == home then
        cwd = '~' .. cwd:sub(#home + 1)
    end
    -- Trim trailing slash to prevent empty last component
    cwd = cwd:gsub('/+$', '')
    -- Split by '/'
    local parts = {}
    for part in (cwd .. '/'):gmatch('([^/]*)/') do
        table.insert(parts, part)
    end
    if #parts == 0 then return cwd end
    -- Shorten all but the last component; keep last (current dir) as full name
    local result = {}
    for i, part in ipairs(parts) do
        if i == #parts then
            table.insert(result, part)           -- last: keep full name
        elseif part == '' then
            table.insert(result, '')             -- absolute root '/'
        elseif part:sub(1, 1) == '.' then
            table.insert(result, part:sub(1, 2)) -- dotdir: keep dot + 1 char
        else
            table.insert(result, part:sub(1, 1))
        end
    end
    return table.concat(result, '/')
end

-- Read memory usage from /proc/meminfo, returns "used (use%)" string.
-- Cache to reduce file I/O: refreshes at most once every MEM_CACHE_TTL seconds.
local MEM_CACHE_TTL = 5
local mem_cache = { value = nil, last_update = 0 }
local function get_memory_usage()
    local now = os.time()
    if (now - mem_cache.last_update) < MEM_CACHE_TTL then
        return mem_cache.value
    end
    local f = io.open('/proc/meminfo', 'r')
    if not f then return mem_cache.value end
    local memtotal, memavail
    for line in f:lines() do
        local key, val = line:match('^(%w+):%s+(%d+)')
        if key == 'MemTotal'     then memtotal = tonumber(val)
        elseif key == 'MemAvailable' then memavail = tonumber(val) end
        if memtotal and memavail then break end
    end
    f:close()
    if not memtotal or not memavail then return mem_cache.value end
    local used      = memtotal - memavail
    local used_gb   = used / (1024 * 1024)
    local usage_pct = math.floor(used / memtotal * 100 + 0.5)
    mem_cache.value       = string.format('%.1fGB (%d%%)', used_gb, usage_pct)
    mem_cache.last_update = now
    return mem_cache.value
end

-- ══════════════════════════════════════════════
--  Static data
-- ══════════════════════════════════════════════

-- Process name -> Nerd Font icon
local NERD_ICONS = {
    nvim   = wezterm.nerdfonts.custom_vim,
    podman = wezterm.nerdfonts.dev_podman,
    bash   = wezterm.nerdfonts.dev_terminal,
    fish   = wezterm.nerdfonts.dev_terminal,
    top    = wezterm.nerdfonts.mdi_monitor,
    htop   = wezterm.nerdfonts.mdi_monitor,
    git    = wezterm.nerdfonts.dev_git,
    nix    = wezterm.nerdfonts.md_nix,
    nano   = wezterm.nerdfonts.md_note_edit,
    gemini = wezterm.nerdfonts.md_google,
}

-- Keyword -> display name for Node.js-based CLI tools
-- When foreground process is 'node', argv is scanned for these keywords.
local NODE_APP_ALIASES = {
    gemini = 'gemini',
}

-- ══════════════════════════════════════════════
--  Appearance
-- ══════════════════════════════════════════════

config.font = wezterm.font_with_fallback {
    { family = "Moralerspace Radon HW", weight = "Regular", stretch = "Normal", style = "Normal" },
    "JetBrains Mono", "Noto Color Emoji", "Symbols Nerd Font Mono",
}
config.font_size                             = 15.0
config.color_scheme                          = "Poimandres"
config.window_background_opacity             = 0.85
config.default_cursor_style                  = "BlinkingBar"
config.adjust_window_size_when_changing_font_size = false
config.inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.6,
}

-- ══════════════════════════════════════════════
--  Behaviour
-- ══════════════════════════════════════════════

config.enable_wayland          = true
config.use_ime                 = true
config.scrollback_lines        = 10000
config.audible_bell            = "Disabled"
config.window_close_confirmation = "NeverPrompt"
-- Initial window size (for non-tiling WMs)
config.initial_cols = 100
config.initial_rows = 24

-- ══════════════════════════════════════════════
--  Tab bar
-- ══════════════════════════════════════════════

config.tab_bar_at_bottom = false

-- ══════════════════════════════════════════════
--  Key bindings
-- ══════════════════════════════════════════════

config.leader = { key = ',', mods = 'CTRL', timeout_milliseconds = 5000 }
config.keys = {
    { key = 'f',  mods = 'LEADER', action = act.ToggleFullScreen },
    -- Tabs
    { key = 't',  mods = 'LEADER', action = act.SpawnTab("CurrentPaneDomain") },
    { key = 'w',  mods = 'LEADER', action = act.CloseCurrentTab{ confirm = true } },
    { key = 'n',  mods = 'LEADER', action = act.ActivateTabRelative(1) },
    { key = 'p',  mods = 'LEADER', action = act.ActivateTabRelative(-1) },
    { key = 'q',  mods = 'LEADER', action = act.ShowTabNavigator },
    -- Panes
    { key = 'v',  mods = 'LEADER', action = act.SplitHorizontal{ domain = 'CurrentPaneDomain' } },
    { key = 's',  mods = 'LEADER', action = act.SplitVertical{ domain = 'CurrentPaneDomain' } },
    { key = 'x',  mods = 'LEADER', action = act.CloseCurrentPane{ confirm = true } },
    { key = 'h',  mods = 'LEADER', action = act.ActivatePaneDirection("Left") },
    { key = 'l',  mods = 'LEADER', action = act.ActivatePaneDirection("Right") },
    { key = 'k',  mods = 'LEADER', action = act.ActivatePaneDirection("Up") },
    { key = 'j',  mods = 'LEADER', action = act.ActivatePaneDirection("Down") },

    { key = 'd', mods = 'LEADER', action = act.ShowDebugOverlay },
}

-- ══════════════════════════════════════════════
--  Event handlers
-- ══════════════════════════════════════════════

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local process_name = basename(tab.active_pane.foreground_process_name)

    -- node.js apps: resolve the real app name from argv
    if process_name == 'node' then
        local mux_pane = wezterm.mux.get_pane(tab.active_pane.pane_id)
        if mux_pane then
            local info = mux_pane:get_foreground_process_info()
            if info and info.argv then
                for _, arg in ipairs(info.argv) do
                    for keyword, alias in pairs(NODE_APP_ALIASES) do
                        if arg:lower():find(keyword, 1, true) then
                            process_name = alias
                            break
                        end
                    end
                    if process_name ~= 'node' then break end
                end
            end
        end
    end

    local icon  = NERD_ICONS[process_name]
    local title = tostring(tab.tab_index + 1) .. ': ' .. process_name
    if icon then
        title = icon .. '  ' .. title
    end
    return { { Text = ' ' .. title .. ' ' } }
end)


wezterm.on('update-right-status', function(window, pane)
    local DEFAULT_FG = { Color = '#9a9eab' }
    local DEFAULT_BG = { Color = '#1B1E28' }
    local s = {}  -- right_status elements

    -- Leader key indicator
    if window:leader_is_active() then
        table.insert(s, { Foreground = { Color = '#7fffd4' } })
        table.insert(s, { Background = DEFAULT_BG })
        table.insert(s, { Text = ' LEADER ' })
    else
        table.insert(s, { Foreground = DEFAULT_FG })
        table.insert(s, { Background = DEFAULT_BG })
        table.insert(s, { Text = '' })
    end

    -- Hostname + CWD
    local cwd_uri = pane:get_current_working_dir()
    if cwd_uri then
        local cwd, hostname = '', ''
        if type(cwd_uri) == 'userdata' then
            cwd      = cwd_uri.file_path
            hostname = cwd_uri.host or wezterm.hostname()
        else
            cwd_uri  = cwd_uri:sub(8)
            local slash = cwd_uri:find '/'
            if slash then
                hostname = cwd_uri:sub(1, slash - 1)
                cwd      = cwd_uri:sub(slash):gsub('%%(%x%x)', function(hex)
                    return string.char(tonumber(hex, 16))
                end)
            end
        end
        local dot = hostname:find '[.]'
        if dot then hostname = hostname:sub(1, dot - 1) end
        if hostname == '' then hostname = wezterm.hostname() end

        table.insert(s, { Foreground = { Color = '#75b1a9' } })
        table.insert(s, { Background = DEFAULT_BG })
        table.insert(s, { Text = ' ' .. wezterm.nerdfonts.fa_desktop .. '    ' })
        table.insert(s, { Text = hostname .. '  ' })
        table.insert(s, { Foreground = { Color = '#92aac7' } })
        table.insert(s, { Background = DEFAULT_BG })
        table.insert(s, { Text = wezterm.nerdfonts.custom_folder_open .. '  ' })
        table.insert(s, { Text = shorten_path(cwd) })
        table.insert(s, { Foreground = DEFAULT_FG })
        table.insert(s, { Background = DEFAULT_BG })
        table.insert(s, { Text = '   ' })
    end

    -- Memory usage
    local mem = get_memory_usage()
    if mem then
        table.insert(s, { Foreground = { Color = '#c3a6ff' } })
        table.insert(s, { Background = DEFAULT_BG })
        table.insert(s, { Text = wezterm.nerdfonts.md_memory .. '  ' })
        table.insert(s, { Text = mem .. '   ' })
    end

    -- Date / time
    table.insert(s, { Foreground = { Color = '#d3d3d3' } })
    table.insert(s, { Background = DEFAULT_BG })
    table.insert(s, { Text = wezterm.nerdfonts.md_clock .. '  ' })
    table.insert(s, { Text = wezterm.strftime '%m/%e(%a) %H:%M' .. ' ' })
    table.insert(s, { Foreground = DEFAULT_FG })
    table.insert(s, { Background = DEFAULT_BG })

    window:set_right_status(wezterm.format(s))
end)

-- ══════════════════════════════════════════════
return config
