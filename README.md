# Layout Indicator

An Omarchy bar widget that shows a single icon for the Hyprland tiling layout
of the focused workspace. Hyprland sets layouts per workspace, so the icon
follows you as you switch workspaces and monitors.

<img src="preview.png" alt="Layout Indicator next to the workspaces in the Omarchy bar" width="134">

| Layout    | Icon | Glyph                           |
|-----------|------|---------------------------------|
| dwindle   | 󰕴    | U+F0574 `md-view_quilt`          |
| master    | 󰯌    | U+F0BCC `md-view_split_vertical` |
| scrolling | 󰕬    | U+F056C `md-view_carousel`       |
| monocle   | 󰹟    | U+F0E5F `md-rectangle_outline`   |
| other     | 󰘔    | U+F0614 `md-application_outline` |

Hover the icon to see the layout name. Left click toggles the workspace between
dwindle and scrolling with Omarchy's own `omarchy-hyprland-workspace-layout-toggle`
(the same action as <kbd>Super</kbd>+<kbd>L</kbd>).

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

The layout is read from `tiledLayout` in `hyprctl activeworkspace -j`. The
widget re-reads it on workspace and monitor focus events, and every 1.5 seconds,
because Hyprland raises no event when a layout changes. Each read takes a few
milliseconds.

## Requirements

Omarchy with the Quickshell-based `omarchy-shell` bar and Hyprland 0.56 or
later. It uses the Nerd Font the bar already ships with and has no other
dependencies.

## License

MIT
