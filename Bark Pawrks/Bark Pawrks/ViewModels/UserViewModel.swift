//
//  UserViewModel.swift
//  Bark Pawrks
//
//  Created by Matt Kueper on 10/22/22.
//  Firestore CRUD operation functions based on concepts from:
//  https://www.youtube.com/watch?v=xkxGoNfpLXs
//  last accessed on 11/13/2022

import Foundation
import Firebase

class UserViewModel: ObservableObject{
    @Published var userlist = [users]()
    
    func deleteUsers(deletedUser: users){
        let pawsdb = Firestore.firestore()
        
        pawsdb.collection("users").document(deletedUser.id).delete { dberror in
            if dberror == nil{
                self.getUsers()
            }
            else {
                
            }
        }
    }
    
    func addUsers(
        docid: String,
        userid: String,
        name: String
        ){
        let pawsdb = Firestore.firestore()
        
        pawsdb.collection("users").document(docid).setData([
            "userid":userid,
            "name":name
            ]) { dberror in
            if dberror == nil{
                self.getUsers()
            }
            else {
                
            }
        }
    }
    
    func getUsers(){
        let pawsdb = Firestore.firestore()
        
        pawsdb.collection("users").getDocuments { usersData, dberror in
            if dberror == nil{
                if let usersData = usersData {
                    
                    DispatchQueue.main.async {
                        
                        self.userlist = usersData.documents.map { u in
                            return users(
                                id: u.documentID,
                                userid: u["userid"] as? String ?? "",
                                name: u["name"] as? String ?? ""
                            )
                        }
                    }
                }
            }
            else{
                
            }
        }
    }
    
    func updateUsers(
        docid: String,
        userid: String,
        name: String
        ){
        let pawsdb = Firestore.firestore()
        
        pawsdb.collection("users").document(docid).setData([
            "userid":userid,
            "name":name
            ], merge: true) { dberror in
            if dberror == nil{
                self.getUsers()
            }
            else {
                
            }
        }
    }
    
    func userExists(docId: String, completion: @escaping (_ userExists: Bool?) -> ()){
        let pawsdb = Firestore.firestore()
        let userDoc = pawsdb.collection("users").document(docId)
        var exists = false
        
        userDoc.getDocument { (document, error) in
            if (document?.exists)! {
                print("Google user is in Firestore database already")
                exists = true
                completion(exists)
            } else {
                print("Google user is not in Firestore database (new user)")
                completion(exists)
            }
        }
    }
    
}
