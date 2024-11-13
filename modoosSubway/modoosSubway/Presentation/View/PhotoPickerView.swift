//
//  PhotoPickerView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/12/24.
//

import SwiftUI

struct SelectedPhotoView: View {
    @Environment(\.dismiss) private var dismiss
    let photo: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Selected Photo")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        Task {
            if let photo = photo,
               let data = try? await photo.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    selectedImage = image
                }
            }
        }
    }
}
