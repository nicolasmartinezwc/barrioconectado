//
//  EventsView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 30/10/2024.
//

import SwiftUI

struct EventsView: View {
    @StateObject var viewModel = EventsViewModel()
    @State private var showAddEventForm: Bool = false

    var body: some View {
        ZStack {
            ScrollView {
                if viewModel.events.isEmpty {
                    ContentUnavailableView(
                        "No hay eventos planeados aún...",
                        systemImage: "face.smiling.inverse",
                        description: Text("Se el primero en crear uno!")
                            .font(.system(size: 18))
                    )
                    .padding(.top, 50)
                } else {
                    ForEach(viewModel.events) { event in
                    }
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showAddEventForm = true
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Constants.Colors.appColor)
                            .frame(width: 140, height: 30)
                            .overlay {
                                Text("Agregar Evento")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                            .padding([.bottom, .trailing])
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .sheet(isPresented: $showAddEventForm) {
            CreateEventView(
                viewModel: viewModel,
                showAddEventForm: $showAddEventForm
            )
        }
        .navigationTitle("Eventos")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    EventsView()
}
