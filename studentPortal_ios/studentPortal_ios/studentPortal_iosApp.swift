//
//  studentPortal_iosApp.swift
//  studentPortal_ios
//
//  Created by chengkuan zhao on 2024-06-06.
//

// studentPortal_iosApp.swift
// studentPortal_ios

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct studentPortal_iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State private var isUserAuthenticated = false

    var body: some Scene {
        WindowGroup {
            if isUserAuthenticated {
                ContentView()
            } else {
                LoginView()
                    .onAppear {
                        Auth.auth().addStateDidChangeListener { _, user in
                            if user != nil {
                                isUserAuthenticated = true
                            } else {
                                isUserAuthenticated = false
                            }
                        }
                    }
            }
        }
    }
}
