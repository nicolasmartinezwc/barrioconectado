//
//  BarrioConectadoApp.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 13/09/2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct BarrioConectadoApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    private var hasSession: Bool = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasSession {
                    TabBarView()
                } else {
                    StartView()
                }
            }
            .preferredColorScheme(.light)
        }
    }
}
