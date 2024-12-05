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
                FolderListCell(contents: folders)
                    .listRowInsets(EdgeInsets())
                    .frame(height: 110)
            }
            .listStyle(.plain)
    }
}

struct FolderListCell: View {
    let line = ["7", "서해", "1","경의중앙"]
    var contents:Folder
    init(contents:Folder) {
        self.contents = contents
    }
    
    
    var body: some View {
        NavigationLink(destination: FilteredStarView(folder: contents)) {
        VStack(alignment: .leading) {
            HStack {
                HStack{
                    ForEach(line,id: \.self) { line in
                        Text("\(line)")
                            .font(.pretendard(size: 14, family: .regular))
                            .tint(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7.5)
                            .background(Capsule().fill(.blue))
                            .foregroundColor(.white)
                    }
                }
                //.background(.yellow)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
                
                Spacer()
                
                
                Button {
                    print("icon_More")
                } label: {
                    Image("icon_more")
                    // .background(.red)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    
                    
                }
                .buttonStyle(.borderless)
            }
            
            Spacer()
            
            Text("\(contents.title)")
                .font(.pretendard(size: 24, family: .regular))
                .foregroundStyle(.black)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 16, trailing: 0))
            }
        }
    }
}


