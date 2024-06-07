//
//  ContentView.swift
//  studentPortal_ios
//
//  Created by chengkuan zhao on 2024-06-06.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        Text("Hello, world!")
//            .padding()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

import SwiftUI

struct ContentView: View {
    var body: some View {
        //WebView(url: URL(string: "https://www.google.com")!)
        WebView(url: URL(string: "http://localhost:3000")!)
    
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

