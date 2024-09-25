//
//  BarrioConectadoApp.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 13/09/2024.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

// MARK: Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        AuthManager.instance.initializeStatus()
        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct BarrioConectadoApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate // Registers the app delegate
    @StateObject var authManager = AuthManager.instance

    var body: some Scene {
        WindowGroup {
            Group {
                if authManager.hasSession {
                    TabBarView()
                } else {
                    StartView()
                }
            }
            .preferredColorScheme(.light)
        }
    }
}
