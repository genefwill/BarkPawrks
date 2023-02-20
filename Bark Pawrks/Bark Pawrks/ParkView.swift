//  ParksView.swift
//  Bark Pawrks
//
//  Created by user227018 on 11/13/22.
//

import Foundation
import SwiftUI
import Firebase
import Kingfisher

struct ParkView: View {
    @ObservedObject var parkRatingModel: ParkRatingViewModel
    let park: Park
    let userUid: String
    
    //Call function to load reviews specifc to each park in list
    init(park: Park, userUid: String) {
        self.park = park
        self.userUid = userUid
        parkRatingModel = ParkRatingViewModel(matchid: park.id)
    }
    
    // to trigger nav link when Review This Park button is clicked
    @State var selection: String? = nil
    var body: some View {
        
        VStack{
            let ratingSummary = createRatingsSummary(ratingsList: parkRatingModel.parkratinglist)
            Text(park.name)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top, 4)         //Image(AsyncImage(park.image_url!))
            KFImage(URL(string:park.image_url))
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)                    //.padding(.bottom)
            HStack {
                //Ratings of the park
                if (park.rating < 2.0) {
                    Image("big-star")
                    Image("big-star2")
                    Image("big-star2")
                    Image("big-star2")
                    Image("big-star2") }
                else if (park.rating < 3.0) {
                    Image("big-star")
                    Image("big-star")
                    Image("big-star2")
                    Image("big-star2")
                    Image("big-star2") }
                else if (park.rating < 4.0) {
                    Image("big-star")
                    Image("big-star")
                    Image("big-star")
                    Image("big-star2")
                    Image("big-star2") }
                else if (park.rating < 5.0) {
                    Image("big-star")
                    Image("big-star")
                    Image("big-star")
                    Image("big-star")
                    Image("big-star2") }
                else if (park.rating == 5.0) {
                    Image("big-star")
                    Image("big-star")
                    Image("big-star")
                    Image("big-star")
                    Image("big-star") }
                else {
                    Text("No rating found")
                        .font(.caption)
                }
            }
            .padding([.bottom, .top], 3)
            VStack {
                Divider()
                    .frame(width: 300)
                Text("\(park.location.address1.description)")
                HStack {
                    Text("\(park.location.city)")
                    Text(", ")
                    Text("\(park.location.state)")
                    Text("\(park.location.zip_code)")
                }
                Divider()
                    .frame(width: 300)
            }
            //.padding([.top, .bottom], 3)
            Text("Park Attributes Based on User Ratings:")
            HStack{
                Group{
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
            Text("Reviews:")
            List (parkRatingModel.parkratinglist) { item in
                HStack{
                    Text(item.review)
                        .padding()
                    //Spacer()
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 5)
                        .background(.clear)
                        .foregroundColor(Color("button-shadow-green").opacity(0.5))                 .padding(
                            EdgeInsets(
                                top: 10,
                                leading: 15,
                                bottom: 10,
                                trailing: 15
                            )
                        )
                )
            }
            .listStyle(.plain)

            //Spacer()
            // send user to page where they can submit review
            NavigationLink(destination: ReviewView(park: park, userUid: userUid), tag: "Review", selection: $selection){EmptyView()}
            Button("Review This Park"){
                selection = "Review"
            }.buttonStyle(PrimaryButtonStyle())
                .padding(.bottom, 7)
                .padding(.top, 7)
        }
        
        
    }
}
extension Optional: CustomStringConvertible {

    public var description: String {
        switch self {
        case .some(let wrappedValue):
            return "\(wrappedValue)"
        default:
            return "<nil>"
        }
    }
}
func createRatingsSummary(ratingsList: [ratings]) -> ratings {
    
    let id = "summaryid"
    let parkid = ""
    let userid = ""
    let creation_date = ""
    let update_date = ""
    let review = ""
    var busy = false
    var dogbowl = false
    var smalldog = false
    var water = false
    var leash = false
    var seating = false
    var balls = false
    var trash = false
    var muttmitts = false
    var bathroom = false
    
    //variables to track if more for than 50% of reviews have tagged the relevant attribute
    var busytrack = 0
    var dogbowltrack = 0
    var smalldogtrack = 0
    var watertrack = 0
    var leashtrack = 0
    var seatingtrack = 0
    var ballstrack = 0
    var trashtrack = 0
    var muttmittstrack = 0
    var bathroomtrack = 0
    
    //loop through all reveiws for a given park and check which attributes have been tagged
    for r in ratingsList{
        if r.busy{ busytrack += 1 } else {busytrack -= 1}
        if r.dogbowl{ dogbowltrack += 1 } else {dogbowltrack -= 1}
        if r.smalldog{ smalldogtrack += 1 } else {smalldogtrack -= 1}
        if r.water{ watertrack += 1 } else {watertrack -= 1}
        if r.leash{ leashtrack += 1 } else {leashtrack -= 1}
        if r.seating{ seatingtrack += 1 } else {seatingtrack -= 1}
        if r.balls{ ballstrack += 1 } else {ballstrack -= 1}
        if r.trash{ trashtrack += 1 } else {trashtrack -= 1}
        if r.muttmitts{ muttmittstrack += 1 } else {muttmittstrack -= 1}
        if r.bathroom{ bathroomtrack += 1 } else {bathroomtrack -= 1}
    }
    
    //if any attribute is over %50 set return value for that attribute to true
    if busytrack > 0 { busy = true}
    if dogbowltrack > 0 { dogbowl = true}
    if smalldogtrack > 0 { smalldog = true}
    if watertrack > 0 { water = true}
    if leashtrack > 0 { leash = true}
    if seatingtrack > 0 { seating = true}
    if ballstrack > 0 { balls = true}
    if trashtrack > 0 { trash = true}
    if muttmittstrack > 0 { muttmitts = true}
    if bathroomtrack > 0 { bathroom = true}
    
    return ratings(
        id: id,
        parkid: parkid,
        userid: userid,
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
}

struct ParkView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ParkView(park: Park.sampleData[0], userUid: "sampleUid")
        }
    }
}

