//
//  ModifyFolderView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/12/24.
//

import SwiftUI
import PhotosUI

//struct ModifyFolderView: View {
//    @Environment(\.dismiss) var dismiss
//    @State private var croppedImage: UIImage?
//    @State private var showPreview: Bool = false
// 
//    var body: some View {
//        VStack {
//            HStack {
//                Button(action: {
//                    dismiss()
//                }) {
//                    Image(.back)
//                    Text("폴더 수정하기")
//                        .padding(.leading, -10)
//                        .tint(._333333)
//                }
//                
//                Spacer()
//                
//                Button(action: {
//                    //dismiss()
//                    showPreview = true
//                }) {
//                   
//                    Text("완료")
//                        .padding(.leading, -10)
//                        .tint(._333333)
//                }
//                
//                
//            }
//            .background(.white)
//            .padding(.horizontal, 20)
//            .padding(.top, 22)
//            
//            ModifyView(parentCroppedImage: $croppedImage)
//                .padding(.top, 24)
//            Spacer()
//            
//            
//        }
//        .background(.white)
//        .toolbar(.hidden, for: .navigationBar)
////        .sheet(isPresented: $showPreview) {
////                    PreviewView(croppedImage: croppedImage)
////                }
//
//    }
//}

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

//struct PreviewView: View {
//    @Environment(\.dismiss) var dismiss
//    let croppedImage: UIImage?
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                if let image = croppedImage {
//                    Text("수정된 이미지 미리보기")
//                        .font(.headline)
//                        .padding()
//                    
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 200)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .padding()
//                    
//                    Text("이미지 크기: \(Int(image.size.width)) x \(Int(image.size.height))")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                } else {
//                    Text("선택된 이미지가 없습니다")
//                        .foregroundColor(.gray)
//                }
//            }
//            .navigationBarItems(
//                trailing: Button("닫기") {
//                    dismiss()
//                }
//            )
//        }
//    }
//}

//struct ImageSelectedView: View {
//    @State private var selectedImage: UIImage?
//    @State private var selectedItem: PhotosPickerItem?
//    @State private var imageOffset: CGSize = .zero
//    @State private var lastImageOffset: CGSize = .zero
//    @State private var imageScale: CGFloat = 1.0
//    @State private var lastImageScale: CGFloat = 1.0
//    
//    // 조정된 이미지를 저장할 상태 변수 추가
//    @Binding var croppedImage: UIImage?
//    
//    let frameSize: CGSize = CGSize(width: 320, height: 192)
//    
//    var body: some View {
//        VStack {
//            if let image = selectedImage {
//                ZStack {
//                    Rectangle()
//                        .fill(Color.gray.opacity(0.1))
//                        .frame(width: frameSize.width, height: frameSize.height)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                    
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: frameSize.width, height: frameSize.height)
//                        .scaleEffect(imageScale)
//                        .offset(imageOffset)
//                        .gesture(
//                            DragGesture()
//                                .onChanged { value in
//                                    let newOffset = CGSize(
//                                        width: lastImageOffset.width + value.translation.width,
//                                        height: lastImageOffset.height + value.translation.height
//                                    )
//                                    
//                                    let maxOffset = frameSize.height / 2
//                                    imageOffset = CGSize(
//                                        width: newOffset.width,
//                                        height: min(max(newOffset.height, -maxOffset), maxOffset)
//                                    )
//                                    renderCroppedImage(image)
//                                }
//                                .onEnded { _ in
//                                    lastImageOffset = imageOffset
//                                    renderCroppedImage(image)
//                                }
//                        )
//                        .gesture(
//                            MagnificationGesture()
//                                .onChanged { value in
//                                    let scale = lastImageScale * value
//                                    imageScale = min(max(scale, 0.5), 3.0)
//                                    renderCroppedImage(image)
//                                }
//                                .onEnded { _ in
//                                    lastImageScale = imageScale
//                                    renderCroppedImage(image)
//                                }
//                        )
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                }
//                .background(.red)
//                .onChange(of: image) { _, _ in
//                                   // 이미지가 변경될 때마다 렌더링
//                                   renderCroppedImage(image)
//                               }
//                               .onAppear {
//                                   // 뷰가 나타날 때 초기 렌더링
//                                   renderCroppedImage(image)
//                               }
//                
//            } else {
//                PhotosPicker(selection: $selectedItem, matching: .images) {
//                    ZStack {
//                        Rectangle()
//                            .fill(Color.gray.opacity(0.1))
//                            .frame(width: frameSize.width, height: frameSize.height)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                        
//                        VStack {
//                            Image(systemName: "plus.circle.fill")
//                                .font(.system(size: 40))
//                                .foregroundColor(.gray)
//                            Text("이미지 추가")
//                                .font(.system(size: 16))
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    .background(.red)
//                }
//            }
//        }
//        .onChange(of: selectedItem) { _, newValue in
//            Task {
//                if let data = try? await newValue?.loadTransferable(type: Data.self) {
//                    if let uiImage = UIImage(data: data) {
//                        selectedImage = uiImage
//                        imageOffset = .zero
//                        lastImageOffset = .zero
//                        imageScale = 1.0
//                        lastImageScale = 1.0
//                        DispatchQueue.main.async {
//                            renderCroppedImage(uiImage)
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    @MainActor private func renderCroppedImage(_ originalImage: UIImage) {
//        // 현재 보이는 영역대로 이미지를 렌더링하는 함수
//        let renderer = ImageRenderer(content:
//            Image(uiImage: originalImage)
//                .resizable()
//                .scaledToFill()
//                .frame(width: frameSize.width, height: frameSize.height)
//                .scaleEffect(imageScale)
//                .offset(imageOffset)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//        )
//        
//        // 렌더링 설정
//        renderer.scale = UIScreen.main.scale
//        
//        // 렌더링된 이미지를 저장
//        if let renderedImage = renderer.uiImage {
//            croppedImage = renderedImage
//        }
//    }
//}

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
    let existingData: String?
    
    init(formType: FolderFormType,existingData:String? = nil) {
        self.formType = formType
        self.existingData = existingData
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
                    } else {
                        print("수정하기 버튼 클릭")
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
