//
//  FilmsModel.swift
//  test-task
//
//  Created by Александр on 16.03.2022.
//

import Foundation
struct Films : Decodable{
    let results : [FilmsViewModel]
}
struct FilmsViewModel : Decodable {
    let image : String
    let title : String?
    let description : String
    let resultType : String?
}

