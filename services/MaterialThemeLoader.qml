pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Io

/**
 * Automatically reloads generated material colors.
 * It is necessary to run reapplyTheme() on startup because Singletons are lazily loaded.
 */
Singleton {
    id: root
    property string filePath: Directories.generatedMaterialThemePath
    property int failedLoadAttempts: 0
    readonly property int maxLoadAttempts: 10
    readonly property int idlePollInterval: 10000

    function reapplyTheme() {
        themeFileView.reload()
    }

    function applyColors(fileContent) {
        let json
        try {
            json = JSON.parse(fileContent)
        } catch (e) {
            // Warn rather than fail silently: colors keeping their previous values looks
            // exactly like the theme working, which is how a stale file goes unnoticed.
            console.warn(`MaterialThemeLoader: could not parse ${root.filePath}: ${e}`)
            return
        }
        for (const key in json) {
            if (json.hasOwnProperty(key)) {
                // Convert snake_case to CamelCase
                const camelCaseKey = key.replace(/_([a-z])/g, (g) => g[1].toUpperCase())
                const m3Key = `m3${camelCaseKey}`
                Appearance.m3colors[m3Key] = json[key]
            }
        }
        
        Appearance.m3colors.darkmode = (Appearance.m3colors.m3background.hslLightness < 0.5)
    }

    function resetFilePathNextTime() {
        resetFilePathNextWallpaperChange.enabled = true
    }

    function retryLoad() {
        // The file is absent on a fresh install and briefly unreadable while the color
        // generation script rewrites it. Retrying has to be self-driven: switching mode
        // passes --noswitch, so the wallpaper path never changes and any signal keyed to
        // it never arrives.
        if (root.failedLoadAttempts < root.maxLoadAttempts) {
            root.failedLoadAttempts++
            if (root.failedLoadAttempts === root.maxLoadAttempts) {
                // Slow down, but never stop. A deleted file takes its watch with it, so
                // polling is the only thing that notices it being written again.
                console.warn(`MaterialThemeLoader: ${root.filePath} unreadable after ${root.failedLoadAttempts} attempts, polling every ${root.idlePollInterval / 1000}s`)
                root.resetFilePathNextTime()
            }
        }
        loadRetryTimer.restart()
    }

    Timer {
        id: loadRetryTimer
        // Back off so a genuinely missing file does not spin: 250ms growing to 4s while
        // the write is plausibly in flight, then a standing poll once it clearly is not.
        interval: root.failedLoadAttempts < root.maxLoadAttempts
            ? Math.min(250 * root.failedLoadAttempts, 4000)
            : root.idlePollInterval
        repeat: false
        running: false
        onTriggered: {
            // Re-resolve the path rather than reload(): a FileView pointed at a file that
            // did not exist stops watching it, so it would never notice the file appearing.
            root.filePath = ""
            root.filePath = Directories.generatedMaterialThemePath
        }
    }

    Connections {
        id: resetFilePathNextWallpaperChange
        enabled: false
        target: Config.options.background
        function onWallpaperPathChanged() {
            root.failedLoadAttempts = 0
            root.filePath = ""
            root.filePath = Directories.generatedMaterialThemePath
            resetFilePathNextWallpaperChange.enabled = false
        }
    }

    Timer {
        id: delayedFileRead
        interval: Config.options?.hacks?.arbitraryRaceConditionDelay ?? 100
        repeat: false
        running: false
        onTriggered: {
            root.applyColors(themeFileView.text())
        }
    }

	FileView { 
        id: themeFileView
        path: Qt.resolvedUrl(root.filePath)
        watchChanges: true
        onFileChanged: {
            this.reload()
            delayedFileRead.start()
        }
        onLoadedChanged: {
            const fileContent = themeFileView.text()
            // Empty while the path is being re-resolved by a retry; not a real load.
            if (fileContent.length === 0) return
            loadRetryTimer.stop()
            root.failedLoadAttempts = 0
            root.applyColors(fileContent)
        }
        onLoadFailed: root.retryLoad();
    }
}
