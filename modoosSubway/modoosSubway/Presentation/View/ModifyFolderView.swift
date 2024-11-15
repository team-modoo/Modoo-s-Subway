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
                    Text("폴더명 수정하기")
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
            
            FolderCardView()
                .padding(.top, 20)
            Spacer()
            
            
        }
        .background(.white)
        .toolbar(.hidden, for: .navigationBar)

    }
}
