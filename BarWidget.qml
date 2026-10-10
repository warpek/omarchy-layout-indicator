import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Ui

BarWidget {
  id: root
  moduleName: "io.github.warpek.layout-indicator"

  // Effective tiling layout of the focused workspace ("dwindle", "scrolling", ...).
  property string layoutName: ""
  property bool refreshPending: false

  readonly property var icons: ({
    "dwindle": String.fromCodePoint(0xF0574),   // md-view_quilt
    "master": String.fromCodePoint(0xF0BCC),    // md-view_split_vertical
    "scrolling": String.fromCodePoint(0xF056C), // md-view_carousel
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
    command: ["hyprctl", "activeworkspace", "-j"]
    onRunningChanged: if (!running && root.refreshPending) root.refresh()
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        let layout
        try {
          layout = JSON.parse(text || "{}").tiledLayout
        } catch (e) {
          return
        }
        if (typeof layout !== "string") return
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
