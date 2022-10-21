

import MapKit
import YelpAPI

public class ViewController: UIViewController {
  
  // MARK: - Properties
  public let annotationFactory = AnnotationFactory()
  public var businesses: [YLPBusiness] = []
  private let client = YLPClient(apiKey: YelpAPIKey)
  private let locationManager = CLLocationManager()
  
  // MARK: - Outlets
  @IBOutlet public weak var mapView: MKMapView! {
    didSet {
      mapView.showsUserLocation = true
    }
  }
  
  // MARK: - View Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()

    DispatchQueue.main.async { [weak self] in
      self?.locationManager.requestWhenInUseAuthorization()
    }
  }
  
  // MARK: - Actions
  @IBAction func businessFilterToggleChanged(_ sender: UISwitch) {
    
  }
}

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
  
  public func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    centerMap(on: userLocation.coordinate)
  }
  
  private func centerMap(on coordinate: CLLocationCoordinate2D) {
    let regionRadius: CLLocationDistance = 3000
    let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                              latitudinalMeters: regionRadius,
                                              longitudinalMeters: regionRadius)
    mapView.setRegion(coordinateRegion, animated: true)
    searchForBusinesses()
  }
  
  private func searchForBusinesses() {
    let coordinate = mapView.userLocation.coordinate
    guard coordinate.latitude != 0 && coordinate.longitude != 0 else {
      return
    }
    
    let yelpCoordinate = YLPCoordinate(latitude: coordinate.latitude,
                                       longitude: coordinate.longitude)
    
    client.search(with: yelpCoordinate, term: "coffee", limit: 35, offset: 0, sort: .bestMatched) {
      [weak self] (searchResult, error) in
      
      guard let self = self else { return }
      guard let searchResult = searchResult,
        error == nil else {
          print("Search failed: \(String(describing: error))")
          return
      }
      self.businesses = searchResult.businesses
      DispatchQueue.main.async {
        self.addAnnotations()
      }
    }
  }
  
  private func addAnnotations() {
    for business in businesses {
      guard let viewModel = annotationFactory.createBusinessMapViewModel(for: business) else {
        continue
      }

      mapView.addAnnotation(viewModel)
    }
  }
  
  public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let viewModel = annotation as? BusinessMapViewModel else {
      return nil
    }

    let identifier = "business"
    let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) ??
      MKAnnotationView(annotation: viewModel, reuseIdentifier: identifier)
    viewModel.configure(annotationView)
    return annotationView
  }
}
