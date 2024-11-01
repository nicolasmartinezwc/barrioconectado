//
//  Data+Extension.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 31/10/2024.
//

import Foundation

extension Data {
    func getFileType() -> String? {
        if starts(with: [0xFF, 0xD8]) {
            return "JPEG"
        } else if starts(with: [0x89, 0x50, 0x4E, 0x47]) {
            return "PNG"
        }
        return nil
    }

    func sizeIsLessThan10MB() -> Bool {
        count <= 10 * 1024 * 1024
    }
}
