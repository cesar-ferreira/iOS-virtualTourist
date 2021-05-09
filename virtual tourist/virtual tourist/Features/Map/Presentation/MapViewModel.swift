//
//  MapViewModel.swift
//  virtual tourist
//
//  Created by César Ferreira on 08/05/21.
//

import Foundation
import UIKit
import CoreData

protocol MapViewModelProtocol: class {}

class MapViewModel {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    weak var delegate: MapViewModelProtocol?
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func insertMyLocation(longitude: Double, latitude: Double) {
        do {
            let myLocation = MyLocation(context: context)
            myLocation.longitude = longitude
            myLocation.latitude = latitude
            myLocation.createdDate = Date()
            try context.save()
        } catch  {
            print("error when trying to add objects from the database")
        }
    }
}
