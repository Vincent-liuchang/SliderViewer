//
//  CameraInfoViewModel.swift
//  SlideViewer
//
//  Created by Chang Liu on 28/5/2024.
//
import SwiftUI

@Observable
class CameraInfoViewModel {    
    var brandString = "NIKON"
    var brands: [String]  = ["NIKON",
                             "Canon",
                             "FUJIFILM",
                             "Leica",
                             "Hasselblad",
                             "Ricoh",
                             "Seagull",
                             "Olympus",
                             "Sony",
                             "Rollei",
                             "Panasonic",
                             "PENTAX",
                             "Mamiya",
                             "Praktica",
                             "CONTAX",
                             "Voigtländer"]
    var filmType = "Kodak Portra 400"
    var films: [String] = ["Kodak Ektar 100",
                           "Kodak Portra 160",
                           "Kodak Portra 400",
                           "Kodak Portra 800",
                           "Kodak ProImage 100",
                           "FUJI PRO 400H",
                           "Kodak Gold 100",
                           "Kodak Gold 200",
                           "Kodak Gold 400",
                           "Kodak ColorPlus 200",
                           "Kodak UltraMax 400",
                           "Fujicolor Superia Xtra 400",
                           "FUJI Superia Premium 400",
                           " FUJI C200"]
}
