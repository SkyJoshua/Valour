using Valour.Shared.Utilities;

namespace Valour.Client.Utility;

public enum TimestampFormat
{
    TwelveHour,
    TwentyFourHour,
    Relative
}

public static class ClientFlags
{
    public static bool GhostTyping { get; set; } = false;
    public static bool ShowDeletedMessages { get; set; } = true;
    public static bool ShowEditHistory { get; set; } = true;
    /// <summary>
    /// Always on - knowing who else is on the modded client isn't optional here, so this
    /// isn't exposed as a user-facing toggle.
    /// </summary>
    public const bool ShowModdedBadge = true;
    public static bool AlwaysShowTimestamps { get; set; } = false;
    public static TimestampFormat TimestampFormat { get; set; } = TimestampFormat.TwelveHour;

    /// <summary>
    /// The language messages are translated into via the message right-click "Translate" option.
    /// </summary>
    public static string TranslateLanguage { get; set; } = "en";

    /// <summary>
    /// Fired when a flag affecting already-rendered messages changes, so
    /// mounted MessageComponents can recompute and re-render immediately
    /// instead of waiting for their next natural render.
    /// </summary>
    public static HybridEvent Changed;

    public static void NotifyChanged() => Changed?.Invoke();
}
