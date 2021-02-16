//
//  RoverPhotoManager.swift
//  NASA_Project
//
//  Created by Said Alır on 16.02.2021.
//

import Foundation

class RoverPhotoManager {
    
    static let shared = RoverPhotoManager()

    func getRoverPhotos(_ model: PhotoRequestModel, success: @escaping (PhotoResponseModel) -> (), failure: @escaping (Int, String) -> ()) {
        let path = model.roverName.rawValue.lowercased() + "/photos"
        var params: [String: Any] = [:]
        params["sol"] = model.sol
        if let cam = model.camera {
            params["camera"] = cam.rawValue.lowercased()
        }
        if let pgNum = model.page {
            params["page"] = pgNum
        }
        
        APIManager.shared.get(path: path, headers: nil, params: params) { (data) in
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(PhotoResponseModel.self, from: data)
                success(response)
            } catch {
                failure(0, "Data parse error!")
            }
        } failure: { (code, message) in
            failure(code, message)
        }

    }
}
