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
        WKWebView()
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

