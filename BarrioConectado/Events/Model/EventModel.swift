//
//  EventModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 30/10/2024.
//

import SwiftUI

struct EventModel: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let date: Date
    let startsAtHours: Int
    let startsAtMinutes: Int
    let category: EventCategory
    let location: String
    let allDay: Bool
    let creator: String
    let pictureUrl: String?
    let assistants: [String]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        let date = try container.decode(Double.self, forKey: .date)
        self.date = Date(timeIntervalSince1970: date)
        self.startsAtHours = try container.decode(Int.self, forKey: .startsAtHours)
        self.startsAtMinutes = try container.decode(Int.self, forKey: .startsAtMinutes)
        self.category = try container.decode(EventCategory.self, forKey: .category)
        self.location = try container.decode(String.self, forKey: .location)
        self.allDay = try container.decode(Bool.self, forKey: .allDay)
        self.creator = try container.decode(String.self, forKey: .creator)
        self.pictureUrl = try container.decodeIfPresent(String.self, forKey: .pictureUrl)
        self.assistants = try container.decode([String].self, forKey: .assistants)
    }

    init(id: String, title: String, description: String, date: Date, startsAtHours: Int, startsAtMinutes: Int, category: EventCategory, location: String, allDay: Bool, creator: String, pictureUrl: String? = nil, assistants: [String]) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.startsAtHours = startsAtHours
        self.startsAtMinutes = startsAtMinutes
        self.category = category
        self.location = location
        self.allDay = allDay
        self.creator = creator
        self.pictureUrl = pictureUrl
        self.assistants = assistants
    }

    enum CodingKeys: String, CodingKey {
        case id, title, description, date, category, location, creator, assistants
        case startsAtHours = "starts_at_hours"
        case startsAtMinutes = "starts_at_minutes"
        case allDay = "all_day"
        case pictureUrl = "picture_url"
    }
}

struct EventCategoryInformation {
    let spanishName: String
    let iconName: String
    let iconColor: Color
    let iconBackgroundColor: Color
    let description: String
}

enum EventCategory: String, Codable, CaseIterable {
    case party
    case gathering
    case workshop
    case sport
    case cultural
    case kids
    case market
    case music
    case petGathering = "pet_gathering"

    var information: EventCategoryInformation {
        switch self {
        case .party:
            return EventCategoryInformation(
                spanishName: "Celebraciones",
                iconName: "balloon.2.fill",
                iconColor: Constants.Colors.caramel,
                iconBackgroundColor: Constants.Colors.peach,
                description: "Fiestas y celebraciones."
            )
        case .gathering:
            return EventCategoryInformation(
                spanishName: "Juntadas",
                iconName: "person.3.fill",
                iconColor: Color(hex: "#f00514"),
                iconBackgroundColor: Color(hex: "#d19da0"),
                description: "Reuniones informales."
            )
        case .workshop:
            return EventCategoryInformation(
                spanishName: "Talleres",
                iconName: "theatermask.and.paintbrush.fill",
                iconColor: Color(hex: "#98b392"),
                iconBackgroundColor: Color(hex: "#c3dbca"),
                description: "Talleres prácticos, como cocina, arte o tecnología."
            )
        case .sport:
            return EventCategoryInformation(
                spanishName: "Deportes",
                iconName: "figure.volleyball",
                iconColor: Color(hex: "#ebcd09"),
                iconBackgroundColor: Color(hex: "#f3f5a9"),
                description: "Eventos deportivos, como torneos o clases."
            )
        case .cultural:
            return EventCategoryInformation(
                spanishName: "Cultural",
                iconName: "rectangle.inset.filled.and.person.filled",
                iconColor: Color(hex: "#1c211a"),
                iconBackgroundColor: Color(hex: "#94a391"),
                description: "Actividades culturales, como visitas guiadas, proyecciones de cine."
            )
        case .kids:
            return EventCategoryInformation(
                spanishName: "Niños/as",
                iconName: "figure.and.child.holdinghands",
                iconColor: Color(hex: "#000000"),
                iconBackgroundColor: Color(hex: "#a4ceeb"),
                description: "Actividades orientadas a niños, como juegos o fiestas infantiles."
            )
        case .market:
            return EventCategoryInformation(
                spanishName: "Comercio",
                iconName: "takeoutbag.and.cup.and.straw.fill",
                iconColor: Color(hex: "#d6590b"),
                iconBackgroundColor: Color(hex: "#ebb9a4"),
                description: "Mercados o ferias para vender e intercambiar productos."
            )
        case .music:
            return EventCategoryInformation(
                spanishName: "Música",
                iconName: "guitars.fill",
                iconColor: Color(hex: "#47372c"),
                iconBackgroundColor: Color(hex: "#9c855d"),
                description: "Conciertos o eventos de música en vivo."
            )
        case .petGathering:
            return EventCategoryInformation(
                spanishName: "Mascotas",
                iconName: "pawprint.fill",
                iconColor: Color(hex: "#81bfd4"),
                iconBackgroundColor: Color(hex: "#ccdbe0"),
                description: "Reuniones de mascotas."
            )
        }
    }
}
