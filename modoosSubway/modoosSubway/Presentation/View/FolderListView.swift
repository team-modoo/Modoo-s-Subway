//
//  FolderListView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/10/24.
//

import SwiftUI

struct FolderListView: View {
    let list = [1,2,3,4,5]
    var contents = ["집으로 가는길", "퇴근길", "병원 가는길", "맛집 지도"]
    var body: some View {
        List(contents,id: \.self) { items in
            FolderListCell(contents: items)
                .listRowInsets(EdgeInsets())
                .frame(height: 110)
        }
        .listStyle(.plain)
    }
}

struct FolderListCell: View {
    let line = ["7", "서해", "1","경의중앙"]
    var contents = ""
    init(contents:String) {
        self.contents = contents
    }
    
    
    var body: some View {
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
            
            Text("\(contents)")
                .font(.pretendard(size: 24, family: .regular))
                .foregroundStyle(.black)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 16, trailing: 0))
               // .background(.red)
            
        }
       // .background(.red)
            
       
    }
}
