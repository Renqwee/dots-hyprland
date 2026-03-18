pragma Singleton
import QtQuick
import qs.modules.common

QtObject {
    // Bar
    property real barOpacity: 0.35
    property int barDuration: 600
    property real barWidth: 0.55
    property int barFadeDuration: 200
    property real barBgNormal: 0.35
    property real barBgHovered: 0.45

    // Dock
    property real dockOpacity: 0.35
    property int dockDuration: 600
    property real dockWidth: 0.4
    property int dockFadeDuration: 200

    // Workspace
    property real wsGlowOpacity: 0.9
    property real wsGlowBlur: 1.0
    property int wsGlowBlurMax: 64
    property real wsGlowBrightness: 0.8
    property real wsHoverScale: 1.25
    property real wsHoverLift: 4
    property int wsHoverDuration: 200
}
