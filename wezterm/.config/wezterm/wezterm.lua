local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 11.0
config.line_height = 1.15

-- Shell
config.default_prog = { '/usr/bin/bash', '-l' }
config.front_end = 'WebGpu'

-- Catppuccin Mocha palette (official port)
local colors = {
  base       = '#1e1e2e',
  mantle     = '#181825',
  crust      = '#11111b',
  surface0   = '#313244',
  surface1   = '#45475a',
  surface2   = '#585b70',
  overlay0   = '#6c7086',
  overlay1   = '#7f849c',
  overlay2   = '#9399b2',
  subtext1   = '#bac2de',
  subtext0   = '#a6adc8',
  text       = '#cdd6f4',
  lavender   = '#b4befe',
  blue       = '#89b4fa',
  sapphire   = '#74c7ec',
  sky        = '#89dceb',
  teal       = '#94e2d5',
  green      = '#a6e3a1',
  yellow     = '#f9e2af',
  peach      = '#fab387',
  maroon     = '#eba0ac',
  red        = '#f38ba8',
  mauve      = '#cba6f7',
  pink       = '#f5c2e7',
  flamingo   = '#f2cdcd',
  rosewater  = '#f5e0dc',
}

config.colors = {
  foreground = colors.text,
  background = colors.base,
  cursor_bg = colors.rosewater,
  cursor_fg = colors.base,
  cursor_border = colors.rosewater,
  selection_bg = colors.surface2,
  selection_fg = colors.text,
  ansi = {
    colors.surface1, colors.red, colors.green, colors.yellow,
    colors.blue, colors.pink, colors.teal, colors.subtext1,
  },
  brights = {
    colors.surface2, colors.red, colors.green, colors.yellow,
    colors.blue, colors.pink, colors.teal, colors.subtext0,
  },
  tab_bar = {
    background = 'none',
    active_tab = {
      bg_color = colors.surface0,
      fg_color = colors.text,
    },
    inactive_tab = {
      bg_color = colors.mantle,
      fg_color = colors.subtext0,
    },
    new_tab = {
      bg_color = colors.crust,
      fg_color = colors.text,
    },
    inactive_tab_hover = {
      bg_color = colors.surface1,
      fg_color = colors.text,
    },
  },
}

-- Transparenz und Glaseffekt (keep the glass look)
config.window_background_opacity = 0.70
config.wayland_window_background_blur = true
config.macos_window_background_blur = 40

-- KDE-Fensterrahmen einschalten (TITLE | RESIZE keeps the KWin frame)
config.window_decorations = 'TITLE | RESIZE'

-- Tab bar
config.use_fancy_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

-- Window
config.window_padding = { left = 4, right = 4, top = 2, bottom = 2 }
config.adjust_window_size_when_changing_font_size = false
config.enable_scroll_bar = false

-- Keys: Alt+hjkl -> split navigation, Alt+Shift+hjkl -> splits
config.keys = {
  { key = 'h', mods = 'ALT',        action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'ALT',        action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'ALT',        action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'ALT',        action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'h', mods = 'ALT|SHIFT',  action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'v', mods = 'ALT|SHIFT',  action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'm', mods = 'ALT',        action = wezterm.action.TogglePaneZoomState },
}

config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_clipboard() ~= ''
      if has_selection then
        window:copy_to_clipboard(window:get_selection_text_for_clipboard())
      end
      window:perform_action(wezterm.action.PasteFrom 'Clipboard', pane)
    end),
  },
}

return config