//
//  CreateEventView.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 30/10/2024.
//

import SwiftUI

struct CreateEventView: View {
    @ObservedObject var viewModel: EventsViewModel
    @Binding var showAddEventForm: Bool
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var location: String = ""
    @State private var startsAtHours: Int = 0
    @State private var startsAtMinutes: Int = 0
    @State private var allDay: Bool = false
    @State private var day: Int = 1
    @State private var month: Int = 1
    @State private var year: Int = 2024
    @State private var selectedCategory: EventCategory = .party
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    HStack {
                        Text("Crea un nuevo evento")
                            .font(.title)
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    .padding()
                }
                .background(Color(UIColor.secondarySystemBackground))
                .padding(.bottom, -10)
                
                Form {
                    Section(header: Text("Datos del evento")) {
                        VStack {
                            HStack {
                                Text("Título")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            TextField("Ingresa el título del evento", text: $title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.top)
                        
                        VStack {
                            HStack {
                                Text("Descripción")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            TextField("Ingresa una descripción", text: $description)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.top)
                        
                        Picker("Elige una categoría", selection: $selectedCategory) {
                            ForEach(EventCategory.allCases, id: \.self) { category in
                                HStack {
                                    Image(systemName: category.information.iconName)
                                        .foregroundStyle(category.information.iconColor)
                                        .frame(width: 25, height: 25)
                                        .background(category.information.iconBackgroundColor)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .padding(.leading)
                                    
                                    Text("\(category.information.spanishName)")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                        .padding(.top)
                        
                        HStack {
                            Image(systemName: selectedCategory.information.iconName)
                                .foregroundStyle(selectedCategory.information.iconColor)
                                .frame(width: 40, height: 40)
                                .background(selectedCategory.information.iconBackgroundColor)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .padding(.trailing)
                            Text(selectedCategory.information.description)
                                .font(.system(size: 14))
                                .foregroundStyle(Color.init(uiColor: .darkGray))
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding(.vertical)
                    }
                    
                    Section(header: Text("Fecha")) {
                        Picker("Día", selection: $day) {
                            ForEach(1...31, id: \.self) { day in
                                Text("\(day)")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.black)
                            }
                        }
                        .padding(.bottom, 10)
                        
                        Picker("Mes", selection: $month) {
                            ForEach(1...12, id: \.self) { month in
                                Text("\(month)")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.black)
                            }
                        }
                        .padding(.vertical, 10)
                        
                        Picker("Año", selection: $year) {
                            ForEach(2020...2030, id: \.self) { year in
                                Text("\(year)")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.black)
                                
                            }
                        }
                        .padding(.bottom, 10)
                    }
                    
                    Section(header: Text("Ubicación")) {
                        VStack {
                            HStack {
                                Text("¿Donde queda?")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            TextField("Escribe la dirección", text: $location)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.vertical)
                    }
                    
                    Section(header: Text("Horario")) {
                        if allDay {
                            Toggle(isOn: $allDay) {
                                Text("Dura todo el día")
                            }
                        } else {
                            Toggle(isOn: $allDay) {
                                Text("Dura todo el día")
                            }
                            .padding(.bottom, 10)
                        }
                        
                        if !allDay {
                            Picker("¿A qué hora empieza?", selection: $startsAtHours) {
                                ForEach(0..<24) { hour in
                                    Text("\(hour) hs")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.black)
                                }
                            }
                            .padding(.vertical, 10)
                            
                            Picker("Minutos", selection: $startsAtMinutes) {
                                ForEach(0..<60) { minute in
                                    Text("\(minute)")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.black)
                                }
                            }
                            .padding(.bottom, 10)
                        }
                    }
                    
                    HStack {
                        Text("Finalizar")
                            .font(.system(size: 16))
                            .foregroundStyle(Constants.Colors.appColor)
                        Spacer()
                    }
                    .onTapGesture {
                        Task { @MainActor in
                            if case .success(_) = await viewModel.startCreateEventFlow(
                                title: title,
                                description: description,
                                category: selectedCategory,
                                location: location,
                                startsAtHours: startsAtHours,
                                startsAtMinutes: startsAtMinutes,
                                allDay: allDay,
                                day: day,
                                month: month,
                                year: year
                            ) {
                                viewModel.fetchEvents()
                                showAddEventForm = false
                            }
                        }
                    }
                }
            }

            if let errorMessage = viewModel.errorMessage {
                VStack {
                    Spacer()
                    BCSnackBar(text: errorMessage, color: .red)
                }
            }
        }
    }
}
