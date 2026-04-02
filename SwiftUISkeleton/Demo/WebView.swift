//
//  WebView.swift
//  SwiftUIDemos
//
//  Created by bo.liu on 2026/4/2.
//


import SwiftUI
import WebKit

// MARK: - 使用示例（WebView + 骨架屏）
struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    let reloadTrigger: Int
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if reloadTrigger != context.coordinator.lastReloadTrigger {
            webView.reload()
            context.coordinator.lastReloadTrigger = reloadTrigger
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView
        var lastReloadTrigger: Int = 0
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
    }
}
