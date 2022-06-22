//
//  StopListController.swift
//  whereismytag
//
//  Created by badinor on 06/04/2022.
//

import UIKit
import CoreLocation

class StopListController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var customTableView: UITableView!

    var mapViewController: ViewController?
    
    var datas: [Stop]?//import dans depuis l'api
    var api = Api()

    var coordinate: CLLocationCoordinate2D!
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = nil
        
        customTableView.delegate = self
        customTableView.dataSource = self
        
        //Appel API
        loadDatas(longitude: coordinate.longitude, latitude: coordinate.latitude, dist: 400, details: true)
    }
    
    func loadDatas(longitude : Double, latitude: Double, dist : Int, details: Bool ) {
        
        //Enregistrer les données dans un tableau (datas) et rafraîchir les données
        
        api.getStopPoint(longitude: longitude, latitude: latitude, dist: dist, details: details, completion: { stopList in
            self.datas = stopList
            
            DispatchQueue.main.async {
                self.customTableView.reloadData()
            }
        })
    }

    //MARK: - Events Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Une seule section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas?.count ?? 0 //Compte le nombre de ligne
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = "Liste des arrêts"
        titleView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        return titleView // met en forme et renvoie titleView en fonction de titleLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60 //Taille du header de la table
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = customTableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! DataTableViewCell
        cell.titleLabel.text = datas?[indexPath.row].name ?? nil
        return cell // créé une cellule en fonction des données dans DataTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stop = datas?[indexPath.row]
        mapViewController?.stop = stop
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
