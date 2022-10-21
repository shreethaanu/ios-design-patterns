
import MapKit

public class BusinessMapViewModel: NSObject {
  
  // MARK: - Properties
  public let coordinate: CLLocationCoordinate2D
  public let image: UIImage
  public let name: String
  public let rating: Double
  public let ratingDescription: String
  
  // MARK: - Object Lifecycle
  public init(coordinate: CLLocationCoordinate2D,
              image: UIImage,
              name: String,
              rating: Double) {
    self.coordinate = coordinate
    self.image = image
    self.name = name
    self.rating = rating
    self.ratingDescription = "\(rating) stars"
  }
}

// MARK: - MKAnnotation
extension BusinessMapViewModel: MKAnnotation {

  public var title: String? {
    return name
  }
  
  public var subtitle: String? {
    return ratingDescription
  }
}

// MARK: - View Conveniences
extension BusinessMapViewModel {
    
  public func configure(_ view: MKAnnotationView) {
    view.canShowCallout = true
    view.image = image
  }
}
