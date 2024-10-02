//
//  UIApplication+Extension.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 30/09/2024.
//

import UIKit

extension UIApplication {
    static func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            fatalError("Could not find a scene for BarrioConectado.")
        }

        guard let root = screen.windows.first?.rootViewController else {
            fatalError("Could not find a root view controller for BarrioConectado.")
        }

        return root
    }
}
