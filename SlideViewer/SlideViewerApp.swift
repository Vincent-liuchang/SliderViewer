//
//  SlideViewerApp.swift
//  SlideViewer
//
//  Created by Chang Liu on 25/5/2024.
//

import SwiftUI

@main
struct SlideViewerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(importImageViewModel: ProfileModel(), cameraInfoViewModel: CameraInfoViewModel(), controlViewModel: ControlViewModel())
        }
    }
}
