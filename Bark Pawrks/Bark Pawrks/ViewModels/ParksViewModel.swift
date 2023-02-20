//
//  ParkViewModel.swift
//  Bark Pawrks
//
//  Created by Matt Kueper on 10/26/22.
//  Firestore CRUD operation functions based on concepts from:
//  https://www.youtube.com/watch?v=xkxGoNfpLXs
//  last accessed on 11/13/2022

import Foundation
import Firebase

class ParkViewModel: ObservableObject{
    @Published var parklist = [parks]()
    
    func deleteParks(deletedPark: parks){
        let pawsdb = Firestore.firestore()
        
        pawsdb.collection("parks").document(deletedPark.id).delete { dberror in
            if dberror == nil{
                self.getParks()
            }
            else {
                
            }
        }
    }
    
    func addParks(
        placeid: String,
        name: String,
        ratings: String
        ){
        let pawsdb = Firestore.firestore()
        
        pawsdb.collection("parks").addDocument(data: [
            "placeid":placeid,
            "name":name,
            "ratings":ratings
            ]) { dberror in
            if dberror == nil{
                self.getParks()
            }
            else {
                
            }
        }
    }
    
    func getParks(){
        let pawsdb = Firestore.firestore()
        
        pawsdb.collection("parks").getDocuments { parksData, dberror in
            if dberror == nil{
                if let parksData = parksData {
                    
                    DispatchQueue.main.async {
                        
                        self.parklist = parksData.documents.map { p in
                            return parks(
                                id: p.documentID,
                                placeid: p["placeid"] as? String ?? "",
                                name: p["name"] as? String ?? "",
                                ratings: p["ratings"] as? String ?? ""
                            )
                        }
                    }
                }
            }
            else{
                
            }
        }
    }
    
    func updateParks(
        updatedPark: parks,
        placeid: String,
        name: String,
        ratings: String
        ){
        let pawsdb = Firestore.firestore()
        
        pawsdb.collection("parks").document(updatedPark.id).setData([
            "placeid": placeid,
            "name":name,
            "ratings":ratings
            ], merge: true) { dberror in
            if dberror == nil{
                self.getParks()
            }
            else {
                
            }
        }
    }
    
}
