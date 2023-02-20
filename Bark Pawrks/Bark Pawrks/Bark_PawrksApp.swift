//
//  Bark_PawrksApp.swift
//  Bark Pawrks
//
//  Created by Amelia Martin on 10/28/22.
//

import SwiftUI
import Firebase
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct Bark_PawrksApp: App {
    // Tracking for user logged in view google
    @StateObject var LoggedInViewModel = AuthViewModel()
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(LoggedInViewModel)
            }
        }
    }
}
