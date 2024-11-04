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
                if viewModel.isLoadingEvents && viewModel.events.isEmpty {
                    ProgressView()
                        .padding(.top)
                } else if viewModel.events.isEmpty {
                    ContentUnavailableView(
                        "No hay eventos planeados aún...",
                        systemImage: "face.smiling.inverse",
                        description: Text("Se el primero en crear uno!")
                            .font(.system(size: 18))
                    )
                    .padding(.top, 50)
                } else {
                    ForEach(viewModel.events) { event in
                        VStack {
                            HStack {
                                VStack {
                                    HStack {
                                        Text(event.title)
                                            .lineLimit(3)
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundStyle(.black)
                                            .padding(.leading)
                                        Spacer()
                                        Image(systemName: event.category.information.iconName)
                                            .foregroundStyle(event.category.information.iconColor)
                                            .frame(width: 60, height: 60)
                                            .background(event.category.information.iconBackgroundColor)
                                            .clipShape(Circle())
                                            .padding(.horizontal)
                                    }
                                    .padding(.top, 20)
                                    
                                    BCDivider()
                                    
                                    HStack {
                                        Image(systemName: "text.alignleft")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .padding(.trailing)
                                        Text("\(event.description)")
                                            .lineLimit(5)
                                            .font(.system(size: 14))
                                            .foregroundStyle(Color.init(uiColor: .darkGray))
                                        Spacer()
                                    }
                                    .padding(.top, 5)
                                    .padding(.horizontal)

                                    HStack {
                                        Image(systemName: "mappin.and.ellipse")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .padding(.trailing)
                                        Text("\(event.location)")
                                            .lineLimit(3)
                                            .font(.system(size: 14))
                                            .foregroundStyle(Color.init(uiColor: .darkGray))
                                        Spacer()
                                    }
                                    .padding(.top, 5)
                                    .padding(.horizontal)
                                    
                                    HStack {
                                        Image(systemName: "calendar")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .padding(.trailing)
                                        
                                        if event.isFinished() {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Constants.Colors.clearDanger)
                                                .frame(width: 180, height: 25)
                                                .overlay {
                                                    Text("Este evento finalizó")
                                                        .font(.system(size: 14))
                                                        .foregroundStyle(Constants.Colors.darkDanger)
                                                }
                                        } else {
                                            if event.allDay {
                                                Text("El \(event.date), durante todo el día.")
                                                    .lineLimit(3)
                                                    .font(.system(size: 14))
                                                    .foregroundStyle(Color.init(uiColor: .darkGray))
                                            } else {
                                                Text("El \(event.date.components.day!)/\(event.date.components.month!)/\(event.date.components.year!), comienza a las \(event.startsAtHours):\(event.startsAtMinutes)")
                                                    .lineLimit(3)
                                                    .font(.system(size: 14))
                                                    .foregroundStyle(Color.init(uiColor: .darkGray))
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(.top, 5)
                                    .padding(.horizontal)
                                }
                            }
                            
                            BCDivider()
                                .padding(.top, 10)
                            
                            HStack {
                                Text("Organizador: \(event.creator)")
                                    .lineLimit(2)
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color.init(uiColor: .darkGray))
                                Text("-")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.init(uiColor: .darkGray))
                                
                                if event.assistants.count == 1 {
                                    Text("Asistirá \(event.assistants.count) persona")
                                        .lineLimit(2)
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color.init(uiColor: .darkGray))
                                } else {
                                    Text("Asistirán \(event.assistants.count) personas")
                                        .lineLimit(2)
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color.init(uiColor: .darkGray))
                                }
                            }
                            .padding(.top, 10)
                            .padding(.bottom, event.isFinished() ? 20 : 10)
                            .padding(.horizontal)
                            
                            if !event.isFinished() {
                                BCDivider()
                                HStack {
                                    Button {
                                        viewModel.toggleAssistance(for: event)
                                    } label: {
                                        if event.assists() {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Constants.Colors.clearDanger)
                                                .frame(width: 270, height: 30)
                                                .overlay {
                                                    Text("No asistiré")
                                                        .font(.system(size: 16))
                                                        .foregroundStyle(Constants.Colors.darkDanger)
                                                }
                                        } else {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Constants.Colors.nature)
                                                .frame(width: 270, height: 30)
                                                .overlay {
                                                    Text("Asistiré a este evento")
                                                        .font(.system(size: 16))
                                                        .foregroundStyle(Constants.Colors.darkNature)
                                                }
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.top, 10)
                                .padding(.bottom, 20)
                                .padding(.horizontal)
                            }
                        }
                        .background(.white)
                        .padding()                        
                        .clipped()
                        .shadow(color: .black.opacity(0.2), radius: 5, y: 5)
                    }
                }
            }
            .refreshable {
                viewModel.fetchEvents()
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
                                Text("Agregar evento")
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
        .background(Constants.Colors.backgroundDarkGrayColor)
    }
}

#Preview {
    EventsView()
}
