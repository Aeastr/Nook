//
//  HeaderDragOverlay.swift
//  Nook
//
//  Created by Aether Aurelia on 12/10/2025.
//

import AppKit
import SwiftUI

/// An overlay view that enables window dragging over detected website headers
/// Positioned dynamically based on JavaScript-detected header bounds
class HeaderDragOverlay: NSView {
    private var isDragging = false

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true

        // Debug mode: show overlay in red
        self.layer?.backgroundColor = NSColor.red.withAlphaComponent(0.3).cgColor
        print("[WEBHEADERDRAG] HeaderDragOverlay initialized")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func mouseDown(with event: NSEvent) {
        // Capture mouse down for drag detection
        isDragging = false
        print("[WEBHEADERDRAG] mouseDown detected")

        if let window = self.window {
            // Check if this is a single click (not a drag)
            let mouseLocation = event.locationInWindow
            let viewLocation = self.convert(mouseLocation, from: nil)
            print("[WEBHEADERDRAG] Mouse location: \(viewLocation), bounds: \(self.bounds)")

            // If the click is within our bounds, initiate window drag
            if self.bounds.contains(viewLocation) {
                print("[WEBHEADERDRAG] Initiating window drag")
                window.performDrag(with: event)
                isDragging = true
            }
        }

        // If we didn't start dragging, pass the event through
        if !isDragging {
            print("[WEBHEADERDRAG] Not dragging, passing event through")
            super.mouseDown(with: event)
        }
    }

    override func mouseDragged(with event: NSEvent) {
        if isDragging {
            // Window is being dragged, consume the event
            return
        }
        super.mouseDragged(with: event)
    }

    override func mouseUp(with event: NSEvent) {
        if isDragging {
            isDragging = false
            // Consume the event after drag
            return
        }
        super.mouseUp(with: event)
    }

    /// Update the overlay position and size based on detected header bounds
    func updateBounds(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        // The y coordinate from JavaScript is from top, but NSView uses bottom-left origin
        // We need to flip it relative to the window height
        guard let window = self.window else {
            print("[WEBHEADERDRAG] updateBounds called but no window available")
            return
        }

        let windowHeight = window.contentView?.bounds.height ?? 0
        let flippedY = windowHeight - y - height

        self.frame = NSRect(x: x, y: flippedY, width: width, height: height)
        print("[WEBHEADERDRAG] Updated bounds to: \(self.frame)")
    }

    /// Hide the overlay by setting zero frame
    func hide() {
        print("[WEBHEADERDRAG] Hiding overlay")
        self.frame = .zero
        self.isHidden = true
    }

    /// Show the overlay
    func show() {
        print("[WEBHEADERDRAG] Showing overlay at frame: \(self.frame)")
        self.isHidden = false
    }

    // Allow clicks to pass through when not over the header
    override func hitTest(_ point: NSPoint) -> NSView? {
        // Only capture hits within our frame
        if self.bounds.contains(point) {
            return self
        }
        return nil
    }
}

/// SwiftUI wrapper for HeaderDragOverlay
struct HeaderDragOverlayView: NSViewRepresentable {
    let bounds: CGRect?

    func makeNSView(context: Context) -> HeaderDragOverlay {
        let overlay = HeaderDragOverlay()
        return overlay
    }

    func updateNSView(_ nsView: HeaderDragOverlay, context: Context) {
        if let bounds = bounds {
            nsView.updateBounds(
                x: bounds.origin.x,
                y: bounds.origin.y,
                width: bounds.size.width,
                height: bounds.size.height
            )
            nsView.show()
        } else {
            nsView.hide()
        }
    }
}
