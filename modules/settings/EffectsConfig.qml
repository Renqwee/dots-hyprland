import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    forceWidth: true
    property bool loaded: false
    Component.onCompleted: Qt.callLater(() => { loaded = true })

    ContentSection {
        icon: "toast"
        title: "Bar"

        ConfigSlider {
            text: "Background Opacity"
            buttonIcon: "opacity"
            textWidth: 160
            from: 0.0
            to: 1.0
            value: Config.options.bar.shimmer?.bgOpacityNormal ?? 0.35
            onValueChanged: if (loaded && Config.options.bar.shimmer) Config.options.bar.shimmer.bgOpacityNormal = value
        }
        ConfigSlider {
            text: "Background Hover"
            buttonIcon: "opacity"
            textWidth: 160
            from: 0.0
            to: 1.0
            value: Config.options.bar.shimmer?.bgOpacityHovered ?? 0.45
            onValueChanged: if (loaded && Config.options.bar.shimmer) Config.options.bar.shimmer.bgOpacityHovered = value
        }
        ConfigSlider {
            text: "Shimmer Opacity"
            buttonIcon: "auto_awesome"
            textWidth: 160
            from: 0.0
            to: 1.0
            value: Config.options.bar.shimmer?.opacity ?? 0.35
            onValueChanged: if (loaded && Config.options.bar.shimmer) Config.options.bar.shimmer.opacity = value
        }
        ConfigSlider {
            text: "Width"
            buttonIcon: "width"
            textWidth: 160
            from: 0.1
            to: 1.0
            value: Config.options.bar.shimmer?.width ?? 0.55
            onValueChanged: if (loaded && Config.options.bar.shimmer) Config.options.bar.shimmer.width = value
        }
        ConfigSpinBox {
            text: "Duration (ms)"
            icon: "speed"
            from: 100
            to: 2000
            value: Config.options.bar.shimmer?.duration ?? 600
            onValueChanged: if (loaded && Config.options.bar.shimmer) Config.options.bar.shimmer.duration = value
        }
    }

    ContentSection {
        icon: "call_to_action"
        title: "Dock"

        ConfigSlider {
            text: "Background Opacity"
            buttonIcon: "opacity"
            textWidth: 160
            from: 0.0
            to: 1.0
            value: Config.options.dock.shimmer?.bgOpacityNormal ?? 0.20
            onValueChanged: if (loaded && Config.options.dock.shimmer) Config.options.dock.shimmer.bgOpacityNormal = value
        }
        ConfigSlider {
            text: "Background Hover"
            buttonIcon: "opacity"
            textWidth: 160
            from: 0.0
            to: 1.0
            value: Config.options.dock.shimmer?.bgOpacityHovered ?? 0.30
            onValueChanged: if (loaded && Config.options.dock.shimmer) Config.options.dock.shimmer.bgOpacityHovered = value
        }
        ConfigSlider {
            text: "Shimmer Opacity"
            buttonIcon: "auto_awesome"
            textWidth: 160
            from: 0.0
            to: 1.0
            value: Config.options.dock.shimmer?.opacity ?? 0.35
            onValueChanged: if (loaded && Config.options.dock.shimmer) Config.options.dock.shimmer.opacity = value
        }
        ConfigSlider {
            text: "Width"
            buttonIcon: "width"
            textWidth: 160
            from: 0.1
            to: 1.0
            value: Config.options.dock.shimmer?.width ?? 0.4
            onValueChanged: if (loaded && Config.options.dock.shimmer) Config.options.dock.shimmer.width = value
        }
        ConfigSpinBox {
            text: "Duration (ms)"
            icon: "speed"
            from: 100
            to: 2000
            value: Config.options.dock.shimmer?.duration ?? 600
            onValueChanged: if (loaded && Config.options.dock.shimmer) Config.options.dock.shimmer.duration = value
        }
    }

    ContentSection {
        icon: "grid_view"
        title: "Workspace"

        ConfigSlider {
            text: "Glow Opacity"
            buttonIcon: "flare"
            textWidth: 160
            from: 0.0
            to: 1.0
            value: Config.options.bar.workspaces.shimmer?.glowOpacity ?? 0.9
            onValueChanged: if (loaded && Config.options.bar.workspaces.shimmer) Config.options.bar.workspaces.shimmer.glowOpacity = value
        }
        ConfigSlider {
            text: "Hover Scale"
            buttonIcon: "open_in_full"
            textWidth: 160
            from: 1.0
            to: 2.0
            value: Config.options.bar.workspaces.shimmer?.hoverScale ?? 1.25
            onValueChanged: if (loaded && Config.options.bar.workspaces.shimmer) Config.options.bar.workspaces.shimmer.hoverScale = value
        }
        ConfigSpinBox {
            text: "Hover Duration (ms)"
            icon: "speed"
            from: 50
            to: 1000
            value: Config.options.bar.workspaces.shimmer?.hoverDuration ?? 200
            onValueChanged: if (loaded && Config.options.bar.workspaces.shimmer) Config.options.bar.workspaces.shimmer.hoverDuration = value
        }
    }
}