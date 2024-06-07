//
//  ContentView.swift
//  SlideViewer
//
//  Created by Chang Liu on 25/5/2024.
//

import SwiftUI

struct ContentView: View {
    @State var openGrid: Bool = true
    var importImageViewModel: ProfileModel
    var cameraInfoViewModel: CameraInfoViewModel
    var controlViewModel: ControlViewModel
    var body: some View {
        GeometryReader { geo in
            HStack {
                CanvasView(importImageViewModel: importImageViewModel, cameraInfoViewModel: cameraInfoViewModel, controlViewModel: controlViewModel)
                if openGrid {
                    WaterfallLayoutView(viewController: WaterfallLayoutViewController(importImageViewModel: importImageViewModel))
                        .frame(width: geo.size.width/2)
                        .padding()
                }
            }
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    withAnimation {
                        if gesture.translation.width < -0.5 {
                            openGrid = true
                        } else if gesture.translation.width > 0.5 {
                            openGrid = false
                        }
                    }
                }
        )
        .persistentSystemOverlays(.hidden)
        .statusBar(hidden: true)
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView(importImageViewModel: ProfileModel(), cameraInfoViewModel: CameraInfoViewModel(), controlViewModel: ControlViewModel())
}
