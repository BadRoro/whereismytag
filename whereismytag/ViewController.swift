//
//  ViewController.swift
//  whereismytag
//
//  Created by badinor on 30/03/2022.
//

import UIKit
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var carte  : MKMapView!
    @IBOutlet weak var foundButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var stop: Stop?
    let userPositionAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        descriptionLabel.text = "Where is my TAG?"
        carte.cameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 500) //regler le zoom de la carte.
        
        checkLocationServices() // Check les autorisation et centre le point sur ses coordonnées.
        
        userPositionAnnotation.coordinate = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude as! Double, longitude: locationManager.location?.coordinate.longitude  as! Double)
        userPositionAnnotation.title = "Ma position"
        
        showRouteOnMap(pickupCoordinate: userPositionAnnotation.coordinate, destinationCoordinate: CLLocationCoordinate2D(latitude: 45.17794, longitude: 5.71025))
        
    }
    
    override func viewDidAppear(_ animated: Bool){
        let userDestinationAnnotation = MKPointAnnotation()
        
        if stop != nil {
            userDestinationAnnotation.coordinate = CLLocationCoordinate2D(latitude: stop?.lat as! Double , longitude: stop?.lon as! Double)
            
            carte.addAnnotation(userDestinationAnnotation)
            //carte.setCenter(userDestinationAnnotation.coordinate, animated: true)
            
            showRouteOnMap(pickupCoordinate: userPositionAnnotation.coordinate, destinationCoordinate: userDestinationAnnotation.coordinate)
            
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
                    self.carte.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
            
            //if you want to show multiple routes then you can get all routes in a loop in the following statement
            //for route in unwrappedResponse.routes {}
        }
        
        self.carte.removeOverlays(carte.overlays)
    }
    
    //this delegate function is for displaying the route overlay and styling it
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         let renderer = MKPolylineRenderer(overlay: overlay)
         renderer.strokeColor = UIColor.red
         renderer.lineWidth = 5.0
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
            //ICI
        }
        
        //        latitudeLabel.text = String(location.coordinate.latitude)
        //        longitudeLabel.text = String(location.coordinate.longitude)
        
        let userPositionAnnotation = MKPointAnnotation()
        userPositionAnnotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        userPositionAnnotation.title = "Ma position"
        carte.addAnnotation(userPositionAnnotation)
        
        carte.setCenter(userPositionAnnotation.coordinate, animated: true)
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
