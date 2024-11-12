//
//  FolderCardView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/10/24.
//

import SwiftUI

struct FolderCardView: View {
    @State private var showModal = false
    let line = ["7", "서해", "1","경의중앙"]
    var body: some View {
        VStack(alignment: .leading) {
            HStack  {
                HStack {
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
               // .background(.yellow)
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
                
                  .sheet(isPresented: $showModal) {
                      
                          EditFolderView()
                              .presentationDetents([.fraction(1/4)])
                              .presentationDragIndicator(.visible)
                              .presentationCornerRadius(30)
                  }
           }
            
            
            Spacer()
            
            Text("집으로 가는길")
                .font(.pretendard(size: 24, family: .bold))
                .foregroundStyle(.white)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 16, trailing: 0))
        }
        .frame(width: 340, height: 196)
        .background(
            Image("image 5 (1)")
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
        )
    }
}



