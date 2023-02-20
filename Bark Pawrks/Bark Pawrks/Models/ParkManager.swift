//
//  LocationsManager.swift
//  BarkPawrks
//
//  Created by Naser Sadat on 10/29/22.
//  Copyright © 2022 BarkPawrks. All rights reserved.
//

    
import Foundation

// Park manager class that will make yelp api calls
class ParkManager: ObservableObject {
    //Contains parsed park objects
    @Published var parks = [Park]()
    
    //Yelp token
    let yelpToken = "aL9SVNrVYG68vz2HN7XmvOeyMtcLltwljBkkWn7k4OczcpDTWs9BDDoh4vUewEiq-OYx892MP9Rt9wY7rkxRqQxEAzomyVJHGp7I855GotE_SBF5SbA9WUMffWFjY3Yx"
    let locationsURL = "https://api.yelp.com/v3/businesses/search?term=dog%20park&limit=5&sort_by=distance&radius=40000"
    
    //Location based api call function
    func getParkDataBasedLocation(latitude:Double, longitude:Double) {
        //Adds the longitude and latitude to the url query
        let urlString = "\(locationsURL)&latitude=\(latitude)&longitude=\(longitude)"
        
        //if coordinates are pased to the string convert to url object
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            //adds the authorization token to the get request header
            request.httpMethod = "GET"
            request.addValue("Bearer " + yelpToken, forHTTPHeaderField: "Authorization")
            //create a defualt session to make a request
            let session = URLSession(configuration: .default)
            //async call to the url
            let task = session.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    // if there is not error and data is returned
                    if let existsData = data {
                        do{
                            //parse the data using the park data data struct
                            let results = try decoder.decode(Root.self, from: existsData)
                            DispatchQueue.main.async {
                                // copies the data to the parks published array on the main thread
                                self.parks = results.businesses
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    //zipcode based api call function
    func getParkDataBasedZipCode(zipcode: String) {
        //if zipcode is passed to the string convert to url object
        let trimmedZip = zipcode.filter { !$0.isWhitespace }
        print(trimmedZip)
        let urlString = "\(locationsURL)&location=\(trimmedZip)"
        print(urlString)
        if let url = URL(string: urlString) {
            //adds the authorization token to the get request header
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer " + yelpToken, forHTTPHeaderField: "Authorization")
            //create a defualt session to make a request
            let session = URLSession(configuration: .default)
            //async call to the url
            let task = session.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    // if there is not error and data is returned
                    if let existsData = data {
                        do{
                            //parse the data using the park data data struct
                            let results = try decoder.decode(Root.self, from: existsData)
                            DispatchQueue.main.async {
                                // copies the data to the parks published array on the main thread
                                self.parks = results.businesses
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}

