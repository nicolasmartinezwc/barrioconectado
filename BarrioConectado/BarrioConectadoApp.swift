//
//  BarrioConectadoApp.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 13/09/2024.
//

import SwiftUI

@main
struct BarrioConectadoApp: App {
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
