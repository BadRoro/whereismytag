//
//  StopListController.swift
//  whereismytag
//
//  Created by badinor on 06/04/2022.
//

import UIKit

class StopListController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var customTableView: UITableView!

    var datas: [Stop]//import dans depuis l'api
    var api = Api()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let latitude = 45.19130205
        let longitude = 5.71517336
        
        customTableView.delegate = self //??
        customTableView.dataSource = self //??
        
        //Appel API
        loadDatas(longitude: longitude, latitude: latitude, dist: 300, details: true)
        
    }
    
    func loadDatas(longitude : Double, latitude: Double, dist : Int, details: Bool ) {
        
        //Enregistrer les données dans un tableau (datas)
        
        datas = api.getStopPoint(longitude: longitude, latitude: latitude, dist: dist, details: details);
        self.customTableView.reloadData()
    }

    //MARK: - Events Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //?? Une seule section ??
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count //Compte le nombre de ligne
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = "Titre de section"
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
        return 60 //?? Taille du header de la table ??
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let deaultCell = UITableViewCell()
        
        let cell = customTableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! DataTableViewCell
        cell.titleLabel.text = datas[indexPath.row].rawValue
        return cell // créé une cellule en fonction des données dans DataTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = datas[indexPath.row]
        pushViewController(data)
        
        customTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func pushViewController(_ dataVC: DataVC) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var nextViewController: UIViewController!
        
        switch dataVC {
        case .map:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        case .geoloc:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "GeolocationViewController") as! GeolocationViewController
        case .animation:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "AnimationsViewController") as! AnimationsViewController
        case .tableViewWithHeader:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "TableViewMoreViewController") as! TableViewMoreViewController
        case .collectionView:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionViewController
        case .carousel:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "CarouselViewController") as! CarouselViewController
        case .webservice:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "WebServiceViewController") as! WebServiceViewController
        case .avatar:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "AvatarViewController") as! AvatarViewController
        case .imagePicker:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "ImagePickerViewController") as! ImagePickerViewController
        }
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
