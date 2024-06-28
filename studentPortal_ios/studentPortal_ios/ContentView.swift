// ContentView.swift
// studentPortal_ios
//
// Created by chengkuan zhao on 2024-06-06.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            CoursesView()
                .tabItem {
                    Label("Courses", systemImage: "graduationcap")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


