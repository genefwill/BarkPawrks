//
//  ReviewView.swift
//  Bark Pawrks
//  Created by Amelia Martin on 11/20/22
//  Based on RatingView by Matt Kueper on 10/29/22.
//

import Foundation
import SwiftUI
import Firebase
import Kingfisher

struct ReviewView: View {
    
    let park: Park
    let userUid: String
    @ObservedObject var ratingModel = RatingViewModel()
    
    @State var parkid = ""
    @State var userid = ""
    @State var creation_date = ""
    @State var update_date = ""
    @State var review = ""
    @State var busy = false
    @State var dogbowl = false
    @State var smalldog = false
    @State var water = false
    @State var leash = false
    @State var seating = false
    @State var balls = false
    @State var trash = false
    @State var muttmitts = false
    @State var bathroom = false
    
    @State var showAlert = false
    
    @State var selection: String? = nil
    
    var body: some View {
        VStack {
            //need send park data from ParkView
            Text(park.name)
            //Image(AsyncImage(park.image_url!))
            KFImage(URL(string:park.image_url))
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)                    //.padding(.bottom)
            Spacer()
            Divider()
                
                
                VStack(spacing: 5){

                    TextField("Date", text: $update_date)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Group {
                        Toggle("Set if busy", isOn: $busy)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                        Toggle("Set if dog bowls present", isOn: $dogbowl)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                        Toggle("Set if small dog area", isOn: $smalldog)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                        Toggle("Set if water available", isOn: $water)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                        Toggle("Set if off leash", isOn: $leash)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                        Toggle("Set if seating available", isOn: $seating)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                        Toggle("Set if dog toys available", isOn: $balls)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                        Toggle("Set if trash on site", isOn: $trash)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                        Toggle("Set if Mutt Mitts available", isOn: $muttmitts)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                        Toggle("Set if bathrooms on site", isOn: $bathroom)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                    TextField("Other Notes", text: $review)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        //Call Rating add function
                        ratingModel.addRatings(
                            parkid: park.id,
                            userid: userUid,
                            creation_date: creation_date,
                            update_date: update_date,
                            review: review,
                            busy: busy,
                            dogbowl: dogbowl,
                            smalldog: smalldog,
                            water: water,
                            leash: leash,
                            seating: seating,
                            balls: balls,
                            trash: trash,
                            muttmitts: muttmitts,
                            bathroom: bathroom
                        )
                        
                        //Clear add user text fields
                        parkid = ""
                        userid = ""
                        creation_date = ""
                        update_date = ""
                        review = ""
                        busy = false
                        dogbowl = false
                        smalldog = false
                        water = false
                        leash = false
                        seating = false
                        balls = false
                        trash = false
                        muttmitts = false
                        bathroom = false
                        
                        showAlert = true
                        
                    }, label: {
                        Text("Submit Rating").padding(.top, 20)
                    }).padding(.bottom, 50).alert(isPresented: $showAlert){
                        Alert(title: Text("Review Submitted"), message: Text("Your review has been successfully submitted!"), dismissButton: .default(Text("OK"), action : {selection = "Main"}))
                    }
                    
                    NavigationLink(destination: ContentView(), tag: "Main", selection: $selection){EmptyView()}
                }
                .padding()
            }
        }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(park: Park.sampleData[0], userUid: "sampleUID")
    }
}

