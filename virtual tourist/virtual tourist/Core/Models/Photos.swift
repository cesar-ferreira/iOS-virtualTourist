//
//  ResponseData.swift
//  virtual tourist
//
//  Created by César Ferreira on 08/05/21.
//

import Foundation

struct Photos: Decodable {

    let page, pages, perpage: Int
    let total: String
    let photo: [Photo]
}
