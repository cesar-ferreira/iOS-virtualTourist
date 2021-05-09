//
//  PhotosViewController.swift
//  virtual tourist
//
//  Created by César Ferreira on 08/05/21.
//

import UIKit
import MapKit
import CoreData

class PhotosViewController: UIViewController, StoryboardInstantiable {

    var myLocation: MyLocation!

    private let viewModel = PhotosViewModel()
    private var fetchedResultsController: NSFetchedResultsController<MyPhoto>!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    private func setup() {
        self.setupLabel()
        self.setupViewModel()
        self.setupCollectionView()
        self.setupMap()
        self.setupLayout()
        self.setupFetchedResultsController()
        self.checksStorage()
    }

    private func setupLabel() {
        title = "Photos"
    }

    private func setupViewModel() {
        viewModel.myLocation = self.myLocation
    }

    private func setupCollectionView() {
        self.myCollectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.reuseIdentifier)

        self.myCollectionView.dataSource = self
        self.myCollectionView.delegate = self
    }

    private func setupMap() {
        self.mapView.addAnnotation(myLocation)
        let span = MKCoordinateSpan(latitudeDelta: 0.10, longitudeDelta: 0.10)
        let region = MKCoordinateRegion(center: myLocation.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        self.mapView.isUserInteractionEnabled = false
    }

    private func setupLayout() {
        let space: CGFloat = 20.0
        let dimension = (view.frame.size.width - (2 * space)) / 2
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0

        layout.itemSize = CGSize(width: dimension, height: dimension)
        self.myCollectionView.collectionViewLayout = layout
    }

    @IBAction func refreshButtonTapped(_ sender: Any) {
        if let photos = fetchedResultsController.fetchedObjects {
            self.viewModel.removeAllPhotos(photos: photos)
        }
        self.getPhotos()
    }

    private func getPhotos() {
        self.loading(isLoading: true)
        self.viewModel.getPhotos(latitude: self.myLocation.latitude, longitude: self.myLocation.longitude)
    }

    private func loading(isLoading: Bool) {
        self.loadingView.isHidden = !isLoading
        self.loadingIndicator.isHidden = !isLoading
        isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
    }

}

// MARK: - MapViewController CoreData

extension PhotosViewController {

    private func setupFetchedResultsController() {
        self.loading(isLoading: true)

        let fetchRequest: NSFetchRequest<MyPhoto> = MyPhoto.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        let predicate = NSPredicate(format: "location == %@", self.myLocation)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.viewModel.context, sectionNameKeyPath: nil, cacheName: "photos")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            self.loading(isLoading: false)

        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

    private func checksStorage() {
        refreshButton.isUserInteractionEnabled = false
        if (fetchedResultsController.sections?[0].numberOfObjects ?? 0 == 0) {
            self.getPhotos()
        } else {
            refreshButton.isUserInteractionEnabled = true
        }
    }
}

// MARK: - PhotosViewController UICollectionViewDataSource


extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.reuseIdentifier, for: indexPath) as! MyCollectionViewCell
        let photo = fetchedResultsController.object(at: indexPath)
        print(photo)
        cell.backgroundColor = .black
        cell.configureCollectionCell(with: photo.url ?? "")

        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}


extension PhotosViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.myCollectionView.insertItems(at: [newIndexPath!])
            self.loading(isLoading: false)

            break
        case .delete:
            self.myCollectionView.deleteItems(at: [indexPath!])
            break
        default: ()
        }
    }
}
