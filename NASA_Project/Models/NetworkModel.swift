//
//  NetworkModel.swift
//  NASA_Project
//
//  Created by Said Alır on 16.02.2021.
//

import Foundation

struct PhotoRequestModel {
    var roverName: Rovers
    var page: Int?
    var sol: Int
    var camera: Camera?
}

struct PhotoResponseModel: Codable {
    var photos: [NasaPhoto]
}

struct NasaPhoto: Codable {
    var id: Int
    var sol: Int
    var camera: CameraInfo
    var img_src: String
    var earth_date: String
    var rover: RoverInfo
}

struct CameraInfo: Codable {
    var id: Int
    var name: String
    var rover_id: Int
    var full_name: String
}

struct RoverInfo: Codable {
    var id: Int
    var name: String
    var landing_date: String
    var launch_date: String
    var status: String
}
