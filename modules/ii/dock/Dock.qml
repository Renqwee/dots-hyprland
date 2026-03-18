import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Io
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects

Scope { // Scope
    id: root
    property bool pinned: Config.options?.dock.pinnedOnStartup ?? false

    Variants {
        // For each monitor
        model: Quickshell.screens

        PanelWindow {
            id: dockRoot
            // Window
            required property var modelData
            screen: modelData
            visible: !GlobalStates.screenLocked

            property bool reveal: root.pinned || (Config.options?.dock.hoverToReveal && dockMouseArea.containsMouse) || dockApps.requestDockShow || (!ToplevelManager.activeToplevel?.activated)

            anchors {
                bottom: true
                left: true
                right: true
            }

            exclusiveZone: root.pinned ? implicitHeight - (Appearance.sizes.hyprlandGapsOut) - (Appearance.sizes.elevationMargin - Appearance.sizes.hyprlandGapsOut) : 0

            implicitWidth: dockBackground.implicitWidth
            WlrLayershell.namespace: "quickshell:dock"
            color: "transparent"

            implicitHeight: (Config.options?.dock.height ?? 70) + Appearance.sizes.elevationMargin + Appearance.sizes.hyprlandGapsOut

            mask: Region {
                item: dockMouseArea
            }

            MouseArea {
                id: dockMouseArea
                height: parent.height
                anchors {
                    top: parent.top
                    topMargin: dockRoot.reveal ? 0 : Config.options?.dock.hoverToReveal ? (dockRoot.implicitHeight - Config.options.dock.hoverRegionHeight) : (dockRoot.implicitHeight + 1)
                    horizontalCenter: parent.horizontalCenter
                }
                implicitWidth: dockHoverRegion.implicitWidth + Appearance.sizes.elevationMargin * 2
                hoverEnabled: true

                Behavior on anchors.topMargin {
                    animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                }

                onEntered: {
                    dockShimmerBar.x = -dockShimmerBar.width
                    dockShimmerContainer.opacity = 1
                    dockShimmerAnim.restart()
                }
                onExited: {
                    dockShimmerContainer.opacity = 0
                }

                Item {
                    id: dockHoverRegion
                    anchors.fill: parent
                    implicitWidth: dockBackground.implicitWidth

                    Item { // Wrapper for the dock background
                        id: dockBackground
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                            horizontalCenter: parent.horizontalCenter
                        }

                        implicitWidth: dockRow.implicitWidth + 5 * 2
                        height: parent.height - Appearance.sizes.elevationMargin - Appearance.sizes.hyprlandGapsOut

                        StyledRectangularShadow {
                            target: dockVisualBackground
                        }
                        Rectangle { // The real rectangle that is visible
                            id: dockVisualBackground
                            property real margin: Appearance.sizes.elevationMargin
                            anchors.fill: parent
                            anchors.topMargin: Appearance.sizes.elevationMargin
                            anchors.bottomMargin: Appearance.sizes.hyprlandGapsOut
                            color: {
                                let hovered = dockMouseArea.containsMouse
                                let opHovered = Config.options.dock.shimmer ? Config.options.dock.shimmer.bgOpacityHovered : 0.30
                                let opNormal = Config.options.dock.shimmer ? Config.options.dock.shimmer.bgOpacityNormal : 0.20
                                return Qt.rgba(0, 0, 0, hovered ? opHovered : opNormal)
                            }
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                            border.width: 1
                            border.color: Appearance.colors.colLayer0Border
                            radius: Appearance.rounding.large
                        }

                        // === Shimmer on Hover ===
                        Rectangle {
                            id: dockShimmerContainer
                            anchors.fill: dockVisualBackground
                            anchors.topMargin: 0
                            anchors.bottomMargin: 0
                            radius: dockVisualBackground.radius
                            color: "transparent"
                            clip: false
                            layer.enabled: true
                            layer.effect: OpacityMask {
                                maskSource: Rectangle {
                                    width: dockShimmerContainer.width
                                    height: dockShimmerContainer.height
                                    radius: dockVisualBackground.radius
                                }
                            }
                            opacity: 0
                            visible: opacity > 0

                            Behavior on opacity {
                                NumberAnimation { duration: Config.options.dock.shimmer?.fadeDuration ?? 200 }
                            }

                            Rectangle {
                                id: dockShimmerBar
                                width: dockShimmerContainer.width * (Config.options.dock.shimmer?.width ?? 0.4)
                                height: dockShimmerContainer.height * 3
                                rotation: 15
                                y: -dockShimmerContainer.height
                                x: -width

                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position: 0.0; color: "transparent" }
                                    GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, Config.options.dock.shimmer?.opacity ?? 0.35) }
                                    GradientStop { position: 1.0; color: "transparent" }
                                }

                                NumberAnimation {
                                    id: dockShimmerAnim
                                    target: dockShimmerBar
                                    property: "x"
                                    from: -dockShimmerBar.width
                                    to: dockShimmerContainer.width + dockShimmerBar.width
                                    duration: Config.options.dock.shimmer?.duration ?? 600
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }

                        RowLayout {
                            id: dockRow
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 3
                            property real padding: 5

                            VerticalButtonGroup {
                                Layout.topMargin: Appearance.sizes.hyprlandGapsOut // why does this work
                                GroupButton {
                                    // Pin button
                                    baseWidth: 35
                                    baseHeight: 35
                                    clickedWidth: baseWidth
                                    clickedHeight: baseHeight + 20
                                    buttonRadius: Appearance.rounding.normal
                                    toggled: root.pinned
                                    onClicked: root.pinned = !root.pinned
                                    contentItem: MaterialSymbol {
                                        text: "keep"
                                        horizontalAlignment: Text.AlignHCenter
                                        iconSize: Appearance.font.pixelSize.larger
                                        color: root.pinned ? Appearance.m3colors.m3onPrimary : Appearance.colors.colOnLayer0
                                    }
                                }
                            }
                            DockSeparator {}
                            DockApps {
                                id: dockApps
                                buttonPadding: dockRow.padding
                            }
                            DockSeparator {}
                            DockButton {
                                Layout.fillHeight: true
                                onClicked: GlobalStates.overviewOpen = !GlobalStates.overviewOpen
                                topInset: Appearance.sizes.hyprlandGapsOut + dockRow.padding
                                bottomInset: Appearance.sizes.hyprlandGapsOut + dockRow.padding
                                contentItem: MaterialSymbol {
                                    anchors.fill: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: parent.width / 2
                                    text: "apps"
                                    color: Appearance.colors.colOnLayer0
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
