//
//  MainView.swift
//Bark Pawrks
//
//  Created by Genevieve Will on 11/11/22.
//
import SwiftUI
import Combine

struct MainView: View {
    @EnvironmentObject var loggedInModel: AuthViewModel
    
    @StateObject var deviceLocationService = DeviceLocationService.shared
    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, Long: Double) = (0,0)
    
    @ObservedObject var parkManager = ParkManager()
    
    
    let parks: [Park]
    @State var zipCode: String = ""
    
    var body: some View {
            ZStack {
                VStack {
                    
                    Spacer()
                    NavigationView {
                        
                        VStack{
                            VStack {
                                HStack {
                                    Spacer()
                                    Button("logout") {
                                        if loggedInModel.isUserGoogleLoggedIn {
                                            //Log out of google based account
                                            print("logout google")
                                            loggedInModel.googleLogOut()
                                        } else {
                                            //Log out of email based account
                                            print("logout email based")
                                            loggedInModel.isUserLoggedIn = false
                                        }
                                    }.padding(.trailing, 15)
                                    
                                }
                                HStack {
                                    Image("med-play")                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 75, height: 75)
                                        .padding(.bottom, 10)
                                }
                            }
                            //Search for zipcode
                            Text("Search by Zip Code or City")
                            HStack {
                                Spacer()
                                Spacer()
                                TextField("Zip Code or City", text: $zipCode).multilineTextAlignment(TextAlignment.center)
                                // Search Button
                                Spacer()
                                Spacer()
                                Spacer()
                                Button {
                                    searchAction()
                                } label: {
                                    HStack {
                                        Spacer()
                                        Text("Search")
                                        Spacer()
                                    }
                                    
                                    
                                }
                                .buttonStyle(SmallButtonStyle())
                                Spacer()
                            }
                            
                            //.disabled(true)
                            Group {
                                Divider()
                                    .frame(height: 2.0)
                                    .background(Color.black)
                            }
                            .frame(width: 350);
                            Spacer()
                            Spacer()
                            VStack{
                                HStack{
                                    Spacer()
                                    Text("Dog Parks Near You")
                                    Spacer()
                                }
                            
                                //Should likley add some handling for no/invalid park data
                                List {
                                    ForEach(parkManager.parks, id:\.id) { Park in
                                        NavigationLink(destination: ParkView(park: Park, userUid: loggedInModel.userUid)) {
                                            CardView(park: Park)
                                            
                                        }
                                        //Adds space between each park card view
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
                                }
                                .listStyle(.plain)
                                
                                }
                                
                            }
                        }
                    .onAppear{
                        observeCoordinateUpdates()
                        observeDeniedLocationAccess()
                        deviceLocationService.requestLocationUpdates()                    }
                }
            }
            .navigationBarBackButtonHidden(true)
    }
    
    func observeCoordinateUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("Handle \(completion) for error and finished subscription.")
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
                parkManager.getParkDataBasedLocation(latitude: self.coordinates.lat, longitude: self.coordinates.Long)
            }
            .store(in: &tokens)
    }


    func observeDeniedLocationAccess() {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Handle access denied event, possibly with an alert.")
            }
            .store(in: &tokens)
    }
    
    private func searchAction() {
        parkManager.getParkDataBasedZipCode(zipcode: zipCode)
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(parks: Park.sampleData)
    }
}
