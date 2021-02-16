//
//  Enums.swift
//  NASA_Project
//
//  Created by Said Alır on 16.02.2021.
//

import Foundation

enum Rovers: String {
    case CURIOSITY
    case OPPORTUNITY
    case SPIRIT
}

enum RoverCameras {
    static let curiosity: [Camera] = [.FHAZ ,.RHAZ, .MAST, .CHEMCAM, .MAHLI, .MARDI, .NAVCAM]
    static let opportunity: [Camera] = [.FHAZ, .RHAZ, .NAVCAM, .PANCAM, .MINITES]
    static let spirit: [Camera] = [.FHAZ, .RHAZ, .NAVCAM, .PANCAM, .MINITES]
}

enum Camera: String {
    case FHAZ
    case RHAZ
    case MAST
    case CHEMCAM
    case MAHLI
    case MARDI
    case NAVCAM
    case PANCAM
    case MINITES
}
