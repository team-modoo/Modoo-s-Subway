//
//  AddFolderView.swift
//  modoosSubway
//
//  Created by 김지현 on 11/17/24.
//

import SwiftUI

struct AddFolderView: View {
    @State private var selectedFolder: String?
    @State private var showCreateFolder = false
    let folders: [String] = ["집으로 가는 길", "전철 타고 춘천 여행", "할머니댁에 가는 길"]
    /*["집으로 가는 길", "전철 타고 춘천 여행", "할머니댁에 가는 길", "퇴근하고 싶은 출근 길","7호선 탐방기", "123","345","456"]*/
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
                        Text(item)
                            .font(.pretendard(size: 16, family: .medium))
                            .tint(._333333)
                        
                        Spacer()
                        
                        Button {
                            selectedFolder = item
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
        .padding(.top,30)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .sheet(isPresented: $showCreateFolder) {
            FolderFormView(formType: .create)
        }
    }
}
