//
//  FolderDecorateView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/11/24.
//

import SwiftUI
import PhotosUI

struct EditFolderView: View {
    let section1: [EditFolderType] = [.modify, .attach, .delete]
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("더보기")
                        .font(.pretendard(size: 20, family: .bold))
                        .foregroundStyle(.black)
                        .padding(.leading, 20)
                    
                    Spacer()
                }
                .padding(.top,20)
                .padding(.leading,8)
                .background(.white)
                
                Spacer(minLength: 16)
                
                List {
                    ForEach(section1,id: \.self) { item in
                        EditFolderCell(title: item.rawValue, 
                                       destination: item.destinationView(),
                                       iconName: item.iconImage(), 
                                       folderType: item)
                            .listRowSeparator(.hidden)
                            .frame(height: 19)
                            .foregroundStyle(.blue)
                    }
                }
                .background(.white)
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
            }
        }
        
        
    }
}

#Preview {
    EditFolderView()
}

struct EditFolderCell: View {
    @Environment(\.dismiss) var dismiss
    private var folderType: EditFolderType = .modify
    private var destination: AnyView?
    private var title: String
    private var iconName: String
    
    @State private var showFullScreen = false
    @State private var selectedDestination: AnyView? = nil
    @State var selectedImages: [UIImage] = [UIImage]()
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var showPhotoPicker = false
    @State private var showSelectedPhotoView = false
    @State private var isPresentedError = false
    
    init(title: String, destination: AnyView,iconName: String,folderType:EditFolderType) {
        self.title = title
        self.destination = destination
        self.iconName = iconName
        self.folderType = folderType
    }
    
    var body: some View {
        if let destination = destination {
            HStack {
                Image("\(iconName)")
                    .resizable()
                    .frame(width: 18,height: 18)
                
                Text("\(title)")
                    .font(.pretendard(size: 16, family: .regular))
                    .foregroundStyle(.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.black)
                
            }
            .background(.red)
            .onTapGesture {
                if folderType == .attach {
                    showPhotoPicker = true
                } else {
                    showFullScreen = true
                }
                print("cell \(destination) clicked")
            }
            .photosPicker(
                isPresented: $showPhotoPicker,
                selection: $selectedPhotos,
                maxSelectionCount: 1,
                matching: .images,
                photoLibrary: .shared()
            )
            
            .onChange(of: selectedPhotos) { _, newValue in
                        if !newValue.isEmpty {
                            handleSelectedPhotos(newValue.first!)
                        }
                    }
            .alert("사진 로드 오류", isPresented: $isPresentedError) {
                        Button("확인", role: .cancel) {}
                    } message: {
                        Text("사진을 불러오는 중 오류가 발생했습니다. 다시 시도해주세요.")
                }
            .fullScreenCover(isPresented: $showSelectedPhotoView) {
                SelectedPhotoView(photo: selectedPhotos.first)
            }
            .fullScreenCover(isPresented: $showFullScreen) {
                NavigationStack {
                    destination
                    
                }
            }
        }
    }
    
    private func handleSelectedPhotos(_ photo: PhotosPickerItem) {
           photo.loadTransferable(type: Data.self) { result in
               switch result {
               case .success(let data):
                   if let data = data, let _ = UIImage(data: data) {
                       DispatchQueue.main.async {
                           showSelectedPhotoView = true
                       }
                   }
               case .failure:
                   DispatchQueue.main.async {
                       isPresentedError = true
                   }
               }
           }
       }
}

enum EditFolderType: String {
    case modify = "폴더 수정하기"
    case attach = "사진 첨부하기"
    case delete = "폴더 삭제하기"
  
    
    func destinationView() -> AnyView {
        switch self {
        case .modify:
            return AnyView(FolderFormView(formType: .modify))
        case .attach:
            return AnyView(EmptyView())
        case .delete:
            return AnyView(FolderView())
        }
    }
    
    func iconImage() -> String {
        switch self {
        case .modify:
            return "icon_edit"
        case .attach:
            return "icon_photo"
        case .delete:
            return "icon_trash"
        }
    }
    
}
