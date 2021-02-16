//
//  APIManager.swift
//  NASA_Project
//
//  Created by Said Alır on 16.02.2021.
//

import Foundation

class APIManager {
    
    static let apiKey = "dWpjjBYQNhGfq2JwoTqQmiGoJDAS37MP90zbk9Cy"
    static let baseUrl = "https://api.nasa.gov/mars-photos/api/v1/rovers/"
    static let shared = APIManager()
    
   
    public func get(path: String, headers: [[String: String]]?, params: [String: Any]?, success: @escaping (Data) -> Void, failure: @escaping (Int, String) -> Void) {
    
        let paramString = convertDictionaryToStr(params)
        let url = "\(path)?\(paramString)&api_key=\(APIManager.apiKey)"
        
        var request  = URLRequest(url: URL(string: "\(APIManager.baseUrl)/\(url)")!)
        request.httpMethod = "GET"
        request.timeoutInterval = 300
        
        
        if let headers = headers {
            for dictionary in headers {
                request.setValue(dictionary["value"], forHTTPHeaderField: dictionary["key"]!)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                DispatchQueue.main.async {
                    failure(0, "")
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    failure(0, "")
                }
                return
            }
            
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    success(data)
                }
            } else {
                guard let e = error else {
                    DispatchQueue.main.async {
                        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let responseJSON = responseJSON as? [String: Any] {
                            if responseJSON.keys.contains("message") {
                                let message = responseJSON["message"] as! String
                                failure(response.statusCode, message)
                            } else {
                                failure(response.statusCode, "")
                            }
                        } else {
                            failure(response.statusCode, "")
                        }
                    }
                    return
                }
                DispatchQueue.main.async {
                    failure(response.statusCode, e.localizedDescription)
                }
                
            }
        }
        
        task.resume()
    }
    
    /**
            Convert dictionary to url path
     */
    private func convertDictionaryToStr(_ params: [String: Any]?) -> String {
        var paramsString: String = ""
        var urlVars: [String] = []
        if let dictionary = params {
            for (k,v) in dictionary {
                urlVars.append("\(k)=\(v)")
            }
            paramsString = urlVars.joined(separator: "&")
        }
        return paramsString
    }
}
