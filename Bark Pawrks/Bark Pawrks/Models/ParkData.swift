//
//  LocationData.swift
//  BarkPawrks
//
//  Created by Naser Sadat on 10/30/22.
//  Copyright © 2022 BarkPawrks. All rights reserved.
//

import Foundation

struct Root: Codable {
    let businesses: [Park]
}

struct Park: Codable, Identifiable {
    let id: String
    let name: String
    let image_url: String
    var address: String {
        return "\(location.address1), \(location.city), \(location.state) \(location.zip_code)"
    }
    let location: Address
    var distanceinmiles: Double {
        return distance / 1609.34
    }
    let distance: Double
    let rating: Double
}


struct Address: Codable {
    let address1: String?
    let city: String
    let zip_code:String
    let state: String
}

let address1 = Address(address1: "1500 Houser Way S", city: "Renton", zip_code: "98058", state: "WA")
let address2 = Address(address1: "23675 SE Tahoma Way", city: "Maple Valley", zip_code: "98038", state: "WA")
let address3 = Address(address1: "16200 42nd Ave S", city: "Tukwila", zip_code: "98188", state: "WA")


extension Park {
    
    
    static let sampleData: [Park] =
    [
        Park(id: "G4bWBejxNTDGBpVQc-BvJg", name: "Cedar River Dog Park", image_url: "https://s3-media1.fl.yelpcdn.com/bphoto/9cHfMctjPKKFbBUKTS2d0A/o.jpg",location: address1, distance: 8179.853672645423, rating:3.0),
        Park(id: "TdCqiJW7HXqEGJVv93a-ng", name: "Summit Dog Park", image_url: "https://s3-media2.fl.yelpcdn.com/bphoto/ou-BjQkIkcsU09WulyDplQ/o.jpg",location: address2, distance: 11173.691117707893, rating:3.0),
        Park(id: "A_uKXtoGXXQyj41TBpl9ZQ", name: "Crestview Off-Leash Dog Park", image_url: "https://s3-media2.fl.yelpcdn.com/bphoto/caF-4vlXcGhAh_8bQ83sfA/o.jpg",location: address3, distance: 12349.426964584234, rating:3.0),
    ]
}
