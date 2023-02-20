//
//  ParkRatingViewModel.swift
//  Bark Pawrks
//
//  Created by Matt Kueper on 11/21/22.
//  Firestore CRUD operation functions based on concepts from:
//  https://www.youtube.com/watch?v=xkxGoNfpLXs
//  last accessed on 11/13/2022

import Foundation
import Firebase

class ParkRatingViewModel: ObservableObject{
    @Published var parkratinglist = [ratings]()
    init(matchid: String){
        
        //func getParkRatings(matchid: String){
        let pawsdb = Firestore.firestore()
            
        //print(matchid)
        pawsdb.collection("ratings").whereField("parkid", isEqualTo: matchid).getDocuments { ratingsData, dberror in
            if dberror == nil{
                if let ratingsData = ratingsData {
                    
                    DispatchQueue.main.async {
                        
                        self.parkratinglist = ratingsData.documents.map { r in
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
        //}
    }
    
}
