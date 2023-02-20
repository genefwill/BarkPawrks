//
//  AuthViewModel.swift
//  Bark Pawrks
//
//  Created by Matt Kueper on 11/12/22.
//  Firestore login/authentication functions based on concepts from:
//  https://blog.codemagic.io/google-sign-in-firebase-authentication-using-swift/
//  last accessed on 11/20/2022
//  and also:
//  https://blckbirds.com/post/user-authentication-with-swiftui-and-firebase/
//  ast accessed on 11/20/2022

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

class AuthViewModel: ObservableObject{
    
    var userModel = UserViewModel()
    
    //Track state of user login
    @Published var isUserLoggedIn = false
    @Published var isUserGoogleLoggedIn = false
    @Published var userUid = ""

    
    func googleLogIn() {
        // Check for existing login
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authGoogleUser(for: user, with: error)

            }
        // If user not logged in with google already, try to auth with google
        } else {
            // Get client ID from google info file and set google login configuration
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            let gconfig = GIDConfiguration(clientID: clientID)
            
            // Set view during google login
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            GIDSignIn.sharedInstance.signIn(with: gconfig, presenting: rootViewController) { [unowned self] user, error in
                authGoogleUser(for: user, with: error)

            }
        }
    }
    
    func googleLogOut() {
      // Logout of google
      GIDSignIn.sharedInstance.signOut()
      
      do {
        // Try to logout of firebase and set state
        try Auth.auth().signOut()
        isUserGoogleLoggedIn = false
        isUserLoggedIn = false
        userUid = ""
      } catch {
        //Otherwise show error
      }
    }
    
    private func authGoogleUser(for user: GIDGoogleUser?, with error: Error?) {
        var gUserId = ""
        var  gEmail = ""
        var  gName = ""
        
        //Handle error from google login
        if let error = error {
            //Handle and show msg if error
            return
        }
        //Otherwise get credentials for logged in google user
        guard let googleAuth = user?.authentication else {return}
        guard let idToken = googleAuth.idToken else {return}
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: googleAuth.accessToken)
        
        //Use google credentials to login to firebase
        Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                //Get user parameters for Firestore database from google
                let gUser = user
                gUserId = (gUser?.userID)!
                gEmail = (gUser?.profile?.email)!
                gName = (gUser?.profile?.name)!

                //check if google user doesnt exist in Firestore App user database (new user)
                userModel.userExists(docId: gUserId) { (existingUser: Bool?) in
                    if  !(existingUser!){
                        // if new user, add to database
                        self.userModel.addUsers(docid: gUserId, userid: gEmail, name: gName)
                        print("Added google user to user database")
                    } else {
                        // if not new user, make sure user parameters in firestore database are up to date
                        self.userModel.updateUsers(docid: gUserId, userid: gEmail, name: gName)
                        print("Updated existing google user in user database")
                    }
                }
                
                self.isUserLoggedIn = true
                self.isUserGoogleLoggedIn = true
                self.userUid = gUserId
            }
        }
    }
    
}
