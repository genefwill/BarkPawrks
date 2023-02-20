//
//  CardView.swift
//  MainPage
//
//  Created by Genevieve Will on 11/11/22.
//

import Foundation
import SwiftUI
import Kingfisher

struct CardView: View {

    @ObservedObject var parkRatingModel: ParkRatingViewModel
    let park: Park
    
    //Call function to load reviews specifc to each park in list
    init(park: Park) {
        self.park = park
        parkRatingModel = ParkRatingViewModel(matchid: park.id)
    }
    
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        VStack{
                HStack {
                    //Name of park
                    Text(park.name)
                        .font(.headline)
                    Spacer()
                    // distance away
                    HStack{
                        Text("\(park.distanceinmiles, specifier: "%.1f")")
                            .font(.caption)
                        Text(" miles")
                            .font(.caption)
                    }

                }
                .padding(.top)
                    

            HStack {
                
                    //Image(AsyncImage(park.image_url!))
                    KFImage(URL(string:park.image_url))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)                    .padding(.bottom, 7)
                    Spacer()
                        .frame(width: 15)
                VStack(alignment: .leading) {
                    
                        HStack {
                            //Park city name
                            Image("location")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Text(park.location.city)
                                .font(.caption)
                        }
                        .padding(.bottom, 4)
                        
                        HStack {
                            //Ratings of the park
                            if (park.rating < 2.0) {
                                Image("star")
                                Image("star2")
                                Image("star2")
                                Image("star2")
                                Image("star2") }
                            else if (park.rating < 3.0) {
                                Image("star")
                                Image("star")
                                Image("star2")
                                Image("star2")
                                Image("star2") }
                            else if (park.rating < 4.0) {
                                Image("star")
                                Image("star")
                                Image("star")
                                Image("star2")
                                Image("star2") }
                            else if (park.rating < 5.0) {
                                Image("star")
                                Image("star")
                                Image("star")
                                Image("star")
                                Image("star2") }
                            else if (park.rating == 5.0) {
                                Image("star")
                                Image("star")
                                Image("star")
                                Image("star")
                                Image("star") }
                            else {
                                Text("No rating found")
                                    .font(.caption)
                            }
                        }
                        .padding(.bottom, 4)
                    
                    
                    // Need to add assests to show amenities and add function to show Park amenities
                    //Text("Amenities")
                    LazyVGrid(columns: columns, spacing: 3){
                        Group{
                            let ratingSummary = createRatingsSummary(ratingsList: parkRatingModel.parkratinglist)
                            //Display attribute image results from assets for ach park attribute if "true"
                            if ratingSummary.busy == true {
                                Image(systemName: "person.3.fill")
                            } else {
                                Image(systemName: "person.3")
                            }
                            if ratingSummary.dogbowl == true {
                                Image(systemName: "rectangle.roundedbottom.fill")
                            } else {
                                Image(systemName: "rectangle.roundedbottom")
                            }
                            if ratingSummary.smalldog == true {
                                Image(systemName: "pawprint.circle.fill")
                            } else {
                                Image(systemName: "pawprint.circle")
                            }
                            if ratingSummary.water == true {
                                Image(systemName: "spigot.fill")
                            } else {
                                Image(systemName: "spigot")
                            }
                            if ratingSummary.leash == true {
                                Image(systemName: "point.topleft.down.curvedto.point.bottomright.up.fill")
                            } else {
                                Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                            }
                            if ratingSummary.seating == true {
                                Image(systemName: "chair.fill")
                            } else {
                                Image(systemName: "chair")
                            }
                            if ratingSummary.balls == true {
                                Image(systemName: "tennisball.fill")
                            } else {
                                Image(systemName: "tennisball.circle")
                            }
                            if ratingSummary.trash == true {
                                Image(systemName: "trash.circle.fill")
                            } else {
                                Image(systemName: "trash.circle")
                            }
                            if ratingSummary.muttmitts == true {
                                Image(systemName: "bag.circle.fill")
                            } else {
                                Image(systemName: "bag.circle")
                            }
                            if ratingSummary.bathroom == true {
                                Image(systemName: "toilet.fill")
                            } else {
                                Image(systemName: "toilet")
                            }
                        }
                    }
                    .padding(.bottom, 5)
                }
                    Spacer()
            }
        }
    }
}
        //working on background color
        //.background(Color.green.opacity(0.2))
        //for clicking on and reviewing, will change it to NavigationView
        //.onTapGesture {
            //print("review here")
        //}
    

struct CardView_Previews: PreviewProvider {
    static var park = Park.sampleData[0]
    static var previews: some View {
        CardView(park:park)
    }
}
