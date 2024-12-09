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
        VStack {
            VStack(alignment: .leading) {
                Text("폴더명")
                    .font(.pretendard(size: 14, family: .medium))
                    .foregroundStyle(.black)
                    .padding(.leading,24)
                TextFieldView(text: $title, placeholder: "폴더명을 입력해 주세요")
            }
            
            VStack(alignment: .leading) {
                Text("설명")
                    .font(.pretendard(size: 14, family: .medium))
                    .foregroundStyle(.black)
                    .padding(.leading,24)
                TextFieldView(text: $description, placeholder: "설명을 입력해 주세요")
                
            }
            
            VStack(alignment: .leading) {
                Text("사진")
                    .font(.pretendard(size: 14, family: .medium))
                    .foregroundStyle(.black)
                    .padding(.leading,24)
                    
                
                ImageSelectedView(selectedImage: $selectedImage)
            }
            //.padding(.top,10)
  
            
            
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
                .frame(height: 56)
                .textFieldStyle(.plain)
                .padding([.horizontal], 4)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.D_9_D_9_D_9))
                .padding([.horizontal], 4)
                .submitLabel(.search)
                .onSubmit {
                    //   handleSearch()
                }
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
            return "폴더 생성하기"
        case .modify:
            return "폴더 수정하기"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .create:
            return "추가하기"
        case .modify:
            return "저장하기"
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
                        .padding(.leading, -10)
                        .tint(._333333)
                }
                
                Spacer()
                
                Button(action: {
                    
                    if formType == .create {
                        DataManager.shared.createFolder(title:title, content: description, image: selectedImage, context: modelContext)
                    } else if formType == .modify, let folder = self.folder {
                        print("수정하기 버튼 클릭")
                        print("수정 전 폴더 상태:")
                        print("ID: \(folder.id)")
                        print("제목: \(folder.title)")
                        print("설명: \(folder.content ?? "설명 없음")")

                       DataManager.shared.updateFolder(folder,title: title,content: description,image: selectedImage, context: modelContext)
                    }

                    dismiss()
                    showPreview = true
                }) {
                   
                    Text("\(formType.buttonTitle)")
                        .padding(.leading, -10)
                        .tint(._333333)
                }
                
                
            }
            .background(.white)
            .padding(.horizontal, 20)
            .padding(.top, 22)
            
            ModifyView(title: $title, description: $description, selectedImage: $selectedImage)
                .padding(.top, 24)
               
            Spacer()
            
            
        }
        .background(.white)
        .toolbar(.hidden, for: .navigationBar)

    }
}

struct ImageSelectedView: View {
    @Binding var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    
    private let imageSize: CGFloat = 100  // 정사각형 크기
    
    var body: some View {
        HStack(spacing: 16) {
            // 이미지 선택 버튼
            PhotosPicker(selection: $selectedItem, matching: .images) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        .frame(width: imageSize, height: imageSize)
                    
                    VStack(spacing: 8) {
                        Image("icon_add")
                            .font(.system(size: 24))
                            .foregroundColor(._333333)

                    }
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
                    .frame(width: imageSize, height: imageSize)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
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
        .padding(.horizontal, 24)
    }
}
