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
    @Query(sort: \Folder.timestamp, order: .reverse) private var folders: [Folder]
    let card: CardViewEntity
    let currentFolder: Folder?
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    init(card: CardViewEntity, currentFolder: Folder? = nil) {
        self.card = card
        self.currentFolder = currentFolder
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
                            if item.cardIDs.contains(card.id) {
                                // 이미 있는 경우 알림만 표시
                                alertMessage = "\(item.title) 폴더에\n이미 저장된 카드입니다"
                                showAlert = true
                            } else {
                                // 없는 경우 저장
                                if currentFolder != nil {
                                    
                                          // 폴더 안에서 호출된 경우 -> 이동
                                          moveCardToFolder(item)
                                      } else {
                                          // StarView에서 호출된 경우 -> 추가
                                          saveCardToFolder(item)
                                      }
                            }
                            //
                            //
                            //                            selectedFolder = item
                            //                            saveCardToFolder(item)
                        } label: {
                            //                            if let selected = selectedFolder,
                            //                               selected == item {
                            //                                Image("icon-check")
                            //                            } else {
                            //                                Image("icon_plus")
                            //                            }
                            if item.cardIDs.contains(card.id) {
                                Image("icon-check")
                            } else {
                                Image("icon_plus")
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    
                }
                
                if currentFolder == nil {
                
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
                .background(.red)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            }
                
            }
            .scrollIndicators(.hidden)
            .background(.white)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .padding(.top, 16)
            
            
            Spacer()
        }
        .task {
            
            
            
            for folder in folders {
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
    
    private func moveCardToFolder(_ targetFolder: Folder) {
        if targetFolder.cardIDs.contains(card.id) {
            alertMessage = "\(targetFolder.title) 폴더에\n이미 저장된 카드입니다"
            showAlert = true
            return
        }
        
        // 현재 폴더에서 제거
        if let currentFolder = currentFolder {
            currentFolder.cardIDs.removeAll { $0 == card.id }
            try? modelContext.save()
        }

        // 새 폴더에 추가
        targetFolder.cardIDs.append(card.id)
        if !targetFolder.lineNumber.contains(card.lineNumber) {
            targetFolder.lineNumber.append(card.lineNumber)
        }
        try? modelContext.save()
        
        alertMessage = "\(targetFolder.title) 폴더에\n이동되었습니다"
        showAlert = true
    }
}
