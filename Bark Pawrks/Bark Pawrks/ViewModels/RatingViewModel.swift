//
//  RatingViewModel.swift
//  Bark Pawrks
//
//  Created by Matt Kueper on 10/26/22.
//  Firestore CRUD operation functions based on concepts from:
//  https://www.youtube.com/watch?v=xkxGoNfpLXs
//  last accessed on 11/13/2022

import Foundation
import Firebase

class RatingViewModel: ObservableObject{
    @Published var ratinglist = [ratings]()
    
    func deleteRatings(deletedRating: ratings){
        let pawsdb = Firestore.firestore()
        
        pawsdb.collection("ratings").document(deletedRating.id).delete { dberror in
            if dberror == nil{
                self.getRatings()
            }
            else {
                
            }
        }
    }
    
    func addRatings(
        parkid: String,
        userid: String,
        creation_date: String,
        update_date: String,
        review: String,
        busy: Bool,
        dogbowl: Bool,
        smalldog: Bool,
        water: Bool,
        leash: Bool,
        seating: Bool,
        balls: Bool,
        trash: Bool,
        muttmitts: Bool,
        bathroom: Bool
        ){
        let pawsdb = Firestore.firestore()
        
        pawsdb.collection("ratings").addDocument(data:[
                "parkid":parkid,
                "userid":userid,
                "creation_date":creation_date,
                "update_date":update_date,
                "review":review,
                "busy":busy,
                "dogbowl":dogbowl,
                "smalldog":smalldog,
                "water":water,
                "leash":leash,
                "seating":seating,
                "balls":balls,
                "trash":trash,
                "muttmitts":muttmitts,
                "bathroom":bathroom
            ]) { dberror in
            if dberror == nil{
                self.getRatings()
            }
            else {
                
            }
        }
    }
    
    func getRatings(){
        let pawsdb = Firestore.firestore()
        
        pawsdb.collection("ratings").getDocuments { ratingsData, dberror in
            if dberror == nil{
                if let ratingsData = ratingsData {
                    
                    DispatchQueue.main.async {
                        
                        self.ratinglist = ratingsData.documents.map { r in
                            return ratings(
                                id: r.documentID,
                                parkid: r["parkid"] as? String ?? "",
                                userid: r["userid"] as? String ?? "",
                                creation_date: r["creation_date"] as? String ?? "",
                                update_date: r["update_date"] as? String ?? "",
                                review: r["review"] as? String ?? "",
                                busy: r["busy"] as? Bool ?? false,
                                dogbowl: r["dogbowl"] as? Bool ?? false,
                                smalldog: r["smalldog"] as? Bool ?? false,
                                water: r["water"] as? Bool ?? false,
                                leash: r["leash"] as? Bool ?? false,
                                seating: r["seating"] as? Bool ?? false,
                                balls: r["balls"] as? Bool ?? false,
                                trash: r["trash"] as? Bool ?? false,
                                muttmitts: r["muttmitts"] as? Bool ?? false,
                                bathroom: r["bathroom"] as? Bool ?? false
                            )
                        }
                    }
                }
            }
            else{
                
            }
        }
    }
    
    func updateRatings(
        updatedRating: ratings,
        parkid: String,
        userid: String,
        creation_date: String,
        update_date: String,
        review: String,
        busy: Bool,
        dogbowl: Bool,
        smalldog: Bool,
        water: Bool,
        leash: Bool,
        seating: Bool,
        balls: Bool,
        trash: Bool,
        muttmitts: Bool,
        bathroom: Bool
        ){
            
        let pawsdb = Firestore.firestore()
        
        pawsdb.collection("ratings").document(updatedRating.id).setData([
            "parkid":parkid,
            "userid":userid,
            "creation_date":creation_date,
            "update_date":update_date,
            "review":review,
            "busy":busy,
            "dogbowl":dogbowl,
            "smalldog":smalldog,
            "water":water,
            "leash":leash,
            "seating":seating,
            "balls":balls,
            "trash":trash,
            "muttmitts":muttmitts,
            "bathroom":bathroom
            ], merge: true) { dberror in
            if dberror == nil{
                self.getRatings()
            }
            else {
                
            }
        }
    }
    
}
