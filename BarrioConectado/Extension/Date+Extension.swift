//
//  Date+Extension.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 29/10/2024.
//

import Foundation

extension Date {
    var components: DateComponents {
        Calendar.current.dateComponents([.day, .year, .month], from: self)
    }
}
