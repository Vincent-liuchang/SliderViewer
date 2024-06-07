//
//  SideControlsView.swift
//  SlideViewer
//
//  Created by Chang Liu on 27/5/2024.
//

import SwiftUI

struct SideControlsView: View {
    var controlViewModel: ControlViewModel
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Button(action: {}, label: {
                    Label(
                        title: { Text("Setting") },
                        icon: { Image(systemName: "gear.circle") }
                    )
                })
                .background(.black.opacity(0.7))
                .background(in: RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
                .padding(.bottom)
                Button(action: {
                    withAnimation {
                        controlViewModel.showRuler.toggle()
                    }
                }, label: {
                    Label(
                        title: { Text("Ruler") },
                        icon: { Image(systemName: "r.circle") }
                    )
                })
                .background(.black.opacity(0.7))
                .background(in: RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
                .padding(.bottom)
                Button(action: {
                    withAnimation {
                        controlViewModel.showDigitCopy.toggle()
                    }
                }, label: {
                    Label(
                        title: { Text("Compare") },
                        icon: { Image(systemName: "circle.lefthalf.filled.righthalf.striped.horizontal.inverse") }
                    )
                })
                .background(.black.opacity(0.7))
                .background(in: RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
                .padding(.bottom)
                Button(action: {
                    withAnimation {
                        controlViewModel.showInfo.toggle()
                    }
                }, label: {
                    Label(
                        title: { Text("Info") },
                        icon: { Image(systemName: "info.circle") }
                    )
                })
                .background(.black.opacity(0.7))
                .background(in: RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
                .padding(.bottom)
                Button(action: {
                    withAnimation {
                        controlViewModel.imageOffset = .zero
                        controlViewModel.rulerOffset = .zero
                        controlViewModel.imageScale = .init(width: 1, height: 1)
                        controlViewModel.imageInitScale = .init(width: 1, height: 1)
                        controlViewModel.imageInitPosition = .zero
                        controlViewModel.rulerInitPosition = .zero
                    }
                }, label: {
                    Label(
                        title: { Text("Reset") },
                        icon: { Image(systemName: "arrow.uturn.backward.circle") }
                    )
                })
                .background(.black.opacity(0.7))
                .background(in: RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
                .padding(.bottom)
            }
            .font(.title)
            .foregroundStyle(.white)
            .labelStyle(.iconOnly)
        }
        .padding()
    }
}
