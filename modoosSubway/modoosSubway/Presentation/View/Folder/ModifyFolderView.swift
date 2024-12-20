//
//  ModifyFolderView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/12/24.
//

import SwiftUI
import PhotosUI

struct ModifyView: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var selectedImage: UIImage?
    
    var body: some View {
		VStack(spacing: 30) {
            VStack(alignment: .leading) {
                Text("폴더명")
                    .font(.pretendard(size: 14, family: .medium))
                    .foregroundStyle(.black)
					.padding(.horizontal, 20)
                TextFieldView(text: $title, placeholder: "폴더명을 입력해 주세요")
            }
            
            VStack(alignment: .leading) {
                Text("설명")
                    .font(.pretendard(size: 14, family: .medium))
                    .foregroundStyle(.black)
					.padding(.horizontal, 20)
                TextFieldView(text: $description, placeholder: "설명을 입력해 주세요")
            }
            
            VStack(alignment: .leading) {
                Text("사진")
                    .font(.pretendard(size: 14, family: .medium))
                    .foregroundStyle(.black)
                ImageSelectedView(selectedImage: $selectedImage)
					.padding(.top, 16)
            }
			.padding(.horizontal, 20)
        }
		.toolbar {
			ToolbarItem(placement: .keyboard) {
				HStack {
					Spacer()
					
					Button(action: {
						hideKeyboard()
					}) {
						Image(systemName: "keyboard.chevron.compact.down")
							.foregroundColor(.blue)
					}
				}
			}
		}
	}
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct TextFieldView: View {
    @Binding var text: String
    var placeholder: String
    
    init(text: Binding<String>, placeholder: String) {
        self._text = text
        self.placeholder = placeholder
    }

    var body: some View {
        HStack {
            TextField(placeholder, text: self.$text)
                .padding(.leading, 16)
				.foregroundStyle(._5_C_5_C_5_C)
                .frame(height: 56)
                .textFieldStyle(.plain)
                .padding([.horizontal], 4)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.D_9_D_9_D_9))
                .padding([.horizontal], 4)
                .onAppear {
                    UITextField.appearance().clearButtonMode = .whileEditing
                }
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            }
            .background(.clear)
            .padding(.trailing, 16)
            .padding(.leading, 20)
            .padding(.vertical, 4)
    }
}

enum FolderFormType {
    case create
    case modify
    
    var title: String {
        switch self {
        case .create:
            return "폴더 추가하기"
        case .modify:
            return "폴더 수정하기"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .create:
            return "저장"
        case .modify:
            return "저장"
        }
    }
}

struct FolderFormView: View {
    @Environment(\.dismiss) var dismiss
    @State private var croppedImage: UIImage?
    @Environment(\.modelContext) private var modelContext
    @State private var showPreview: Bool = false
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedImage: UIImage?
    
    let formType: FolderFormType
    let folder: Folder?
    
    init(formType: FolderFormType,folder: Folder? = nil) {
        self.formType = formType
        self.folder = folder
        
        
        if formType == .modify, let folder = folder {
            _title = State(initialValue: folder.title)
            _description = State(initialValue: folder.content ?? "")
            
            if let base64String = folder.backgroundImage,
               let imageData = Data(base64Encoded: base64String),
               let uiImage = UIImage(data: imageData) {
                _selectedImage = State(initialValue: uiImage)
            } else {
                _selectedImage = State(initialValue: nil)
            }
        } else {
            _title = State(initialValue: "")
            _description = State(initialValue: "")
            _selectedImage = State(initialValue: nil)
        }
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(.back)

                    Text("\(formType.title)")
                        .font(.pretendard(size: 18, family: .semiBold))
						.foregroundStyle(._333333)
                        .padding(.leading, -10)
                        .tint(.black)
                }
                
                Spacer()
                
                Button(action: {
					switch formType {
					case .create:
						DataManager.shared.createFolder(title:title, content: description, image: selectedImage, context: modelContext)
					case .modify:
						if let folder = self.folder {
							DataManager.shared.updateFolder(folder,title: title,content: description,image: selectedImage, context: modelContext)
						}
					}
                    dismiss()
                    showPreview = true
                }) {
                    Text(formType.buttonTitle)
                        .padding(.leading, -10)
                        .tint(.theme)
						.font(.pretendard(size: 18, family: .semiBold))
                }
            }
            .background(.white)
            .padding(.horizontal, 20)
            .padding(.top, 22)
            
            ScrollView {
                ModifyView(title: $title, description: $description, selectedImage: $selectedImage)
                    .padding(.top, 24)
            }
			
            Spacer()
        }
        .tint(.black)
        .background(.red)
        .toolbar(.hidden, for: .navigationBar)

    }
}

struct ImageSelectedView: View {
    @Binding var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    private let imageHeight: CGFloat = 196
    
    var body: some View {
        ZStack {
            // 이미지 선택 버튼
            PhotosPicker(selection: $selectedItem, matching: .images) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
						.fill(Color.F_5_F_5_F_5)
						.frame(width: .infinity, height: imageHeight)
                    
					Image(.iconAddPhoto)
                }
            }
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImage = UIImage(data: data)
                    }
                }
            }
            
            // 선택된 이미지 미리보기
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
					.frame(width: .infinity, height: imageHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        Button(action: {
                            selectedImage = nil
                            selectedItem = nil
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .background(Circle().fill(Color.white))
                        }
                        .offset(x: 6, y: -6),
                        alignment: .topTrailing
                    )
            }
            
            Spacer()
        }
    }
}
