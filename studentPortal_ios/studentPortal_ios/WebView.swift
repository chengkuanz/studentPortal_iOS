//
//  WebView.swift
//  studentPortal_ios
//
//  Created by chengkuan zhao on 2024-06-06.
//

import Foundation
import SwiftUI
import WebKit

struct WebView2: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

