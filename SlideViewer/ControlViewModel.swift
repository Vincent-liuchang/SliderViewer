//
//  ControlViewModel.swift
//  SlideViewer
//
//  Created by Chang Liu on 28/5/2024.
//

import SwiftUI

@Observable
class ControlViewModel {
    var showDigitCopy: Bool = true
    var showRuler: Bool = false
    var showInfo: Bool = true
    var showControl: Bool = true    
    var imageOffset: CGSize = .zero
    var imageScale: CGSize = .init(width: 1, height: 1)
    var imageInitScale: CGSize = .init(width: 1, height: 1)
    var imageInitPosition: CGSize = .zero
    var rulerOffset: CGSize = .zero
    var rulerInitPosition: CGSize = .zero
}
