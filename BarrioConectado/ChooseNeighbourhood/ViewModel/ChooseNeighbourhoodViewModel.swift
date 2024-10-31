//
//  ChooseNeighbourhoodViewModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 28/10/2024.
//

import Foundation

class ChooseNeighbourhoodViewModel: ObservableObject {
    
    @Published var provinces: [ProvinceModel] = [] {
        didSet {
            selectedProvince = provinces.first
        }
    }

    @Published var neighbourhoods: [NeighbourhoodModel] = [] {
        didSet {
            selectedNeighbourhood = neighbourhoods.first
        }
    }

    @Published var errorMessage: String?
    @Published var selectedProvince: ProvinceModel?
    @Published var selectedNeighbourhood: NeighbourhoodModel?
    @Published var isLoading: Bool = true
    private let provincesURL: URL = URL(string: "https://apis.datos.gob.ar/georef/api/provincias?campos=id,nombre&max=5000")!
    private let baseNeighbourhoodsURL: URL = URL(string: "https://apis.datos.gob.ar/georef/api/municipios?campos=id,nombre&max=5000")!

    @MainActor
    func fetchProvinces() {
        isLoading = true
        Task { [weak self] in
            guard let self else { return }
            let result: Result<ProvincesDecoder, Error> = await NetworkingManager.instance.fetch(from: provincesURL)
            switch result {
            case .success(let provincesDecoder):
                if provincesDecoder.provinces.count > 0 {
                    self.provinces = filterUnusedProvinces(provincesDecoder.provinces).sorted(by: { $0.name < $1.name })
                } else {
                    showErrorMessage(BCError.EmptyProvinces.spanishDescription)
                }
            case .failure(let error):
                showErrorMessage(error.spanishDescription)
            }
            updateLoadingState()
        }
    }
    
    @MainActor
    func fetchNeighbourhoods() {
        neighbourhoods = []
        isLoading = true
        guard let selectedProvince
        else {
            showErrorMessage(BCNetworkingError.DefaultError.spanishDescription)
            return
        }
        let neighbourhoodsURL = buildNeighbourhoodsURL(for: selectedProvince)
        Task { [weak self] in
            guard let self else { return }
            let result: Result<NeighbourhoodsDecoder, Error> = await NetworkingManager.instance.fetch(from: neighbourhoodsURL)
            switch result {
            case .success(let neighbourhoodsDecoder):
                if neighbourhoodsDecoder.neighbourhoods.count > 0 {
                    self.neighbourhoods = neighbourhoodsDecoder.neighbourhoods.sorted(by: { $0.name < $1.name })
                } else {
                    showErrorMessage(BCError.EmptyNeighbourhoods(selectedProvince.name).spanishDescription)
                }
            case .failure(let error):
                showErrorMessage(error.spanishDescription)
            }
            updateLoadingState()
        }
    }

    func finishFlow() async -> Bool {
        guard let selectedProvince,
              let selectedNeighbourhood,
              let uid = AuthManager.instance.currentUserUID
        else {
            return false
        }
        let result = await DatabaseManager.instance.insertNeighbourhood(
            neighbourhoodId: selectedNeighbourhood.id,
            neighbourhoodName: selectedNeighbourhood.name,
            provinceId: selectedProvince.id,
            province: selectedProvince.name,
            for: uid
        )
        switch result {
        case .success(_):
            return true
        case .failure(let error):
            await showErrorMessage(error.spanishDescription)
            return false
        }
    }

    func cancelTasks() {
        isLoading = false
        NetworkingManager.instance.cancelNeighbourhoodsAPITasks()
    }

    @MainActor
    private func updateLoadingState() {
        isLoading = provinces.isEmpty || neighbourhoods.isEmpty
        if errorMessage != nil {
            isLoading = false
        }
    }
    
    private func buildNeighbourhoodsURL(for province: ProvinceModel) -> URL {
        let provinceId = URLQueryItem(name: "provincia", value: province.id)
        let neighbourhoodsURL = baseNeighbourhoodsURL.appending(queryItems: [provinceId])
        return neighbourhoodsURL
    }
    
    @MainActor
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.errorMessage = nil
        }
    }
    
    private func filterUnusedProvinces(_ provinces: [ProvinceModel]) -> [ProvinceModel] {
        var originalProvinces = provinces
        originalProvinces.removeAll { $0.id == "86" || $0.id == "78" }
        return originalProvinces
    }
}


