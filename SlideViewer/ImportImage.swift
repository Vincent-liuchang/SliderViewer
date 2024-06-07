//
//  ImportImage.swift
//  SlideViewer
//
//  Created by Chang Liu on 27/5/2024.
//

import SwiftUI
import PhotosUI

struct ImportImage: View {
    let imageState: ProfileModel.ImageState
    
    var body: some View {
        switch imageState {
        case .success(let image):
            image.resizable()
        case .loading:
            ProgressView()
        case .empty:
            Image(systemName: "photo.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}

struct CircularProfileImage: View {
    let imageState: ProfileModel.ImageState
    var controlViewModel: ControlViewModel
    
    var body: some View {
        ImportImage(imageState: imageState)
            .scaledToFit()
    }
}

struct EditableCircularProfileImage: View {
    @ObservedObject var viewModel: ProfileModel
    @State var showImportButton: Bool = true
    var controlViewModel: ControlViewModel
    
    var body: some View {
        CircularProfileImage(imageState: viewModel.imageState, controlViewModel: controlViewModel)
            .clipShape(Rectangle())
            .clipped()
            .padding(5)
            .background {
                Rectangle()
                    .fill(
                    LinearGradient(
                        colors: [.gray, .black],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .overlay(alignment: .bottomTrailing) {
                if showImportButton {
                    PhotosPicker(selection: $viewModel.imageSelection,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Image(systemName: "pencil.circle.fill")
                            .padding(5)
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 30))
                            .foregroundColor(.accentColor)
                    }
                                 .buttonStyle(.borderless)
                }
            }
            .onTapGesture {
                showImportButton.toggle()
            }
            .onTapGesture(count: 2, perform: {
                viewModel.imageSelection = nil
            })
    }
}

