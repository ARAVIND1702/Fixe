//
//  WebView.swift
//  Fixe
//
//  Created by MRN7BAN on 25/02/26.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Inject JS to hide header, footer, nav, cookie banners — show only main body content
            let js = """
            (function() {
                var selectors = ['header', 'footer', 'nav', '.navbar', '.site-header', '.site-footer',
                                 '.cookie-banner', '.cookie-consent', '#onetrust-banner-sdk',
                                 '.sticky-header', '[role="banner"]', '[role="navigation"]',
                                 '[role="contentinfo"]'];
                selectors.forEach(function(sel) {
                    document.querySelectorAll(sel).forEach(function(el) {
                        el.style.display = 'none';
                    });
                });
                // Remove top padding/margin that headers may have caused
                document.body.style.paddingTop = '0';
                document.body.style.marginTop = '0';
                var main = document.querySelector('main') || document.querySelector('[role="main"]');
                if (main) {
                    main.style.paddingTop = '0';
                    main.style.marginTop = '0';
                }
            })();
            """
            webView.evaluateJavaScript(js, completionHandler: nil)
        }
    }
}
