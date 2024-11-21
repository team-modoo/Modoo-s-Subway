//
//  AddFolderView.swift
//  modoosSubway
//
//  Created by 김지현 on 11/17/24.
//

import SwiftUI

struct AddFolderView: View {
	let folders: [String] = ["집으로 가는 길", "전철 타고 춘천 여행", "할머니댁에 가는 길", "퇴근하고 싶은 출근 길"]
	
	var body: some View {
		NavigationView {
			VStack {
				HStack {
					Text("폴더 이동하기")
						.font(.pretendard(size: 20, family: .bold))
						.tint(._333333)
						.padding(.leading, 20)
					
					Spacer()
				}
				.padding(.top, 20)
				.background(.white)
				
				List {
					ForEach(folders,id: \.self) { el in
						HStack {
							Text(el)
								.font(.pretendard(size: 16, family: .medium))
								.tint(._333333)
							
							Spacer()
							
							Image(.iconCheck)
						}
						.padding(.horizontal, 20)
					}
				}
				.padding(.top, 16)
				.background(.white)
				.listStyle(.plain)
				.scrollContentBackground(.hidden)
			}
		}
		
		
	}
}

#Preview {
	AddFolderView()
}