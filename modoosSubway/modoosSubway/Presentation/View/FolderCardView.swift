//
//  FolderCardView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/10/24.
//

import SwiftUI

struct FolderCardView: View {
    @State private var showModal = false
    let folder: Folder
    let line = ["7", "서해", "1","경의중앙"]
    
    var body: some View {
        ZStack {
            FolderBackgroundImage(imageString: folder.backgroundImage)
                .frame(width: 340, height: 196)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            // 그 위에 콘텐츠를 배치
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        ForEach(line, id: \.self) { line in
                            Text("\(line)")
                                .font(.pretendard(size: 14, family: .regular))
                                .tint(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7.5)
                                .background(Capsule().fill(.blue))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
                    
                    Spacer()
                    
                    Button {
                        print("icon_More")
                        showModal.toggle()
                    } label: {
                        Image("icon_more")
                            .background(.red)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                    }
                }
                
                Spacer()
                
                Text("\(folder.title)")
                    .font(.pretendard(size: 24, family: .bold))
                    .foregroundStyle(.white)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 16, trailing: 0))
            }
            .frame(width: 340, height: 196)
        }
        .sheet(isPresented: $showModal) {
            EditFolderView()
                .presentationDetents([.fraction(1/4)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(30)
        }
    }
}

   
