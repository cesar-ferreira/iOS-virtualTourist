//
//  Photo.swift
//  virtual tourist
//
//  Created by César Ferreira on 08/05/21.
//

import Foundation
import UIKit

struct Photo: Decodable {

    let id, title, owner, secret, server, url_m: String
    let farm, ispublic, isfriend, isfamily: Int
}
