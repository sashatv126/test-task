//
//  UserDefaults.swift
//  test-task
//
//  Created by Владимир on 17.03.2022.
//

import Foundation
enum Keys {
    static let data = "data"
}
struct DataOfFilms : Codable {
    var data : Data?
}
class DataBase {
    static let shared = DataBase()
    let key = Keys.data
    func saveData(data : Data) {
        if let data = try? JSONEncoder().encode(data) {
        UserDefaults.standard.set(data, forKey: Keys.data)
    }
}
    func loadData() -> Data {
        var films = DataOfFilms()
        if let data = UserDefaults.standard.data(forKey: Keys.data) {
            films = try! JSONDecoder().decode(DataOfFilms.self, from: data)
        }
        return films.data ?? Data()
    }
    func Films() -> [FilmsViewModel] {
        let info = try? JSONDecoder().decode([FilmsViewModel].self, from : DataBase.shared.loadData())
        return info ?? [FilmsViewModel]()
    }
}
