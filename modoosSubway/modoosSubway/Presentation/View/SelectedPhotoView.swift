//
//  SelectedPhotoView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/12/24.
//

import SwiftUI
import PhotosUI

struct SelectedPhotoView: View {
    @Environment(\.dismiss) private var dismiss
    let photo: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(.back)
                        Text("사진 첨부하기")
                            .padding(.leading, -10)
                            .tint(._333333)
                    }
                    .background(.red)
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                       
                        Text("완료")
                            .padding(.leading, -10)
                            .tint(._333333)
                    }
                    
                    
                }
                .background(.white)
                .padding(.horizontal, 20)
                .padding(.top, 22)
                
             
                VStack {
                //    FolderCardView(folder: <#Folder#>)
                }
                .padding(.top, 30)
                Spacer()
            }
            .background(.white)
            .toolbar(.hidden, for: .navigationBar)
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
