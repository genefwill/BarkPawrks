//
//  ratings.swift
//  Bark Pawrks
//
//  Created by Matt Kueper on 10/26/22.
//

import Foundation

struct ratings: Identifiable {
    var id: String
    var parkid: String
    var userid: String
    var creation_date : String
    var update_date: String
    var review: String
    var busy: Bool
    var dogbowl: Bool
    var smalldog: Bool
    var water: Bool
    var leash: Bool
    var seating: Bool
    var balls: Bool
    var trash: Bool
    var muttmitts: Bool
    var bathroom: Bool
}
