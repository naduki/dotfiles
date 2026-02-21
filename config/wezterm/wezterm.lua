-- 名前空間、インクルード？
local wezterm = require 'wezterm';
local config = wezterm.config_builder();
local act = wezterm.action;
-- 関数系
-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
end
-- 使うフォント
config.font = wezterm.font_with_fallback {
    -- moralerspace
    {family="Moralerspace Radon HW", weight="Regular", stretch="Normal", style="Normal"},
    -- BuiltIn
    "JetBrains Mono", "Noto Color Emoji", "Symbols Nerd Font Mono"
}
-- Waylandで動かす
config.enable_wayland = true
-- フォントサイズ
config.font_size = 15.0
config.use_ime = true
-- テーマ
config.color_scheme = "Poimandres"
-- 初期(ウィンドウ)サイズ
config.initial_cols = 100  -- 幅
config.initial_rows = 24  -- 高さ
-- 背景透過
config.window_background_opacity = 0.85
-- タイトルバー無効
-- config.window_decorations = 'RESIZE'
-- タブの位置
config.tab_bar_at_bottom = false
-- タブバーの透明化
if config.tab_bar_at_bottom then
    config.use_fancy_tab_bar = true
    if config.use_fancy_tab_bar then
        config.window_frame = {
            inactive_titlebar_bg = "none",
            active_titlebar_bg = "none",
        }
    else
        config.colors = {
            tab_bar = {
                background = "none",
            },
        }
    end
end
-- リーダーキー
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 5000 }
-- ショートカットキー設定
config.keys = {
    -- フルスクリーン切り替え
    { key = 'f', mods = 'LEADER', action = act.ToggleFullScreen },
    -- 新規タブ
    { key = 't', mods = 'LEADER', action = act.SpawnTab("CurrentPaneDomain") },
    -- タブを閉じる
    { key = "w", mods = "LEADER", action = act.CloseCurrentTab{ confirm = true } },
    -- タブ左右移動
    { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    -- タブリスト
    { key = "q", mods = "LEADER", action = act.ShowTabNavigator },
    -- 新規ペイン(縦 / 上下)
    { key = 'v', mods = 'LEADER', action = act.SplitHorizontal{ domain = 'CurrentPaneDomain' } },
    -- 新規ペイン(横 / 左右)
    { key = "s", mods = "LEADER", action = act.SplitVertical{ domain = "CurrentPaneDomain" } },
    -- ペインを閉じる
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane{ confirm = true } },
    -- ペインの上下左右移動
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
}
-- タブ (すぐには更新されない)
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    -- プロセスに合わせてアイコン表示
    local nerd_icons = {
        nvim = wezterm.nerdfonts.custom_vim,
        -- docker = wezterm.nerdfonts.dev_docker,
        podman = wezterm.nerdfonts.dev_podman,
        bash = wezterm.nerdfonts.dev_terminal,
        fish = wezterm.nerdfonts.dev_terminal,
        -- ssh  = wezterm.nerdfonts.mdi_server,
        top  = wezterm.nerdfonts.mdi_monitor,
        htop  = wezterm.nerdfonts.mdi_monitor,
        git  = wezterm.nerdfonts.dev_git,
        nix  = wezterm.nerdfonts.md_nix,
        nano = wezterm.nerdfonts.md_note_edit,
    }
    local process_name = basename(tab.active_pane.foreground_process_name)
    local icon  = nerd_icons[process_name]
    local title = tab.tab_index + 1
    -- 使用しているシェル名(環境に応じて変更する)
    local shell = 'bash'

    -- シェルのときはプロセス名を表示しない [例) 1: ]
    -- 場合に応じてzshとかにもする
    if process_name ~= shell then
        title = title .. ": " .. process_name
    end
    -- アイコンがあるプロセスならアイコンも表示する
    -- bashはアイコンで判別する
    if icon ~= nil then
        title = icon .. "  " .. title
    end

    return {
        { Text = " " .. title .. " " },
    }
end)
-- 右ステータス
wezterm.on('update-right-status', function(window, pane)
    -- 表示内容変数
    local right_status = {}
    local DEFAULT_FG = { Color = '#9a9eab' }
    local DEFAULT_BG = { Color = '#1B1E28' }
    local date = wezterm.strftime '%m/%e(%a) %H:%M'
    local cwd_uri = pane:get_current_working_dir()
    -- リーダーキー有効表示
    if window:leader_is_active() then
        table.insert(right_status, { Foreground = { Color = '#7fffd4' }})
        table.insert(right_status, { Background = DEFAULT_BG })
        table.insert(right_status, { Text = ' ' .. 'LEADER' .. ' ' })
    else
        table.insert(right_status, { Foreground = DEFAULT_FG })
        table.insert(right_status, { Background = DEFAULT_BG })
        table.insert(right_status, { Text = '' .. '' .. '' })
    end
    -- Current Working Directoru
    if cwd_uri then
        local cwd = ''
        local hostname = ''

        if type(cwd_uri) == 'userdata' then
        -- Running on a newer version of wezterm and we have
        -- a URL object here, making this simple!
            cwd = cwd_uri.file_path
            hostname = cwd_uri.host or wezterm.hostname()
        else
        -- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
        -- which doesn't have the Url object
            cwd_uri = cwd_uri:sub(8)
            local slash = cwd_uri:find '/'
            if slash then
                hostname = cwd_uri:sub(1, slash - 1)
                -- and extract the cwd from the uri, decoding %-encoding
                cwd = cwd_uri:sub(slash):gsub('%%(%x%x)', function(hex)
                return string.char(tonumber(hex, 16))
                end)
            end
        end

        -- Remove the domain name portion of the hostname
        local dot = hostname:find '[.]'
        if dot then
            hostname = hostname:sub(1, dot - 1)
        end
        if hostname == '' then
            hostname = wezterm.hostname()
        end

        -- 表示内容作成 関数にすべきかな...?
        table.insert(right_status, { Foreground = { Color = '#75b1a9' }})
        table.insert(right_status, { Background = DEFAULT_BG })
        table.insert(right_status, { Text = ' ' .. wezterm.nerdfonts.fa_desktop .. '    ' })
        table.insert(right_status, { Text = '' .. hostname .. '  ' })
        table.insert(right_status, { Foreground = { Color = '#92aac7' }})
        table.insert(right_status, { Background = DEFAULT_BG })
        table.insert(right_status, { Text = '' .. wezterm.nerdfonts.custom_folder_open .. '  ' })
        table.insert(right_status, { Text = '' .. cwd .. '' })
        table.insert(right_status, { Foreground = DEFAULT_FG })
        table.insert(right_status, { Background = DEFAULT_BG })
        table.insert(right_status, { Text = '' .. '   ' .. '' })
    end
    -- 日時時刻表示
    table.insert(right_status, { Foreground = { Color = '#d3d3d3' }})
    table.insert(right_status, { Background = DEFAULT_BG })
    table.insert(right_status, { Text = '' .. wezterm.nerdfonts.md_clock .. '  ' })
    table.insert(right_status, { Text = '' .. date .. ' ' })
    table.insert(right_status, { Foreground = DEFAULT_FG })
    table.insert(right_status, { Background = DEFAULT_BG })
    -- 右ステータス更新
    window:set_right_status(wezterm.format(right_status))
end)
-- 基本設定の適用
return config
