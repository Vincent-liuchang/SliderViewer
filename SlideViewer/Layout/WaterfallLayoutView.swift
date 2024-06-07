//
//  WaterfallLayoutView.swift
//  SlideViewer
//
//  Created by Chang Liu on 6/6/2024.
//

import SwiftUI

struct WaterfallLayoutView: UIViewRepresentable {
    private let viewController: WaterfallLayoutViewController
    
    init(viewController: WaterfallLayoutViewController) {
        self.viewController = viewController
    }
   
    func makeUIView(context: Context) -> UIView {
        return viewController.view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        viewController.reload()
        print("did update UI View")
    }
}
