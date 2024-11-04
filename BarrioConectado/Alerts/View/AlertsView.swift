//
//  AlertsView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 03/11/2024.
//

import SwiftUI

struct AlertsView: View {
    @StateObject var viewModel = AlertsViewModel()
    @State private var showAddAlertForm: Bool = false

    var body: some View {
        ZStack {
            ScrollView {
                if viewModel.isLoadingAlerts && viewModel.alerts.isEmpty {
                    ProgressView()
                        .padding(.top)
                } else if viewModel.alerts.isEmpty {
                    ContentUnavailableView(
                        "Aún no hubo alertas tu barrio...",
                        systemImage: "face.smiling.inverse",
                        description: Text("No dudes en crear una cuando la situación lo amerite")
                            .font(.system(size: 18))
                    )
                    .padding(.top, 50)
                } else {
                    BCDivider()
                    ForEach(viewModel.alerts) { alert in
                        VStack {
                            HStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(alert.category == .theft ? Constants.Colors.darkDanger : Color.yellow)
                                    .frame(width: 150, height: 30)
                                    .overlay {
                                        Text(alert.category.spanishName)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(.white)
                                    }
                                Spacer()
                            }
                            .padding(.top)
                            .padding(.leading)
                            
                            
                            HStack {
                                Image(systemName: "text.alignleft")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(.trailing)
                                Text(alert.description)
                                    .lineLimit(5)
                                    .font(.system(size: 16))
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            .padding(.top, 10)
                            .padding(.horizontal)

                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(.trailing)
                                Text(alert.location)
                                    .lineLimit(5)
                                    .font(.system(size: 16))
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            .padding(.top, 10)
                            .padding(.horizontal)
                            
                            HStack {
                                Text("Notificado por: \(alert.creatorName)")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.black)
                                    .padding(.trailing)
                                Spacer()
                                Button {
                                    //
                                } label: {
                                    HStack {
                                        Text("Notificar uso indebido")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(.red.opacity(0.8))
                                        Image(systemName: "exclamationmark.triangle")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(.red)
                                            .padding(.leading, 5)
                                    }
                                }

                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                            .padding(.bottom)
                        }
                        
                        BCDivider()
                    }
                }
            }
            .refreshable {
                viewModel.fetchAlerts()
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showAddAlertForm = true
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Constants.Colors.appColor)
                            .frame(width: 130, height: 30)
                            .overlay {
                                Text("Agregar alerta")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                            .padding([.bottom, .trailing])
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .sheet(isPresented: $showAddAlertForm) {
            CreateAlertView(
                viewModel: viewModel,
                showAddAlertForm: $showAddAlertForm
            )
        }
        .navigationTitle("Alertas")
        .navigationBarTitleDisplayMode(.large)
        .background(Constants.Colors.backgroundDarkGrayColor)
    }
}
