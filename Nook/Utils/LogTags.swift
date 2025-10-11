//
//  LogTags.swift
//  Nook
//
//  Created for Nook
//

import LogOutLoud

/// Extension defining all log tags used throughout Nook.
/// Tags help categorize logs by feature area for easier filtering and debugging.
extension Tag {
    // MARK: - Navigation & Web
    static let navigation = Tag("Navigation")
    static let webView = Tag("WebView")
    static let webContent = Tag("WebContent")

    // MARK: - UI Components
    static let ui = Tag("UI")
    static let sidebar = Tag("Sidebar")
    static let commandPalette = Tag("CommandPalette")
    static let miniWindow = Tag("MiniWindow")
    static let pip = Tag("PictureInPicture")

    // MARK: - Tab Management
    static let tabs = Tag("Tabs")
    static let tabCompositor = Tag("TabCompositor")

    // MARK: - Drag & Drop
    static let dragDrop = Tag("DragDrop")
    static let dragLock = Tag("DragLock")

    // MARK: - Extensions
    static let extensions = Tag("Extensions")

    // MARK: - Managers
    static let manager = Tag("Manager")
    static let browserManager = Tag("BrowserManager")
    static let tabManager = Tag("TabManager")
    static let extensionManager = Tag("ExtensionManager")
    static let splitViewManager = Tag("SplitViewManager")
    static let profileManager = Tag("ProfileManager")
    static let cookieManager = Tag("CookieManager")
    static let cacheManager = Tag("CacheManager")
    static let historyManager = Tag("HistoryManager")
    static let downloadManager = Tag("DownloadManager")
    static let searchManager = Tag("SearchManager")
    static let privacyManager = Tag("PrivacyManager")
    static let findManager = Tag("FindManager")
    static let peekManager = Tag("PeekManager")

    // MARK: - Authentication
    static let auth = Tag("Authentication")
    static let oauth = Tag("OAuth")

    // MARK: - File Operations
    static let fileSelection = Tag("FileSelection")

    // MARK: - Media
    static let fullscreen = Tag("Fullscreen")
    static let video = Tag("Video")

    // MARK: - Models
    static let space = Tag("Space")
    static let profile = Tag("Profile")

    // MARK: - Utilities
    static let window = Tag("Window")
    static let keyboard = Tag("Keyboard")
    static let utils = Tag("Utils")
}
