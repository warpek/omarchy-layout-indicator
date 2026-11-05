import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Ui

BarWidget {
  id: root
  moduleName: "io.github.warpek.layout-indicator"

  // Effective workspace layout, including Omarchy's floating mode.
  property string layoutName: ""
  property bool refreshPending: false

  readonly property var icons: ({
    "dwindle": String.fromCodePoint(0xF0574),   // md-view_quilt
    "master": String.fromCodePoint(0xF0BCC),    // md-view_split_vertical
    "scrolling": String.fromCodePoint(0xF056C), // md-view_carousel
    "floating": String.fromCodePoint(0xF05B2),  // md-window_restore (overlapping windows)
    "monocle": String.fromCodePoint(0xF0E5F)    // md-rectangle_outline
  })
  readonly property string fallbackIcon: String.fromCodePoint(0xF0614) // md-application_outline

  readonly property var refreshEvents: [
    "workspace", "workspacev2", "focusedmon", "focusedmonv2",
    "moveworkspace", "moveworkspacev2", "createworkspacev2",
    "activespecial", "activespecialv2", "configreloaded", "monitoraddedv2"
  ]

  function refresh() {
    if (queryProc.running) {
      refreshPending = true
      return
    }
    refreshPending = false
    queryProc.running = true
  }

  function toggleLayout() {
    if (!root.bar) return
    root.bar.run("omarchy-hyprland-workspace-layout-toggle")
    refreshTimer.restart()
  }

  Component.onCompleted: refresh()

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (event && root.refreshEvents.indexOf(String(event.name)) !== -1) root.refresh()
    }
  }

  Process {
    id: queryProc
    // Hyprland's tiledLayout does not report Omarchy's floating workspace mode.
    command: ["omarchy", "hyprland", "workspace", "layout", "current"]
    onRunningChanged: if (!running && root.refreshPending) root.refresh()
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        const layout = text.trim()
        if (!/^[a-z][a-z0-9_-]*$/.test(layout)) return
        if (layout !== root.layoutName) root.layoutName = layout
      }
    }
  }

  // Short delay after a click so the toggle script has applied the new rule.
  Timer {
    id: refreshTimer
    interval: 300
    onTriggered: root.refresh()
  }

  // SUPER+L toggles emit no Hyprland event, so poll lightly to catch them.
  Timer {
    interval: 1500
    running: true
    repeat: true
    onTriggered: root.refresh()
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.icons[root.layoutName] || root.fallbackIcon
    tooltipText: "Layout: " + (root.layoutName
      ? root.layoutName.charAt(0).toUpperCase() + root.layoutName.slice(1)
      : "Unknown")
    onPressed: function(buttonCode) {
      if (buttonCode === Qt.LeftButton) root.toggleLayout()
    }
  }
}
