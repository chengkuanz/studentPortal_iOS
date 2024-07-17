//
//  EdpuzzleView.swift
//  studentPortal_ios
//
//  Created by chengkuan zhao on 2024-06-29.
//

import SwiftUI
import WebKit

struct EdpuzzleView: View {
    var url: String
    
    var body: some View {
        WebView(url: url)
            .navigationTitle("Edpuzzle Content")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct WebView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webViewConfiguration = WKWebViewConfiguration()
        
        // Enable media playback capabilities
        webViewConfiguration.allowsInlineMediaPlayback = true
        webViewConfiguration.mediaTypesRequiringUserActionForPlayback = []
        
        let webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        
        // Set the custom user agent string to mimic a desktop browser
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

struct EdpuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        EdpuzzleView(url: "https://edpuzzle.com")
    }
}

