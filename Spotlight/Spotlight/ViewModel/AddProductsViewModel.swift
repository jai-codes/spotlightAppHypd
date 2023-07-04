//
//  AddProductsViewModel.swift
//  Spotlight
//
//  Created by Jai Deep on 28/06/23.
//

import Foundation


class AddProductsViewModel: ObservableObject {
    
    @Published var categories: [CategoryPayload] = []
    @Published var addedProducts:[String] = []
    
    // Popular Brands
    @Published var hotSellingBrands: [Brand] = []
    @Published var hotSellingBrandsIDs: [String] = []
    
    // HOT SELLING/POPULAR PRODUCTS
    @Published var hotSellingCatalogIDs: [String] = []
    @Published var hotSellingCatalogs: [Payload] = []
    
    // Added items to be passed in AddProducts API
    @Published var addedItems: Set<String> = []
    
    // To be used in Brhamastra call and more to be added
    @Published var selectedBrand: String = ""
    
    private let authToken = "ZXlKaGJHY2lPaUpJVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SnBaQ0k2SWpZeVpqTmhaRE15TldNMFpHTXdNRE14WW1FMU5qQTJOQ0lzSW1OMWMzUnZiV1Z5WDJsa0lqb2lOakptTTJGa016STFZelJrWXpBd016RmlZVFUyTURZMUlpd2lZMkZ5ZEY5cFpDSTZJall5WmpOaFpETXlOV00wWkdNd01ETXhZbUUxTmpBMk5pSXNJblI1Y0dVaU9pSmpkWE4wYjIxbGNpSXNJbkp2YkdVaU9pSjFjMlZ5SWl3aWRYTmxjbDluY205MWNITWlPbTUxYkd3c0ltWjFiR3hmYm1GdFpTSTZJbFJsYzNRek1qRWlMQ0prYjJJaU9pSXdNREF4TFRBeExUQXhWREF3T2pBd09qQXdXaUlzSW1WdFlXbHNJam9pZEdWemRETXlNVEpBWjIxaGFXd3VZMjl0SWl3aWNHaHZibVZmYm04aU9uc2ljSEpsWm1sNElqb2lLemt4SWl3aWJuVnRZbVZ5SWpvaU16QXdNREF3TURBd01TSjlMQ0p3Y205bWFXeGxYMmx0WVdkbElqcHVkV3hzTENKblpXNWtaWElpT2lKTklpd2ljR2h2Ym1WZmRtVnlhV1pwWldRaU9uUnlkV1VzSW1sdVpteDFaVzVqWlhKZmFXNW1ieUk2ZXlKZmFXUWlPaUkyTXpJeFl6Um1ZMkl5TVdKbU5EUmpaamcwTWpVd1lURWlMQ0p1WVcxbElqb2lTMGxPUnlCS1FVTkxJaXdpY0hKdlptbHNaVjlwYldGblpTSTZleUp6Y21NaU9pSm9kSFJ3Y3pvdkwyUnRhemxxWlRkbFkyeHRkbmN1WTJ4dmRXUm1jbTl1ZEM1dVpYUXZZWE56WlhSekwybHRaeTltTkdSa1pHbGhiVzl1WkY5aGNIQnBZMjl1TG5CdVp5SXNJbWhsYVdkb2RDSTZNVEF5TkN3aWQybGtkR2dpT2pFd01qUjlMQ0oxYzJWeWJtRnRaU0k2SW10cGJtZHFZV05yTVNKOUxDSmpjbVZoZEdWa1gzWnBZU0k2SW0xdlltbHNaU0o5LkVUMlhTTnBTTjhaRm53b3RhXzNQTHBLZ1pXWjViTHN4eWs2U3dTNDRVQm8="
    
    
    // MARK: Brand Page Networking
    
    //Popular Brand IDs
    func getHotSellingBrandIDs() {
        guard let url = URL(string: "https://orderv2.getshitdone.in/api/hot-selling-brands") else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            // setting the hotSellingBrandIDs from the decoded data
            if let safeData = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: safeData, options: []) as? [String: Any]
                    if let payload = json?["payload"] as? [[String: Any]] {
                        let brandIDs = payload.compactMap { $0["brand_id"] as? String }
                        DispatchQueue.main.async {
                            self.hotSellingBrandsIDs = brandIDs
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func brandBasic(brandIDs: [String]) {
        guard let url = URL(string: "https://entity.getshitdone.in/api/app/brand/basic") else {
            print("Invalid URL")
            return
        }
        
        let body = ["ids": hotSellingBrandsIDs]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
            
            // setting the hotSellingBrands from the decoded data
            if let decodedData = try? JSONDecoder().decode(brandBasicModel.self, from: data) {
                DispatchQueue.main.async {
                    self.hotSellingBrands = decodedData.payload
                    print(self.hotSellingBrands)
                }
            } else {
                print("Error decoding JSON")
            }
        }.resume()
    }
    
    
    // MARK: Get Categories
    func getCategories() {
        guard let url = URL(string: "https://catalogv2.getshitdone.in/api/getL2") else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            if let safeData = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(CategoriesModel.self, from: safeData)
                    print(response)
                    DispatchQueue.main.async {
                        self.categories = response.payload
                        print(self.categories) // Verify that categories are being assigned correctly
                    }
                } catch {
                    print("Error decoding API response: \(error.localizedDescription)")
                }
            }
            
        }
        task.resume()
        
    }
    
    
    // MARK: HOT SELLING PRODUCTS
    func getHotSellingCatalogIDs(){
        guard let url = URL(string: "https://orderv2.getshitdone.in/api/hot-selling-catalogs")else{
            print("Invalid URL")
            return
        }
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            
            if let safeData = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: safeData, options: []) as? [String: Any],
                       let payload = json["payload"] as? [[String: Any]] {
                        let hotSellingCatalogIDs = payload.compactMap { $0["id"] as? String }
                        DispatchQueue.main.async {
                            self.hotSellingCatalogIDs = hotSellingCatalogIDs
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func getHotSellingCatalogs(catalogIDs: [String]){
        var urlString = "https://catalogv2.getshitdone.in/api/app/catalog/basic?"
        
        let queryParameters = hotSellingCatalogIDs.map { "id=\($0)" }
        urlString += queryParameters.joined(separator: "&")
        //        print(urlString)
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print("Error fetching catalog data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(ItemModel.self, from: data)
                
                DispatchQueue.main.async {
                    self.hotSellingCatalogs = decodedData.payload
                    //                        print(self.hotSellingCatalogs)
                }
            } catch {
                print("Error decoding catalog data: \(error)")
            }
        }
        .resume()
    }
    
    // MARK: Add Products to Spotlight with addedItems
    func AddProducts(addedProducts: [String]) {
        guard let url = URL(string: "https://catalogv2.getshitdone.in/api/app/influencer/products") else {
            print("Invalid URL")
            return
        }
        
        let body = ["catalog_ids": addedProducts]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
            
            // Handle the response data
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
        }.resume()
    }
    
    
    // Yet to integrate
    func brhamastra(l2Category: String, brandId: String ){
        guard let url = URL(string: "https://catalogv2.getshitdone.in/api/catalog/category") else {
            print("Invalid URL")
            return
        }
        
        let body: [String: Any] = [
            "Category_id": l2Category,
            "Brand_ids": [brandId],
            "Sort": 0,
            "category_lvl3": [],
            "page": 0
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
            
            // Handle the response data
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
        }.resume()
    }
    
}


