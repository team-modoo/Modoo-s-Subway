//
//  FolderDecorateView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/11/24.
//

import SwiftUI
import PhotosUI

struct EditFolderView: View {
    let folder: Folder
    let section1: [EditFolderType] = [.modify, .delete]
	
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("더보기")
                        .font(.pretendard(size: 20, family: .bold))
						.foregroundStyle(._333333)
                    
                    Spacer()
                }
                .padding(.top, 34)
				.padding(.horizontal, 20)
                .background(.white)
                
                List {
                    ForEach(section1, id: \.self) { item in
                        EditFolderCell(title: item.rawValue,
                                       destination: item.destinationView(folder: item == .modify ? folder : nil),
                                       iconName: item.iconImage(),
                                       folderType: item,folder: folder)
                            .listRowSeparator(.hidden)
                    }
                }
                .background(.white)
				.padding(.top, 16)
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
            }
        }
    }
}


struct EditFolderCell: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    private var folderType: EditFolderType = .modify
    private var destination: AnyView?
    private var title: String
    private var iconName: String
    let folder: Folder?
    
    @State private var showFullScreen = false
    @State private var selectedDestination: AnyView? = nil
    @State var selectedImages: [UIImage] = [UIImage]()
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var showPhotoPicker = false
    @State private var showSelectedPhotoView = false
    @State private var isPresentedError = false
    @State private var showDeleteAlert = false
    
    init(title: String, destination: AnyView,iconName: String,folderType:EditFolderType,folder: Folder? = nil) {
        self.title = title
        self.destination = destination
        self.iconName = iconName
        self.folderType = folderType
        self.folder = folder
    }
    
    var body: some View {
        if let destination = destination {
            HStack {
                Image(iconName)
                    .resizable()
                    .frame(width: 16, height: 16)
					.padding(.trailing, 8)
                
                Text(title)
                    .font(.pretendard(size: 16, family: .medium))
					.foregroundStyle(Color(._333333))
                
                Spacer()
                
				Image(.iconChevronRight)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                switch folderType {
                case .modify:
                    showFullScreen = true
                case .delete:
                    showDeleteAlert = true
                }

                print("cell \(destination) clicked")
            }
			.alert("폴더 삭제", isPresented: $showDeleteAlert) {
				Button("취소", role: .cancel) { }
				Button("삭제", role: .destructive) {
					deleteFolder()
				}
			} message: {
				Text("정말 이 폴더를 삭제하시겠습니까?")
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
    
    private func deleteFolder() {
        if let folder = folder {
            DataManager.shared.deleteFolder(folder, context: modelContext)
            dismiss()
        }
    }
}

enum EditFolderType: String {
    case modify = "폴더 수정하기"
    case delete = "폴더 삭제하기"
  
    
    func destinationView(folder: Folder? = nil) -> AnyView {
        switch self {
        case .modify:
            if let folder = folder {
                return AnyView(FolderFormView(formType: .modify,folder: folder))
            }
            return AnyView(EmptyView())
        case .delete:
            return AnyView(EmptyView())
        }
    }
    
    func iconImage() -> String {
        switch self {
        case .modify:
            return "icon_edit"
        case .delete:
            return "icon_trash"
        }
    }
    
}
