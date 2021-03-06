//
//  Api.swift
//  whereismytag
//
//  Created by badinor on 04/05/2022.
//

import Foundation
import MapKit

class Api {
    
    public func getStopPoint(longitude: Double, latitude : Double, dist : Int, details : Bool, completion: @escaping ([Stop]?) -> Void) {

        let url = URL(string:"https://data.mobilites-m.fr/api/linesNear/json?x=\(longitude)&y=\(latitude)&dist=\(dist)&details=\(details)")

        let session = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                if let dataResult = data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let stopsResult = try jsonDecoder.decode([Stop].self, from: dataResult)
                        completion(stopsResult)
                    }
                    catch {
                        print("Error")
                    }
                }
                else {
                    print("No result")
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        session.resume()
    }
}
