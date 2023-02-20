//
//  SampleData.swift
//  MainPage
//
//  Created by Genevieve Will on 11/11/22.
//


import Foundation

struct SamplePark {
    var name: String
    var image: String
    var rating: Int
    var location: String
    var distance: Int
}

extension SamplePark {
    static let sampleData: [SamplePark] =
    [
        SamplePark(name: "West Hollywood Dog Park", image: "smallpark2", rating: 3, location: "West Hollywood", distance: 1),
        SamplePark(name: "William S Hart Dog Park", image: "smallpark3", rating: 4, location: "West Hollywood", distance: 1),
        SamplePark(name: "Westwoof Dog Park", image: "smallpark1", rating: 4, location: "Westwood", distance: 3)
    ]
}
