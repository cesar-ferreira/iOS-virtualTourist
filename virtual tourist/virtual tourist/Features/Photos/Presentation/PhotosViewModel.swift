//
//  PhotosViewModel.swift
//  virtual tourist
//
//  Created by César Ferreira on 08/05/21.
//

import Foundation
import UIKit
import CoreData

protocol PhotosViewModelProtocol: class {}

class PhotosViewModel {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    weak var delegate: PhotosViewModelProtocol?
    private let networkManager: NetworkManager
    var myLocation: MyLocation!

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func getPhotos(latitude: Double, longitude: Double) {
        networkManager.getPhotos(latitude: latitude, longitude: longitude, completion: { result in
            switch result {
            case .success(let response):
                for photo in response.photos.photo {
                    self.addPhoto(url: photo.url_m)
                }
            case .failure(let error):
                print(error)
            }
        })
    }

    func addPhoto(url: String) {
        do {
            let photo = MyPhoto(context: context)
            photo.createdDate = Date()
            photo.url = url
            photo.location = self.myLocation

            try self.context.save()
        } catch {
            print("error when trying to add objects from the database")
        }
    }

    func deletePhoto(_ photo: MyPhoto) {
        do {
            self.context.delete(photo)
            try self.context.save()
        } catch {
            print("error when trying to delete objects from the database")
        }
    }

    func removeAllPhotos(photos: [MyPhoto]) {
        for photo in photos {
            self.context.delete(photo)
            do {
                try self.context.save()
            } catch {
                print("error when trying to delete all objects from the database")
            }
        }
    }
}
