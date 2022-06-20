//
//  ViewController.swift
//  whereismytag
//
//  Created by badinor on 30/03/2022.
//

import UIKit
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var carte: MKMapView!
    @IBOutlet weak var foundButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var stop: Stop?
    let userPositionAnnotation = MKPointAnnotation()
    var userDestinationAnnotation: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ici on pense bien à dire que le delegate (celui qui va configurer la carte et la gérer) c'est notre vue controlleur, sinon ne va jamais passer dans les fonctions ^^
        carte.delegate = self
        
        // Do any additional setup after loading the view.
//        descriptionLabel.text = "Where is my TAG?"
        userPositionAnnotation.title = "Ma position"
        
        checkLocationServices() // Check les autorisation et centre le point sur ses coordonnées.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let lat = stop?.lat, let lon = stop?.lon {
            self.userDestinationAnnotation = MKPointAnnotation()
            self.userDestinationAnnotation!.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            carte.annotations.forEach { annotation in
                if (annotation.coordinate.latitude != userPositionAnnotation.coordinate.latitude && annotation.coordinate.longitude != userPositionAnnotation.coordinate.longitude ) {
                    carte.removeAnnotation(annotation)
                }
            }
            
            carte.addAnnotation(self.userDestinationAnnotation!)
            
            let sourceCoordinates = userPositionAnnotation.coordinate
            let destinationCoordinates = userDestinationAnnotation!.coordinate
            showRouteOnMap(pickupCoordinate: sourceCoordinates, destinationCoordinate: destinationCoordinates)
        }
    }
    
    @IBAction func showTableViewAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customTableViewController = storyboard.instantiateViewController(withIdentifier: "StopListController") as! StopListController
        customTableViewController.mapViewController = self
        self.navigationController?.pushViewController(customTableViewController, animated: true)
    }
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            //for getting just one route
            if let route = unwrappedResponse.routes.first {
                //show on map
                
                DispatchQueue.main.async {
                    self.carte.addOverlay(route.polyline)
                    //set the map area to show the route
                    let visibleRect = route.polyline.boundingMapRect
                    let customRect = MKMapRect(x: visibleRect.origin.x, y: visibleRect.origin.y - 1000, width: visibleRect.width, height: visibleRect.height + 3000)
                    self.carte.setVisibleMapRect(customRect, animated: true)
                }
            }
            
            //if you want to show multiple routes then you can get all routes in a loop in the following statement
            //for route in unwrappedResponse.routes {}
        }
        
        self.carte.removeOverlays(carte.overlays)
    }
    
    //show and custom the line
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 3.0
        return renderer
    }
    
    //check if the authorization services is ok
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManager()
            checkLocationAuthorization()
        } else{
            showAlert(title: "Alerte", message: "Vous devez autoriser la localisation GPS pour utiliser l'application")
        }
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied:
            showAlert(title: "Alerte", message: "Vous devez autoriser la localisation GPS pour utiliser l'application")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            showAlert(title: "Alerte", message: "Vous devez autoriser la localisation GPS pour utiliser l'application")
            break
        case .authorizedAlways:
            break
            
        }
    }
    
    //verify differents permissions
    func locationManager(_ manager:CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        checkLocationAuthorization()
    }
    
    //update the position of the user when he move and show buses points with itineraire
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.userPositionAnnotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.userPositionAnnotation.title = "Ma position"
            self.carte.addAnnotation(self.userPositionAnnotation)
            
            if self.stop == nil {
                self.centerMap(onLocation: self.userPositionAnnotation.coordinate)
            }
        }
    }
    
    func centerMap(onLocation location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 200, longitudinalMeters: 200)
        carte.setRegion(region,animated: true)
    }
    
}

extension UIViewController {
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message,preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
