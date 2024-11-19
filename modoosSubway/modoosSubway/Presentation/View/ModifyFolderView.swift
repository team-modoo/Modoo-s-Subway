//
//  ModifyFolderView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/12/24.
//

import SwiftUI

struct ModifyFolderView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(.back)
                    Text("폴더 수정하기")
                        .padding(.leading, -10)
                        .tint(._333333)
                }
                
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
            
            ModifyView()
                .padding(.top, 24)
            Spacer()
            
            
        }
        .background(.white)
        .toolbar(.hidden, for: .navigationBar)

    }
}

struct ModifyView: View {
    @State private var folderTextFieldString: String = ""
    @State private var descriptionTextFieldString: String = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("폴더명")
                    .font(.pretendard(size: 14, family: .medium))
                    .foregroundStyle(.black)
                    .padding(.leading,24)
                TextFieldView(text: $folderTextFieldString, placeholder: "폴더명을 입력해 주세요")
            }
            
            VStack(alignment: .leading) {
                Text("설명")
                    .font(.pretendard(size: 14, family: .medium))
                    .foregroundStyle(.black)
                    .padding(.leading,24)
                TextFieldView(text: $descriptionTextFieldString, placeholder: "설명을 입력해 주세요")
                
            }
            
            VStack(alignment: .leading) {
                Text("사진")
                    .font(.pretendard(size: 14, family: .medium))
                    .foregroundStyle(.black)
                    
                
                ImageSelectedView()
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
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
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

import PhotosUI

//struct ImageSelectedView: View {
//    @State private var selectedImage: UIImage?
//    @State private var selectedItem: PhotosPickerItem?
//    
//    var body: some View {
//        VStack {
//            ZStack {
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(Color.gray.opacity(0.1))
//                    .frame(width: 350,height: 196)
//                
//                if let image = selectedImage {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 350,height: 196)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                } else {
//                    VStack {
//                        Image(systemName: "plus")
//                            .font(.system(size: 40))
//                            .foregroundStyle(.gray)
//                    }
//                }
//            }
//        }
//        .overlay(
//            PhotosPicker(selection:$selectedItem,matching: .images) {
//                Color.clear
//            }
//        )
//        .onChange(of: selectedItem) { oldValue, newValue in
//            Task {
//                if let data = try? await newValue?.loadTransferable(type: Data.self) {
//                    if let uiImage = UIImage(data: data) {
//                        selectedImage = uiImage
//                    }
//                }
//            }
//        }
//    }
//}
//struct ImageSelectedView: View {
//    @State private var selectedImage: UIImage?
//    @State private var selectedItem: PhotosPickerItem?
//    @State private var showCropView = false
//    @State private var croppedImage: UIImage?
//    
//    var body: some View {
//        VStack {
//            ZStack {
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(Color.gray.opacity(0.1))
//                    .frame(width: 320, height: 196)
//                
//                if let image = croppedImage ?? selectedImage {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 320, height: 196)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                } else {
//                    VStack {
//                        Image(systemName: "plus.circle.fill")
//                            .font(.system(size: 40))
//                            .foregroundColor(.gray)
//                        Text("이미지 추가")
//                            .font(.system(size: 16))
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//        }
//        .overlay(
//            PhotosPicker(
//                selection: $selectedItem,
//                matching: .images
//            ) {
//                Color.clear
//            }
//        )
//        .onChange(of: selectedItem) { _, newValue in
//            Task {
//                if let data = try? await newValue?.loadTransferable(type: Data.self) {
//                    if let uiImage = UIImage(data: data) {
//                        selectedImage = uiImage
//                        showCropView = true  // 이미지 선택 후 크롭 뷰 표시
//                    }
//                }
//            }
//        }
//        .sheet(isPresented: $showCropView) {
//            ImageCropView(image: selectedImage ?? UIImage(), croppedImage: $croppedImage)
//        }
//    }
//}
struct ImageSelectedView: View {
    @State private var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    @State private var imageOffset: CGSize = .zero
    @State private var lastImageOffset: CGSize = .zero
    
    let frameSize: CGSize = CGSize(width: 320, height: 192)
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                // 선택된 이미지가 있을 때
                ZStack {
                    // 프레임 영역
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: frameSize.width, height: frameSize.height)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    // 이미지
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: frameSize.width, height: frameSize.height)
                        .offset(imageOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newOffset = CGSize(
                                        width: lastImageOffset.width + value.translation.width,
                                        height: lastImageOffset.height + value.translation.height
                                    )
                                    
                                    // 드래그 제한 범위 설정 (옵션)
                                    let maxOffset = frameSize.height / 2
                                    imageOffset = CGSize(
                                        width: newOffset.width,
                                        height: min(max(newOffset.height, -maxOffset), maxOffset)
                                    )
                                }
                                .onEnded { _ in
                                    lastImageOffset = imageOffset
                                }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
            } else {
                // 이미지 선택 버튼
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: frameSize.width, height: frameSize.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        VStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("이미지 추가")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .onChange(of: selectedItem) { _, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                        // 이미지 선택 시 오프셋 초기화
                        imageOffset = .zero
                        lastImageOffset = .zero
                    }
                }
            }
        }
    }
}

