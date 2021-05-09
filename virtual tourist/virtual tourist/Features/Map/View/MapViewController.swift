//
//  MapViewController.swift
//  virtual tourist
//
//  Created by César Ferreira on 07/05/21.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, StoryboardInstantiable {

    private let viewModel = MapViewModel()
    private var fetchedResultsController: NSFetchedResultsController<MyLocation>!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    private func setup() {
        self.setupMap()
        setupLabel()
    }

    private func setupLabel() {
        title = "Map"
    }

    private func loading(isLoading: Bool) {
        self.loadingView.isHidden = !isLoading
        self.loadingIndicator.isHidden = !isLoading
        isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
    }

}

// MARK: - MapViewController MapKit

extension MapViewController {

    private func setupMap() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        mapView.delegate = self
        mapView.addGestureRecognizer(longPressRecognizer)

        self.setupFetchedResultsController()
        self.loadMapAnnotations()
    }

    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state != .began {
            return
        }
        let touchPoint = sender.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        viewModel.insertMyLocation(longitude: newCoordinates.longitude, latitude: newCoordinates.latitude)
    }
}

// MARK: - MapViewController CoreData

extension MapViewController {

    private func loadMapAnnotations() {
        self.loading(isLoading: true)

        if let myLocations = fetchedResultsController.fetchedObjects {
            mapView.addAnnotations(myLocations)
            self.loading(isLoading: false)

        }
    }

    private func setupFetchedResultsController() {
        self.loading(isLoading: true)
        let fetchRequest:NSFetchRequest<MyLocation> = MyLocation.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.viewModel.context, sectionNameKeyPath: nil, cacheName: "myLocations")

        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            self.loading(isLoading: false)
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
}

// MARK: - MapViewController NSFetchedResultsControllerDelegate

extension MapViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let myLocation = anObject as? MyLocation else {
            return
        }
        switch type {
        case .insert:
            mapView.addAnnotation(myLocation)
            break
        default: break
        }
    }
}

// MARK: - MapViewController MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation! , animated: true)

        let myLocation: MyLocation = view.annotation as! MyLocation

        let viewController = PhotosViewController.instantiateViewController()
        viewController.myLocation = myLocation
        viewController.modalPresentationStyle = .fullScreen
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }
}
