//
//  CameraInfoView.swift
//  SlideViewer
//
//  Created by Chang Liu on 27/5/2024.
//

import SwiftUI

struct CameraInfoView: View {    
    var cameraInfoViewModel: CameraInfoViewModel
    @State var modelString = "F2"
    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Menu {
                        ForEach(cameraInfoViewModel.brands, id: \.self) {
                            brand in
                            Button {
                                cameraInfoViewModel.brandString = brand
                            } label: {
                                Text(brand)
                            }
                        }
                        
                    } label: {
                        Text(cameraInfoViewModel.brandString)
                            .font(.system(.largeTitle))
                            .fontWeight(.bold)
                    }
                    TextField("", text: $modelString)
                        .fixedSize()
                        .font(.system(.largeTitle))
                        .fontWeight(.bold)
                }
                Menu {
                    ForEach(cameraInfoViewModel.films, id: \.self) {
                        film in
                        Button {
                            cameraInfoViewModel.filmType = film
                        } label: {
                            Text(film)
                        }
                    }                    
                } label: {
                    Text(cameraInfoViewModel.filmType)
                        .font(.system(.callout))
                        .fontWeight(.bold)
                }
            }
            .tint(.white)
            .foregroundStyle(.white)
            .padding()
        }
        .background(.black.opacity(0.7))
        .background(in: RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
    }
}
