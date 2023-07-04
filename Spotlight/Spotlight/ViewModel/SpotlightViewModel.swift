//
//  ItemViewModel.swift
//  Spotlight
//
//  Created by Jai Deep on 24/06/23.
//

import Foundation
import Combine


class SpotlightViewModel: ObservableObject {
    
    // Spotlight View Variables
    @Published var featuredProductIDs: [String] = []
    @Published var catalogs: [Payload] = []
    // Selected Ids for deleting
    @Published var selectedItems: Set<String> = []
    // For Delete DialogueBox
    @Published var offset: CGFloat = 1000
   
    private let authToken = "ZXlKaGJHY2lPaUpJVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SnBaQ0k2SWpZeVpqTmhaRE15TldNMFpHTXdNRE14WW1FMU5qQTJOQ0lzSW1OMWMzUnZiV1Z5WDJsa0lqb2lOakptTTJGa016STFZelJrWXpBd016RmlZVFUyTURZMUlpd2lZMkZ5ZEY5cFpDSTZJall5WmpOaFpETXlOV00wWkdNd01ETXhZbUUxTmpBMk5pSXNJblI1Y0dVaU9pSmpkWE4wYjIxbGNpSXNJbkp2YkdVaU9pSjFjMlZ5SWl3aWRYTmxjbDluY205MWNITWlPbTUxYkd3c0ltWjFiR3hmYm1GdFpTSTZJbFJsYzNRek1qRWlMQ0prYjJJaU9pSXdNREF4TFRBeExUQXhWREF3T2pBd09qQXdXaUlzSW1WdFlXbHNJam9pZEdWemRETXlNVEpBWjIxaGFXd3VZMjl0SWl3aWNHaHZibVZmYm04aU9uc2ljSEpsWm1sNElqb2lLemt4SWl3aWJuVnRZbVZ5SWpvaU16QXdNREF3TURBd01TSjlMQ0p3Y205bWFXeGxYMmx0WVdkbElqcHVkV3hzTENKblpXNWtaWElpT2lKTklpd2ljR2h2Ym1WZmRtVnlhV1pwWldRaU9uUnlkV1VzSW1sdVpteDFaVzVqWlhKZmFXNW1ieUk2ZXlKZmFXUWlPaUkyTXpJeFl6Um1ZMkl5TVdKbU5EUmpaamcwTWpVd1lURWlMQ0p1WVcxbElqb2lTMGxPUnlCS1FVTkxJaXdpY0hKdlptbHNaVjlwYldGblpTSTZleUp6Y21NaU9pSm9kSFJ3Y3pvdkwyUnRhemxxWlRkbFkyeHRkbmN1WTJ4dmRXUm1jbTl1ZEM1dVpYUXZZWE56WlhSekwybHRaeTltTkdSa1pHbGhiVzl1WkY5aGNIQnBZMjl1TG5CdVp5SXNJbWhsYVdkb2RDSTZNVEF5TkN3aWQybGtkR2dpT2pFd01qUjlMQ0oxYzJWeWJtRnRaU0k2SW10cGJtZHFZV05yTVNKOUxDSmpjbVZoZEdWa1gzWnBZU0k2SW0xdlltbHNaU0o5LkVUMlhTTnBTTjhaRm53b3RhXzNQTHBLZ1pXWjViTHN4eWs2U3dTNDRVQm8="
    
    
    
    // MARK: Get Spotlight ProductsIDs of a user with Auth Token
    func getProductsIDs(){
        guard let url = URL(string: "https://catalogv2.getshitdone.in/api/app/influencer/products?type=self") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self.featuredProductIDs = response.payload.catalogIDs
                }
                
            } catch {
                print("Error decoding API response: \(error.localizedDescription)")
            }
        }
        .resume()
    }
    
    
    //  MARK:  Get Spotlight Products of a user with Spotlight ProductsIDs of a user
    func catalogBasic(catalogIDs: [String]){
        var urlString = "https://catalogv2.getshitdone.in/api/app/catalog/basic?"
        
        // passing the query in URLString
        for (index, id) in featuredProductIDs.enumerated() {
            urlString += "id=\(id)"
            
            if index != featuredProductIDs.count - 1 {
                urlString += "&"
            }
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print("Error fetching catalog data: \(error?.localizedDescription ?? "Unknown error")")
                return }
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(ItemModel.self, from: data)
                DispatchQueue.main.async {
                    self.catalogs = decodedData.payload
                }
                print(self.catalogs)
            } catch {
                print("Error decoding catalog data: \(error)")
            }
        }
        .resume()
    }
    
    
    // MARK: Delete selected products with Post Request
    func deleteProducts(selectedItems: [String]) {
        guard let url = URL(string: "https://catalogv2.getshitdone.in/api/app/influencer/products") else {
            print("Invalid URL")
            return
        }
        
        let body = ["catalog_ids": selectedItems]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(authToken, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Printing the response
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
        }
        .resume()
    }
}




/*
 
 Delete Functionalty
 
 func deleteProducts
 */
