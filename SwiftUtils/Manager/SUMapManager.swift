//
//  SUMapManager.swift
//  SwiftUtils
//
//  Created by alvaro.grimal.local on 14/09/2020.
//  Copyright © 2020 Babel. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

final public class SUMapManager {

    // MARK: - Properties

    public static let shared = SUMapManager()
    private var routeOverlay: MKOverlay?
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?

    // MARK: - Public Functions

    public func configureLocationManager(_ locationManagerDelegate: CLLocationManagerDelegate) {

        locationManager = CLLocationManager()

        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = locationManagerDelegate
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }
    }

    public func getCurrentLocation(manager: CLLocationManager) -> CLLocationCoordinate2D? {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return nil }
        currentLocation = locValue
        return currentLocation
    }

    public func createNotation(at coordinate: CLLocationCoordinate2D) -> MKPointAnnotation {
        let notation = MKPointAnnotation()
        let locValue = coordinate
        notation.coordinate = locValue
        return notation
    }

    public func customNotation(_ annotation: MKAnnotation, at mapView: MKMapView, with image: UIImage) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }

        let annotationIdentifier = SUConstants.Map.annotationId
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.image = image

        return annotationView

    }

    public func drawRoute(at map: MKMapView,
                          sourceCoordenate: CLLocationCoordinate2D,
                          destination: CLLocationCoordinate2D,
                          transportType: MKDirectionsTransportType = .walking,
                          completion: @escaping (Error?) -> Void) {
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordenate))
        directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        directionRequest.transportType = transportType

        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in

            guard let directionResponse = response else {
                if let error = error {
                    SUFunctions.print("❌ Error getting direction: \(error.localizedDescription)")
                }
                completion(error)
                return
            }

            if let overlay = self.routeOverlay {
                map.removeOverlay(overlay)
            }

            guard let route = directionResponse.routes.first else {
                completion(error)
                return
            }

            map.addOverlay(route.polyline, level: .aboveRoads)
            self.routeOverlay = route.polyline
            let rect = route.polyline.boundingMapRect
            map.setRegion(MKCoordinateRegion(rect), animated: true)
            completion(nil)
        }
    }

    public func getRendererRoute(lineWidth: CGFloat, color: UIColor, overlay: MKOverlay) -> MKPolylineRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = color
        renderer.lineWidth = lineWidth
        return renderer
    }

    public func getAddressFromGeocodeCoordinate(coordinate: CLLocationCoordinate2D) -> String {
        let geocoder = CLGeocoder()
        var address = ""
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude,
                                                   longitude: coordinate.longitude),
                                        completionHandler: { placemarks, error in
                                            guard let place = placemarks else { return }
                                            if error == nil && !place.isEmpty {
                                                guard let lastPlace = place.last else { return }
                                                let firstPart = "\(String(describing: lastPlace.thoroughfare))"
                                                let secondPart = "\n\(String(describing: lastPlace.postalCode))"
                                                let thirdPart = "\(String(describing: lastPlace.locality))\n\(String(describing: lastPlace.country))"
                                                address = "\(firstPart) \(secondPart)\(thirdPart)"
                                            }
        })
        return address
    }
}
