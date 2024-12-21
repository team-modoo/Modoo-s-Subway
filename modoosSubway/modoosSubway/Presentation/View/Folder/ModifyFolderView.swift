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
				HStack {
					Text("폴더명")
						.font(.pretendard(size: 14, family: .medium))
						.foregroundStyle(._333333)
					
					Text("*")
						.font(.pretendard(size: 14, family: .medium))
						.foregroundStyle(.FF_392_F)
						.padding(.leading, -4)
				}
				
                TextFieldView(text: $title, placeholder: "폴더명을 입력해 주세요")
					.padding(.top, 16)
            }
			.padding(.horizontal, 20)
            
            VStack(alignment: .leading) {
                Text("설명")
                    .font(.pretendard(size: 14, family: .medium))
                    .foregroundStyle(._333333)
				
                TextFieldView(text: $description, placeholder: "설명을 입력해 주세요")
					.padding(.top, 16)
            }
			.padding(.horizontal, 20)
            
            VStack(alignment: .leading) {
                Text("사진")
                    .font(.pretendard(size: 14, family: .medium))
                    .foregroundStyle(._333333)
					.padding(.bottom, 16)
				
                ImageSelectedView(selectedImage: $selectedImage)
            }
			.padding(.horizontal, 20)
        }
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
			TextField(text: $text) {
				Text(placeholder)
					.font(.pretendard(size: 14, family: .regular))
					.foregroundStyle(Color.BFBFBF)
			}
			.padding(.horizontal, 16)
			.foregroundStyle(._5_C_5_C_5_C)
			.frame(height: 50)
			.textFieldStyle(.plain)
			.font(.pretendard(size: 14, family: .medium))
			.cornerRadius(8)
			.clearButton(text: $text)
			.overlay(
				RoundedRectangle(cornerRadius: 8)
					.stroke(Color.EDEDED)
			)
		}
		.background(.clear)
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
		VStack(spacing: 0) {
			// MARK: - 상단 HStack 고정
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
                        .tint(title.isEmpty ? .BFBFBF : .theme)
						.font(.pretendard(size: 18, family: .semiBold))
                }
				.disabled(title.isEmpty)
            }
            .background(.white)
            .padding(.horizontal, 20)
            .padding(.top, 20)
			.padding(.bottom, 30)
			.zIndex(1) // 상단에 쌓이도록 설정
            
			ScrollView {
				ModifyView(title: $title, description: $description, selectedImage: $selectedImage)
			}
			.background(Color.white)
			.scrollDisabled(true)
        }
		.onTapGesture {
			hideKeyboard()
		}
		.tint(._333333)
        .background(.white)
        .toolbar(.hidden, for: .navigationBar)
    }
	
	private func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}

struct ImageSelectedView: View {
	
    @Binding var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    private let imageHeight: CGFloat = 196
    
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				// 이미지 선택 버튼
				PhotosPicker(selection: $selectedItem, matching: .images) {
					ZStack {
						RoundedRectangle(cornerRadius: 14)
							.fill(Color.F_5_F_5_F_5)
							.frame(width: geometry.size.width, height: imageHeight)
						
						Image(.iconAddPhoto)
					}
				}
				.onChange(of: selectedItem) { _, newItem in
					Task { @MainActor in
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
						.frame(width: geometry.size.width, height: imageHeight)
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
			}
		}
		.frame(height: imageHeight)
	}
}
