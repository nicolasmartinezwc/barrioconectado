//
//  OnBoardingViewModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 06/10/2024.
//

import SwiftUI

class OnBoardingViewModel: ObservableObject {

    private let models: [OnBoardingModel] = [
        OnBoardingModel(
            imageName: "onboarding1",
            imageSize: CGSize(width: 200, height: 150),
            text: "Barrio Conectado es una plataforma que conecta de manera sencilla, segura y eficaz a los vecinos de un mismo barrio."
        ),
        OnBoardingModel(
            imageName: "onboarding2",
            imageSize: CGSize(width: 200, height: 150),
            text: "Podrás conocer nuevos vecinos, enviar alertas, organizar eventos, buscar trabajos, intercambiar artículos y mucho más."
        ),
        OnBoardingModel(
            imageName: "onboarding3",
            imageSize: CGSize(width: 175, height: 175),
            text: "Es hora de elegir tu barrio. \nNo te preocupes, podrás cambiarlo en cualquier momento."
        )
    ]

    var currentStep = 0
    @Published var model: OnBoardingModel
    @Published var isLastStep: Bool = false

    init() {
        model = models[0]
    }

    func goNext() {
        guard currentStep < 2 else { return }
        currentStep += 1
        model = models[currentStep]
        if currentStep == 2 {
            isLastStep = true
        }
    }

    func goBack() {
        guard currentStep > 0 else { return }
        currentStep -= 1
        model = models[currentStep]
        isLastStep = false
    }
}
