# Layout Indicator

An Omarchy bar widget that shows a single icon for the window layout of the
focused workspace. It supports tiling layouts and Omarchy's floating mode,
where windows can be moved and resized freely like a traditional desktop.
The icon follows you as you switch workspaces and monitors.

<img src="preview.png" alt="Layout Indicator next to the workspaces in the Omarchy bar" width="134">

| Layout    | Icon | Glyph                           |
|-----------|------|---------------------------------|
| dwindle   | 󰕴    | U+F0574 `md-view_quilt`          |
| master    | 󰯌    | U+F0BCC `md-view_split_vertical` |
| scrolling | 󰕬    | U+F056C `md-view_carousel`       |
| floating  | 󰖲    | U+F05B2 `md-window_restore`      |
| monocle   | 󰹟    | U+F0E5F `md-rectangle_outline`   |
| other     | 󰘔    | U+F0614 `md-application_outline` |

Hover the icon to see the layout name. Left click cycles the workspace through
dwindle, scrolling, and floating with Omarchy's own layout toggle command
(the same action as <kbd>Super</kbd>+<kbd>L</kbd>). Floating mode uses an
overlapping-windows icon.

## Install

```bash
omarchy plugin add https://github.com/warpek/omarchy-layout-indicator
```

The installer offers to enable it and suggests the left side of the bar, next
to the workspaces. To enable it later:

```bash
omarchy plugin enable io.github.warpek.layout-indicator left
```

## Remove

```bash
omarchy plugin disable io.github.warpek.layout-indicator
omarchy plugin remove io.github.warpek.layout-indicator
```

## How it works

The layout is read using `omarchy hyprland workspace layout current`, which
accounts for Omarchy's saved workspace mode and default layout as well as
Hyprland's tiling layout. Reading `tiledLayout` from Hyprland alone cannot
detect floating mode: it still reports the underlying tiling layout.

The widget refreshes on workspace and monitor focus events, shortly after a
click, and every 1.5 seconds to catch layout changes made with keyboard
shortcuts. Unrecognized layout names use a fallback icon.

## Requirements

Omarchy with the Quickshell-based `omarchy-shell` bar and Hyprland 0.56 or
later, plus the `omarchy hyprland workspace layout current` command supplied
by Omarchy versions with floating workspace support. It uses the Nerd Font
the bar already ships with and has no other dependencies.

## License

MIT
