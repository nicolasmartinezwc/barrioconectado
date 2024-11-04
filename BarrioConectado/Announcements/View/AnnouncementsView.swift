//
//  AnnouncementsView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 01/11/2024.
//

import SwiftUI

struct AnnouncementsView: View {
    @StateObject var viewModel = AnnouncementsViewModel()
    @State private var showAddAnnouncementForm = false

    var body: some View {
        ZStack {
            ScrollView {
                if viewModel.isLoadingAnnouncements && viewModel.announcements.isEmpty {
                    ProgressView()
                        .padding(.top)
                } else if viewModel.announcements.isEmpty {
                    ContentUnavailableView(
                        "No hay anuncios aún...",
                        systemImage: "face.smiling.inverse",
                        description: Text("Se el primero en publicar uno!")
                            .font(.system(size: 18))
                    )
                    .padding(.top, 50)
                } else {
                    ForEach(viewModel.announcements) { announcement in
                        ZStack {
                            VStack {
                                HStack {
                                    Image(systemName: announcement.category.information.iconName)
                                        .foregroundStyle(announcement.category.information.iconColor)
                                        .frame(width: 40, height: 40)
                                        .background(announcement.category.information.iconBackgroundColor)
                                        .clipShape(Circle())
                                        .padding(.horizontal)
                                    Text(announcement.title)
                                        .lineLimit(3)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(.black)
                                        .padding(.trailing)
                                    Spacer()
                                }
                                .padding(.top)
                                
                                BCDivider()
                                
                                HStack {
                                    Image(systemName: "text.alignleft")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing)
                                    Text("\(announcement.description)")
                                        .lineLimit(5)
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color.init(uiColor: .darkGray))
                                    Spacer()
                                }
                                .padding(.top, 10)
                                .padding(.horizontal)
                                
                                HStack {
                                    Image(systemName: "person")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing)
                                    Text("\(announcement.ownerName)")
                                        .lineLimit(1)
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color.init(uiColor: .darkGray))
                                    Spacer()
                                }
                                .padding(.top, 10)
                                .padding(.horizontal)
                                
                                HStack {
                                    Image(systemName: "envelope")
                                        .resizable()
                                        .frame(width: 20, height: 15)
                                        .padding(.trailing)
                                    Text("\(announcement.ownerEmail)")
                                        .lineLimit(2)
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color.init(uiColor: .darkGray))
                                    Spacer()
                                }
                                .padding(.top, 10)
                                .padding(.horizontal)
                                
                                HStack {
                                    Image(systemName: "phone")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing)
                                    if let contactPhone = announcement.contactPhone {
                                        Text("\(contactPhone)")
                                            .lineLimit(2)
                                            .font(.system(size: 14))
                                            .foregroundStyle(Color.init(uiColor: .darkGray))
                                    } else {
                                        Text("-")
                                            .font(.system(size: 14))
                                            .foregroundStyle(Color.init(uiColor: .darkGray))
                                    }
                                    Spacer()
                                }
                                .padding(.top, 10)
                                .padding(.horizontal)
                                .padding(.bottom)
                            }
                            .background(announcement.category.information.iconColor)
                            .padding()
                            .clipped()
                            .shadow(color: .black.opacity(0.2), radius: 5, y: 5)
                            
                            if announcement.owner == AuthManager.instance.currentUserUID {
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button {
                                            viewModel.removeAnnouncement(announcement: announcement)
                                        } label: {
                                            Image(systemName: "xmark")
                                                .foregroundStyle(Constants.Colors.clearDanger)
                                                .frame(width: 30, height: 30)
                                                .background(Constants.Colors.darkDanger)
                                                .clipShape(Circle())
                                        }
                                        .padding(.top, 7)
                                        .padding(.trailing, 10)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
            .refreshable {
                viewModel.fetchAnnouncements()
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showAddAnnouncementForm = true
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Constants.Colors.appColor)
                            .frame(width: 140, height: 30)
                            .overlay {
                                Text("Agregar anuncio")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                            .padding([.bottom, .trailing])
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .sheet(isPresented: $showAddAnnouncementForm) {
            CreateAnnouncementView(
                viewModel: viewModel,
                showAddAnnouncementForm: $showAddAnnouncementForm
            )
        }
        .navigationTitle("Anuncios")
    }
}
