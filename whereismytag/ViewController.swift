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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        descriptionLabel.text = "Where is my TAG?"
        carte.cameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 500) //regler le zoom de la carte.
        
        checkLocationServices() // Check les autorisation et centre le point sur ses coordonnées.
        
        
    }
    
    @IBAction func showTableViewAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customTableViewController = storyboard.instantiateViewController(withIdentifier: "StopListController") as! StopListController
        self.navigationController?.pushViewController(customTableViewController, animated: true)
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
