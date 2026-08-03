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
     * Guards the window selector. An undefined address would be interpolated
     * as the literal "address:undefined", which Hyprland rejects -- and it
     * rejects the whole call, making the failure look like a bad argument
     * elsewhere in the table.
     */
    function hasAddress(address, caller) {
        if (address)
            return true;
        console.warn(`[HyprDispatch] ${caller}: no window address, skipping dispatch`);
        return false;
    }

    /**
     * Focuses a window by its Hyprland address (e.g. "0x55f0a1b2c3").
     */
    function focusWindow(address) {
        if (!root.hasAddress(address, "focusWindow"))
            return;
        Hyprland.dispatch(`hl.dsp.focus({ window = "address:${address}" })`);
    }

    /**
     * Closes a window by its Hyprland address.
     */
    function closeWindow(address) {
        if (!root.hasAddress(address, "closeWindow"))
            return;
        Hyprland.dispatch(`hl.dsp.window.close({ window = "address:${address}" })`);
    }

    /**
     * Moves a window to a workspace without following it there.
     * `follow = false` is the Lua equivalent of the old movetoworkspacesilent;
     * without it the dispatcher switches the view to the target workspace.
     */
    function moveWindowToWorkspace(address, workspace) {
        if (!root.hasAddress(address, "moveWindowToWorkspace"))
            return;
        Hyprland.dispatch(`hl.dsp.window.move({ workspace = ${root.workspaceLiteral(workspace)}, follow = false, window = "address:${address}" })`);
    }
}
