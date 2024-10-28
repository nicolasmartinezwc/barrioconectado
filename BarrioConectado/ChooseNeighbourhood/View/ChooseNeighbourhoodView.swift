//
//  ChooseNeighbourhoodView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 06/10/2024.
//

import SwiftUI

struct ChooseNeighbourhoodView: View {
    @StateObject private var viewModel = ChooseNeighbourhoodViewModel()
    @Environment(\.dismiss) var dismiss
    @Binding var showOnboarding: Bool
    @State private var loadingFlowFinish: Bool = false

    var body: some View {
        ZStack {
            Form {
                Section(header: Text("Elige tu provincia")) {
                    Picker("Selecciona una provincia", selection: $viewModel.selectedProvince) {
                        ForEach(viewModel.provinces) { province in
                            Text(province.name).tag(province as ProvinceModel?)
                        }
                    }
                    .onChange(of: viewModel.selectedProvince) { _, _ in
                        Task {
                            await viewModel.fetchNeighbourhoods()
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(height: 60)
                }
                
                Section(header: Text("Elige tu barrio")) {
                    Picker("Selecciona un barrio", selection: $viewModel.selectedNeighbourhood) {
                        ForEach(viewModel.neighbourhoods) { neighbourhood in
                            Text(neighbourhood.name).tag(neighbourhood as NeighbourhoodModel?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(height: 60)
                }

                Button("Continuar") {
                    Task {
                        loadingFlowFinish = true
                        let neighbourhoodRegistered = await viewModel.finishFlow()
                        loadingFlowFinish = false
                        if neighbourhoodRegistered {
                            showOnboarding = false
                        }
                    }
                }
                .frame(height: 44)
            }
            .disabled(viewModel.isLoading)
            .sheet(isPresented: $viewModel.isLoading) {
                VStack {
                    ProgressView("Cargando provincias y barrios...")
                        .presentationDetents([.height(120)])
                        .interactiveDismissDisabled()
                    Button("Volver") {
                        dismiss()
                    }
                    .buttonStyle(.plain)
                    .padding(.top)
                }
            }
            .sheet(isPresented: $loadingFlowFinish) {
                ProgressView()
                    .presentationDetents([.height(60)])
                    .interactiveDismissDisabled()
            }
            .onAppear {
                Task {
                    await self.viewModel.fetchProvinces()
                }
            }
            .onDisappear {
                viewModel.cancelTasks()
            }
            if let errorMessage = viewModel.errorMessage {
                VStack {
                    BCSnackBar(text: errorMessage, color: .red)
                    Spacer()
                }
            }
        }
        .navigationTitle("Seleccionar barrio")
    }
}

#Preview {
    ChooseNeighbourhoodView(showOnboarding: .constant(false))
}
