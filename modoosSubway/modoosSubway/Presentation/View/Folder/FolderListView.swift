//
//  FolderListView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/10/24.
//

import SwiftUI

struct FolderListView: View {
    let folder: [Folder]
    let list = [1,2,3,4,5]
    var body: some View {
        List(folder,id: \.self) { folders in
            FolderListCell(folders: folders)
                .listRowInsets(EdgeInsets())
                .frame(height: 110)
        }
        .listStyle(.plain)
    }
}

struct FolderListCell: View {
    let line = ["7", "서해", "1","경의중앙"]
    @State private var showModal = false
    var folders:Folder
    init(folders:Folder) {
        self.folders = folders
    }
    
    
    var body: some View {
        //   NavigationLink(destination: FilteredStarView(folder: folders)) {
        VStack(alignment: .leading) {
            HStack {
                HStack{
                    ForEach(folders.lineNumber,id: \.self) { line in
                        Text(line.replacingOccurrences(of: "0", with: "")
                            .replacingOccurrences(of: "호선", with: "")
                            .replacingOccurrences(of: "선", with: ""))
                            .font(.pretendard(size: 14, family: .regular))
                            .tint(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7.5)
                            .background(Capsule().fill(Util.getLineColor(line)))
                            .foregroundColor(.white)
                    }
                }
                //.background(.yellow)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
                
                Spacer()
                
                
                Button {
                    print("icon_More")
                    showModal.toggle()
                } label: {
                    Image("icon_more")
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    
                    
                }
                .buttonStyle(.borderless)
            }
            
            Spacer()
            
            Text("\(folders.title)")
                .font(.pretendard(size: 20, family: .regular))
                .foregroundStyle(.black)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 16, trailing: 0))
        }
        .sheet(isPresented: $showModal) {
            EditFolderView(folder: folders)
                .presentationDetents([.fraction(1/4)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(30)
        }

        .background(
            NavigationLink("", destination: FolderDetailView(folder: folders))
                .opacity(0)
            
        )
        
    }
}


