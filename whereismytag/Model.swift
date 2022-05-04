//
//  Model.swift
//  whereismytag
//
//  Created by badinor on 04/05/2022.
//

import Foundation
//public class Field: Decodable {
//    var fields: Stop?
//    init(fields:Stop) {
//        self.fields = fields
//    }
//}
//
//public class RecordsContainer: Decodable {
//    var records: [Field]?
//    
//    init(records:[Field]) {
//        self.records = records
//    }
//}

public class Stop: Decodable {
    
    var id: String?
    var name: String?
    var lon: Double?
    var lat: Double?
    var zone: String?
    var lines: [String]?
}
