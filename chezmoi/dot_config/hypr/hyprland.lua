require("monitors")

---------------------
---- MY PROGRAMS ----
---------------------
local terminal    = "foot"
local fileManager = "dolphin"
local browser     = "firefox-nightly"
local mainMod     = "SUPER"

-- Загружаем нашу централизованную тему
 local theme = dofile(os.getenv("HOME") .. "/.config/theme/current.lua")

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function () 
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("waybar > /dev/null 2>&1")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  
  hl.exec_cmd("awww-daemon")
  
  hl.exec_cmd("swaync")
  hl.exec_cmd("swayosd-server -s ~/.config/swayosd/style.css")
  hl.exec_cmd("pypr")
  hl.exec_cmd("hypridle")
  
  hl.exec_cmd("wl-paste --type text --watch /run/current-system/sw/bin/cliphist store")
  hl.exec_cmd("wl-paste --type image --watch /run/current-system/sw/bin/cliphist store")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 10,
        border_size = 1,
        ["col.active_border"] = theme.accent,
        ["col.inactive_border"] = theme.subtle,
        layout = "dwindle",
    },
    decoration = {
        rounding = 0, -- Строгие прямые углы, как на сайте
        fullscreen_opacity = 1.0,
        
        shadow = {
            enabled = true,
            range = 15,
            render_power = 3,
            color = theme.base, -- Мягкая тень цвета фона
        },        
        
        blur = {
            enabled = true,
            size = 3,
            passes = 2,
            vibrancy = 0.1696,
        },
    },
    animations = {
        enabled = true,
    },
})

hl.layer_rule({
    name = "wofi",
    match = { namespace = "wofi" },
    no_anim = false, -- Убедись, что анимация разрешена
})

-- Твои любимые плавные анимации
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })

hl.config({ dwindle = { preserve_split = true } })
hl.config({ master = { new_status = "master" } })
hl.config({ scrolling = { fullscreen_on_one_column = true } })
hl.config({ misc = { force_default_wallpaper = -1, disable_hyprland_logo = true } })

---------------
---- INPUT ----
---------------
hl.config({
    input = {
        kb_layout  = "us, ru",
        kb_options = "grp:alt_shift_toggle",
        follow_mouse = 1,
        sensitivity = 0.1,
        touchpad = { natural_scroll = true },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

---------------------
---- KEYBINDINGS ----
---------------------
-- Скриншоты (твой старый скрипт)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("~/Scripts/screenshot.sh region"))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("~/Scripts/screenshot.sh output"))
hl.bind("PRINT", hl.dsp.exec_cmd("swappy -f $(find ~/Pictures/Screenshots -type f -printf '%T@ %p\\n' | sort -n | cut -d' ' -f2- | tail -n 1)"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("pkill wf-recorder || wf-recorder -g \"$(slurp)\" -f ~/Videos/recording_$(date +%Y-%m-%d_%H-%M-%S).mp4 --notify"))

-- Базовые приложения
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + Backspace", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- НОВЫЕ БИНДЫ ДЛЯ WOFI
hl.bind("ALT + Space", hl.dsp.exec_cmd("wofi --show drun"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("~/Scripts/wofi-clipboard.sh"))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("~/Scripts/wofi-power.sh"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("~/Scripts/wofi-wall.sh"))

-- Фокус и окна
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Воркспейсы
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Скролл и мышь
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Мультимедиа клавиши
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl set 5%+"),                          { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl set 5%-"),                          { locked = true, repeating = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

--------------------------------
---- WINDOW RULES --------------
--------------------------------
hl.window_rule({ name = "suppress-maximize-events", match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})
