//
//  NetworkingManager.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 28/10/2024.
//

import Foundation

struct NetworkingManager {
    private let neighbourhoodsAPIHost = "apis.datos.gob.ar"
    static let instance: NetworkingManager = NetworkingManager()

    private init() { }

    func fetch<T: Decodable>(from url: URL) async -> Result<T, Error> {
        let request = URLRequest(
            url: url,
            cachePolicy: .returnCacheDataElseLoad,
            timeoutInterval: 10
        )
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                return .failure(BCNetworkingError.StatusCodeError(httpResponse.statusCode))
            }
            let result = try JSONDecoder().decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }

    func cancelNeighbourhoodsAPITasks() {
        URLSession.shared.getAllTasks { tasks in
            tasks.forEach { task in
                if let host = task.originalRequest?.url?.host(), host == self.neighbourhoodsAPIHost {
                    task.cancel()
                }
            }
        }
    }
}