struct ImageCropView: View {
    let image: UIImage
    @Binding var croppedImage: UIImage?
    @Environment(\.dismiss) var dismiss
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color.black.opacity(0.8)
                    
                    // 크롭 영역 표시
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 320, height: 196)
                        .overlay(
                            Rectangle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                    
                    // 이미지
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = CGSize(
                                        width: lastOffset.width + value.translation.width,
                                        height: lastOffset.height + value.translation.height
                                    )
                                }
                                .onEnded { _ in
                                    lastOffset = offset
                                }
                        )
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = lastScale * value
                                }
                                .onEnded { _ in
                                    lastScale = scale
                                }
                        )
                }
            }
            .navigationBarItems(
                leading: Button("취소") {
                    dismiss()
                },
                trailing: Button("완료") {
                    saveImage()
                    dismiss()
                }
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("이미지 자르기")
        }
    }
    
    @MainActor private func saveImage() {
        // 현재 상태의 이미지를 크롭하여 저장
        let renderer = ImageRenderer(content:
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                .offset(offset)
        )
        
        if let uiImage = renderer.uiImage {
            croppedImage = uiImage
        }
    }
}

//
//
//
//
//struct FolderDecorateView: View {
//    @State var name: String = ""
//    @State private var textFieldString: String = ""
//    var body: some View {
//        VStack {
//            
//            HStack {
//                Text("폴더 꾸미기")
//                    .font(.pretendard(size: 20, family: .bold))
//                    .foregroundStyle(.black)
//                    .padding(.leading, 20)
//               
//                Spacer()
//            }
//            
//            HStack {
//                
//                TextField("폴더명을 입력해주세요", text: self.$textFieldString)
//                    .frame(height: 45)
//                    .textFieldStyle(PlainTextFieldStyle())
//                    .padding([.horizontal], 4)
//                    .cornerRadius(16)
//                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
//                    .padding([.horizontal], 4)
//                    .submitLabel(.search)
//                    .onSubmit {
//                        //   handleSearch()
//                    }
//                    .onAppear {
//                        UITextField.appearance().clearButtonMode = .whileEditing
//                    }
//                    .toolbar {
//                        ToolbarItem(placement: .keyboard) {
//                            HStack {
//                                Spacer()
//                            
//                                Button(action: {
//                                    //      hideKeyboard()
//                                
//                                    if textFieldString.isEmpty {
//                                        //     isSearchViewHidden = true
//                                        //     vm.stations = []
//                                    }
//                                }) {
//                                    Image(systemName: "keyboard.chevron.compact.down")
//                                        .foregroundColor(.blue)
//                                }
//                            }
//                        }
//                    }
//                    .autocorrectionDisabled()
//                    .textInputAutocapitalization(.never)
//                }
//                .background(.clear)
//                .padding(.trailing, 16)
//                .padding(.leading, 20)
//                .padding(.vertical, 4)
//            
//            
//            HStack {
//                VStack {
//                    Image(systemName: "camera")
//                        .resizable()
//                        .frame(width:36,height:36)
//                     
//                    Text("사진 촬영하기")
//                }
//                .frame(width: 170,height: 120)
//                .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(.EDEDED, lineWidth: 1)
//                )
//                
//                VStack {
//                    Image(systemName: "camera")
//                        .resizable()
//                        .frame(width:36,height:36)
//                     
//                    Text("사진 촬영하기")
//                }
//                .frame(width: 170,height: 120)
//                .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(.EDEDED, lineWidth: 1)
//                )
//            }
//            .padding(13)
//            Button {
//                
//            } label: {
//                Text("완료")
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 36)
//                    .padding(.horizontal, 20)
//            }
//            .buttonStyle(.borderedProminent)
//            .padding(.horizontal, 20)
//      
//
//           
//            }
//        }
//    }

