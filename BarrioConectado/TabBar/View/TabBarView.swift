//
//  TabBarView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 24/09/2024.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            Group {
                NavigationStack {
                    HomeView(selectedTab: $selectedTab)
                }
                .tabItem {
                    Label(
                        title: { Text("Inicio") },
                        icon: { Image(systemName: "house.fill") }
                    )
                }
                .tag(1)
                .badge(0)
                
                NavigationStack {
                    EventsView()
                }
                .tabItem {
                    Label(
                        title: { Text("Eventos") },
                        icon: { Image(systemName: "person.3.fill") }
                    )
                }
                .badge(0)
                .tag(2)

                Text("Alertas")
                    .tabItem {
                        Label(
                            title: { Text("Alertas") },
                            icon: { Image(systemName: "hazardsign.fill") }
                        )
                    }
                    .badge(3)
                    .tag(3)
                
                Text("Intercambios")
                    .tabItem {
                        Label(
                            title: { Text("Intercambios") },
                            icon: { Image(systemName: "repeat") }
                        )
                    }
                    .badge(3)
                    .tag(4)
                
                Text("Logout (Configuracion)")
                    .onTapGesture {
                        AuthManager.instance.logOut()
                    }
                    .tabItem {
                        Label(
                            title: { Text("Configuración") },
                            icon: { Image(systemName: "line.3.horizontal") }
                        )
                    }
                    .tag(5)
            }
            .toolbarBackground(.white, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .tint(Constants.Colors.appColor)
    }
}

#Preview {
    TabBarView()
}
