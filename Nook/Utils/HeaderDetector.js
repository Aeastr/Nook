// HeaderDetector.js
// Detects website headers/navigation bars and reports their bounds for draggable window overlay

(function () {
  "use strict";
  console.log('[WEBHEADERDRAG] HeaderDetector.js loaded');

  // Common header/nav selectors ordered by priority
  const HEADER_SELECTORS = [
    'header[role="banner"]',
    'nav[role="navigation"]',
    '[role="banner"]',
    '[role="navigation"]',
    'header',
    'nav',
    '.header',
    '.navbar',
    '.nav-bar',
    '.navigation',
    '.site-header',
    '.main-header',
    '.top-bar',
    '#header',
    '#navbar',
    '#navigation',
  ];

  function detectHeader() {
    console.log('[WEBHEADERDRAG] Detecting header...');
    // Try each selector in order
    for (const selector of HEADER_SELECTORS) {
      const elements = document.querySelectorAll(selector);

      for (const element of elements) {
        const rect = element.getBoundingClientRect();

        // Check if element is visible and at top of page
        // Must be at least 30px tall and span more than 50% of viewport width
        const isAtTop = rect.top <= 50;
        const isWideEnough = rect.width > window.innerWidth * 0.5;
        const isTallEnough = rect.height >= 30 && rect.height <= 200;
        const isVisible = rect.height > 0 && rect.width > 0;

        if (isVisible && isAtTop && isWideEnough && isTallEnough) {
          console.log(`[WEBHEADERDRAG] Header detected! Selector: ${selector}, Bounds:`, rect);
          return {
            x: rect.left,
            y: rect.top,
            width: rect.width,
            height: rect.height,
            selector: selector,
          };
        }
      }
    }

    console.log('[WEBHEADERDRAG] No header detected');
    return null;
  }

  function sendHeaderBounds(bounds) {
    if (window.webkit &&
        window.webkit.messageHandlers &&
        window.webkit.messageHandlers.headerBounds) {
      console.log('[WEBHEADERDRAG] Sending header bounds to native:', bounds);
      window.webkit.messageHandlers.headerBounds.postMessage(bounds || {
        x: 0,
        y: 0,
        width: 0,
        height: 0,
        selector: null
      });
    } else {
      console.log('[WEBHEADERDRAG] ⚠️ Message handler not available');
    }
  }

  function detectAndReport() {
    const bounds = detectHeader();
    sendHeaderBounds(bounds);
  }

  // Initial detection after page load
  console.log('[WEBHEADERDRAG] Document readyState:', document.readyState);
  if (document.readyState === "loading") {
    console.log('[WEBHEADERDRAG] Waiting for DOMContentLoaded...');
    document.addEventListener("DOMContentLoaded", () => {
      console.log('[WEBHEADERDRAG] DOMContentLoaded fired, detecting in 100ms');
      // Delay slightly to ensure layout is stable
      setTimeout(detectAndReport, 100);
    });
  } else {
    console.log('[WEBHEADERDRAG] Document already loaded, detecting in 100ms');
    setTimeout(detectAndReport, 100);
  }

  // Re-detect on resize
  let resizeTimeout;
  window.addEventListener("resize", () => {
    clearTimeout(resizeTimeout);
    resizeTimeout = setTimeout(detectAndReport, 150);
  }, { passive: true });

  // Watch for dynamic DOM changes (for SPAs)
  const observer = new MutationObserver(() => {
    // Debounce mutations
    clearTimeout(window.headerDetectionTimeout);
    window.headerDetectionTimeout = setTimeout(detectAndReport, 300);
  });

  observer.observe(document.body || document.documentElement, {
    childList: true,
    subtree: true,
  });
})();
