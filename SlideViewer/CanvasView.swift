//
//  CanvasView.swift
//  SlideViewer
//
//  Created by Chang Liu on 6/6/2024.
//

import SwiftUI

struct CanvasView: View {
    @State var authorName: String = ""
    var importImageViewModel: ProfileModel
    var cameraInfoViewModel: CameraInfoViewModel
    var controlViewModel: ControlViewModel
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .fill(.white)
                    .onTapGesture {
                        withAnimation {
                            controlViewModel.showControl.toggle()
                        }
                    }
                VStack {
                    HStack {
                        if controlViewModel.showInfo {
                            CameraInfoView(cameraInfoViewModel: cameraInfoViewModel)
                                .padding()
                                .transition(.move(edge: .leading))
                        }
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        TextField("By UserName", text: $authorName)
                            .multilineTextAlignment(.center)
                            .fixedSize()
                            .font(.system(.footnote))
                            .fontWeight(.bold)
                            .padding()
                        Spacer()
                    }
                }
                .padding()
                if controlViewModel.showControl {
                    SideControlsView(controlViewModel: controlViewModel)
                }
                HStack {
                    Spacer()
                    if controlViewModel.showDigitCopy {
                        EditableCircularProfileImage(viewModel: importImageViewModel, controlViewModel: controlViewModel)
                            .offset(controlViewModel.imageOffset)
                            .scaleEffect(controlViewModel.imageScale)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        controlViewModel.imageOffset = CGSize(width: controlViewModel.imageInitPosition.width + gesture.translation.width, height: controlViewModel.imageInitPosition.height + gesture.translation.height)
                                    }
                                    .onEnded { _ in
                                        controlViewModel.imageInitPosition = controlViewModel.imageOffset
                                    }
                                    .simultaneously(with: MagnifyGesture()
                                        .onChanged { gesture in
                                            controlViewModel.imageScale = CGSize(width: controlViewModel.imageInitScale.width * gesture.magnification, height: controlViewModel.imageInitScale.height * gesture.magnification)
                                        }
                                        .onEnded { gesture in
                                            controlViewModel.imageInitScale = controlViewModel.imageScale
                                        }
                                    )
                            )
                            .frame(width: geo.size.width * 4 / 7, height: geo.size.height * 4 / 7)
                    }
                    Spacer()
                }
                .padding()
                
                if controlViewModel.showRuler {
                    GeometryReader { geo in
                        HorizontalSwiftRuler()
                            .frame(height: 100)
                            .position(x: geo.size.width / 2, y: geo.size.height - geo.size.height / 6)
                            .offset(controlViewModel.rulerOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        controlViewModel.rulerOffset = CGSize(width: controlViewModel.rulerInitPosition.width, height: controlViewModel.rulerInitPosition.height + gesture.translation.height)
                                    }
                                    .onEnded { _ in
                                        controlViewModel.rulerInitPosition = controlViewModel.rulerOffset
                                    }
                            )
                    }
                    .transition(.move(edge: .bottom))
                }
            }
        }
    }
}
