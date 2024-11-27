//
//  AddFolderView.swift
//  modoosSubway
//
//  Created by 김지현 on 11/17/24.
//

import SwiftUI
import SwiftData

struct AddFolderView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var selectedFolder: Folder?
    @State private var showCreateFolder = false
    @State private var folders: [Folder] = []
    let card: CardViewEntity
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    init(card: CardViewEntity) {
        self.card = card
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("폴더 이동하기")
                    .font(.pretendard(size: 20, family: .bold))
                    .foregroundStyle(.black)
                Spacer()
            }
            
            List {
                ForEach(folders,id: \.self) { item in
                    HStack {
                        Text(item.title)
                            .font(.pretendard(size: 16, family: .medium))
                            .tint(._333333)
                        
                        Spacer()
                        
                        Button {
                            selectedFolder = item
                            saveCardToFolder(item)
                        } label: {
                            if let selected = selectedFolder,
                               selected == item {
                                Image("icon-check")
                            } else {
                                Image("icon_plus")
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    
                }
        
                VStack(spacing: 8) {
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.D_9_D_9_D_9)
                        .listRowInsets(EdgeInsets())
                    
                    
                    HStack {
                        
                        Image("icon_folder")
                            .resizable()
                            .frame(width: 18,height: 18)
                        
                        Text("폴더 추가하기")
                            .font(.pretendard(size: 16, family: .medium))
                            .tint(._333333)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showCreateFolder = true
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    
                    
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                
            }
            .scrollIndicators(.hidden)
            .background(.white)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .padding(.top, 16)
            
            
            Spacer()
        }
        .task {
            let allFolders = DataManager.shared.getAllFolders()
            self.folders = allFolders
            for folder in allFolders {
                
                let imageSize: String
                if let base64String = folder.backgroundImage,
                   let imageData = Data(base64Encoded: base64String),
                   let image = UIImage(data: imageData) {
                    let dimensions = "(\(Int(image.size.width)) x \(Int(image.size.height)))"
                    let fileSize = Double(imageData.count) / 1024.0
                    imageSize = "\(dimensions), \(String(format: "%.2f", fileSize))KB"
                } else {
                    imageSize = "이미지 없음"
                }
                
                let imagePreview = folder.backgroundImage?.prefix(100)
                print("""
                      ID: \(folder.id)
                      제목: \(folder.title)
                      내용: \(String(describing: folder.content))
                      호선: \(folder.lineNumber)
                      이미지 존재 여부: \(folder.backgroundImage != nil ? "있음" : "없음")
                      이미지 데이터 길이: \(folder.backgroundImage?.count ?? 0)
                      이미지 미리보기: \(imagePreview ?? "없음")...
                      이미지 크기: \(imageSize)
                      저장된 카드 목록: \(folder.cardIDs)
                      --------------------------------
                      """)
            }
        }
        .padding(.top,30)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .sheet(isPresented: $showCreateFolder) {
            FolderFormView(formType: .create)
        }
        .alert("알림", isPresented: $showAlert) {
            Button("확인") {
                if alertMessage.contains("저장되었습니다") {
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    private func saveCardToFolder(_ folder: Folder) {

        if folder.cardIDs.contains(card.id) {
            alertMessage = "\(folder.title) 폴더에\n이미 저장된 카드입니다"
            showAlert = true
            return
        }
        
        folder.cardIDs.append(card.id)
        if !folder.lineNumber.contains(card.lineNumber) {
            folder.lineNumber.append(card.lineNumber)
        }

        try? modelContext.save()

        alertMessage = "\(folder.title) 폴더에\n저장되었습니다"
        showAlert = true
    }
}
