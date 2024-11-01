//
//  UIImage+Extension.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 01/11/2024.
//

import SwiftUI

extension UIImage {
    func cropAndResize(to size: CGSize) -> UIImage? {
        // Calculamos el rectángulo de recorte
        let originalSize = self.size
        let aspectWidth = size.width / originalSize.width
        let aspectHeight = size.height / originalSize.height
        let aspectRatio = min(aspectWidth, aspectHeight)

        // Nuevos tamaños
        let newSize = CGSize(width: originalSize.width * aspectRatio, height: originalSize.height * aspectRatio)
        
        // Crear el contexto para dibujar
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.draw(in: CGRect(x: (size.width - newSize.width) / 2,
                             y: (size.height - newSize.height) / 2,
                             width: newSize.width,
                             height: newSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}
