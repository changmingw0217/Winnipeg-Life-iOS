//
//  WebView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/21/21.
//

import SwiftUI
import WebKit

struct WebViewUI: UIViewRepresentable {
    
    let url: URL?
    
    func makeUIView(context: Context) -> WKWebView{
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        return WKWebView(frame: .zero, configuration: config)
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let myURL = url else{ return }
        let request = URLRequest(url: myURL)
        webView.load(request)
    }
    
}
