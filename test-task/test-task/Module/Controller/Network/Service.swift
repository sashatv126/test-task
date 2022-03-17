//
//  Service.swift
//  test-task
//
//  Created by Александр on 16.03.2022.
//

import Foundation

class Service {
    static let shared = Service()
//HTTP requset GET and URLsession
    func urlSeesionload(url : URL, completion : @escaping (Result<Data,Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["accept" : "aplication/json"]
        request.httpBody = nil
        URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                }
                guard let data = data else {return}
                DataBase.shared.saveData(data: data)
                completion(.success(data))
            }
        })
        .resume()
    }
//Decoding data to stuct Films
    func infoLoad (url : URL, responce : @escaping (Films?, Error?) -> Void) {
        Service.shared.urlSeesionload(url: url, completion: {result in
            switch result {
            case .success(let data):
                do {
                    let info = try JSONDecoder().decode(Films.self, from: data)
                    responce(info,nil)
                } catch let jsonError {
                    print(jsonError)
                }
            case .failure(let error):
                print(error.localizedDescription)
                responce(nil,error)
            }
        })
    }
}


