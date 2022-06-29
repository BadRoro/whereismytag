//
//  Model.swift
//  whereismytag
//
//  Created by badinor on 04/05/2022.
//

import Foundation

public class Stop: Decodable {
    
    var id: String?
    var name: String?
    var lon: Double?
    var lat: Double?
    var zone: String?
    var lines: [String]?
}
