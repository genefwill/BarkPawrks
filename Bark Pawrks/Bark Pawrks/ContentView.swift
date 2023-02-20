//
//  ContentView.swift
//  Bark Pawrks
//
//  Created by Matt Kueper on 11/12/22.
//

import SwiftUI
import Foundation

struct ContentView: View {
      @EnvironmentObject var LoggedInViewModel: AuthViewModel
      
      var body: some View {
          if LoggedInViewModel.isUserLoggedIn {
              //MainView()
              MainView(parks: Park.sampleData)
          } else {
              LogInView()
          }
      }
}
