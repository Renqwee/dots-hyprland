pragma Singleton
import Quickshell
import Quickshell.Hyprland

/**
 * Hyprland dispatchers for a Lua config root (Hyprland >= 0.55).
 *
 * On a Lua root, `hyprctl dispatch` no longer accepts the classic
 * `dispatcher args` form -- the argument is a Lua expression evaluated as
 * `hl.dispatch(...)`. Quickshell's Hyprland.dispatch() goes through the same
 * path, so every call site has to send Lua. Building the expressions here
 * keeps that syntax in one place.
 */
Singleton {
    id: root

    /**
     * Formats a workspace for a Lua table field.
     * Numeric ids pass through bare; relative selectors like "r+1" are strings
     * and must stay quoted, otherwise Lua parses them as arithmetic.
     */
    function workspaceLiteral(workspace) {
        return (typeof workspace === "number") ? `${workspace}` : `"${workspace}"`;
    }

    /**
     * Focuses a workspace. Accepts a numeric id or a selector such as "r+1".
     */
    function focusWorkspace(workspace) {
        Hyprland.dispatch(`hl.dsp.focus({ workspace = ${root.workspaceLiteral(workspace)} })`);
    }

    /**
     * Focuses a window by its Hyprland address (e.g. "0x55f0a1b2c3").
     */
    function focusWindow(address) {
        Hyprland.dispatch(`hl.dsp.focus({ window = "address:${address}" })`);
    }

    /**
     * Closes a window by its Hyprland address.
     */
    function closeWindow(address) {
        Hyprland.dispatch(`hl.dsp.window.close({ window = "address:${address}" })`);
    }

    /**
     * Moves a window to a workspace.
     * There is no `follow` argument in the Lua API, so whether focus follows
     * the window is whatever the dispatcher does by default.
     */
    function moveWindowToWorkspace(address, workspace) {
        Hyprland.dispatch(`hl.dsp.window.move({ workspace = ${root.workspaceLiteral(workspace)}, window = "address:${address}" })`);
    }
}
