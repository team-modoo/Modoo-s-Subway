//
//  FolderHeaderView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/10/24.
//

import SwiftUI

struct FolderHeaderView: View {
    @Binding var viewType: FolderType
    @Binding var sortedType: FolderSortedType
    
    var body: some View {
        HStack {
			Button {
				sortedType = .latest
			} label: {
				if sortedType == .latest {
					Text("최신순")
						.font(.pretendard(size: 16, family: .semiBold))
						.foregroundStyle(._333333)
				} else {
					Text("최신순")
						.font(.pretendard(size: 16, family: .regular))
						.foregroundStyle(.BFBFBF)
				}
			}
			
			Rectangle()
				.frame(width: 1,height: 12)
                .foregroundStyle(.EDEDED)
             
            Button {
                sortedType = .name
            } label: {
                if sortedType == .name {
                    Text("이름순")
                        .font(.pretendard(size: 16, family: .semiBold))
                        .foregroundStyle(._333333)
                } else {
                    Text("이름순")
                        .font(.pretendard(size: 16, family: .regular))
                        .foregroundStyle(.BFBFBF)
                }
            }
            
            Spacer()
            
            Button {
                changeViewType(.Card)
            } label: {
                if viewType == .Card {
                    Image("dashboard.fill")
                } else {
                    Image("dashboard")
                }
            }
            
            Rectangle()
                .frame(width: 1,height: 12)
                .foregroundStyle(.EDEDED)
            
            Button {
                changeViewType(.List)
            } label: {
                if viewType == .List {
                    Image("bullet-list.fill")
                        
                } else {
                    Image("bullet-list")
                }
            }
       }
    }
    
    private func changeViewType(_ type: FolderType) {
        viewType = type
    }
    
    private func changeSortedType(_ type: FolderSortedType) {
        sortedType = type
    }
}
