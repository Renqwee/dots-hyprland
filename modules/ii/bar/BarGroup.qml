import qs.modules.common
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

Item {
    id: root
    property bool vertical: false
    property real padding: 5
    implicitWidth: vertical ? Appearance.sizes.baseVerticalBarWidth : (gridLayout.implicitWidth + padding * 2)
    implicitHeight: vertical ? (gridLayout.implicitHeight + padding * 2) : Appearance.sizes.baseBarHeight
    default property alias items: gridLayout.children
    property bool externalHovered: false

    onExternalHoveredChanged: {
        if (externalHovered) {
            shimmerBar.x = -shimmerBar.width
            shimmerContainer.opacity = 1
            shimmerAnim.restart()
        } else {
            shimmerContainer.opacity = 0
        }
    }
    
    Rectangle {
        id: background
        property bool effectiveHovered: hoverHandler.hovered || root.externalHovered
        anchors {
            fill: parent
            topMargin: root.vertical ? 0 : 4
            bottomMargin: root.vertical ? 0 : 4
            leftMargin: root.vertical ? 4 : 0
            rightMargin: root.vertical ? 4 : 0
        }
        color: {
            let hovered = background.effectiveHovered
            let opHovered = Config.options.bar.shimmer ? Config.options.bar.shimmer.bgOpacityHovered : 0.45
            let opNormal = Config.options.bar.shimmer ? Config.options.bar.shimmer.bgOpacityNormal : 0.35
            return Qt.rgba(0, 0, 0, hovered ? opHovered : opNormal)
        }
        radius: Appearance.rounding.small
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, background.effectiveHovered ? 0.15 : 0.08)

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
        Behavior on border.color {
            ColorAnimation { duration: 150 }
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.3)
            shadowBlur: 0.8
            shadowVerticalOffset: 2
            shadowHorizontalOffset: 0
        }

        // === Shimmer on Hover ===
        Rectangle {
            id: shimmerContainer
            anchors.fill: parent
            radius: background.radius
            color: "transparent"
            clip: false
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: shimmerContainer.width
                    height: shimmerContainer.height
                    radius: background.radius
                }
            }
            opacity: 0
            visible: opacity > 0

            Behavior on opacity {
                NumberAnimation { duration: Config.options.bar.shimmer?.fadeDuration ?? 200 }
            }

            Rectangle {
                id: shimmerBar
                width: background.width * (Config.options.bar.shimmer?.width ?? 0.55)
                height: background.height * 3
                rotation: 15
                y: -background.height
                x: -width

                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, Config.options.bar.shimmer?.opacity ?? 0.35) }
                    GradientStop { position: 1.0; color: "transparent" }
                }

                NumberAnimation {
                    id: shimmerAnim
                    target: shimmerBar
                    property: "x"
                    from: -shimmerBar.width
                    to: background.width + shimmerBar.width
                    duration: Config.options.bar.shimmer?.duration ?? 600
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    GridLayout {
        id: gridLayout
        columns: root.vertical ? 1 : -1
        anchors {
            verticalCenter: root.vertical ? undefined : parent.verticalCenter
            horizontalCenter: root.vertical ? parent.horizontalCenter : undefined
            left: root.vertical ? undefined : parent.left
            right: root.vertical ? undefined : parent.right
            top: root.vertical ? parent.top : undefined
            bottom: root.vertical ? parent.bottom : undefined
            margins: root.padding
        }
        columnSpacing: 4
        rowSpacing: 12
    }

    HoverHandler {
        id: hoverHandler
        onHoveredChanged: {
            if (hovered) {
                shimmerBar.x = -shimmerBar.width
                shimmerContainer.opacity = 1
                shimmerAnim.restart()
            } else {
                shimmerContainer.opacity = 0
            }
        }
    }
}