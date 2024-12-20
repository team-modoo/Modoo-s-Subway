//
//  StarHeaderView.swift
//  modoosSubway
//
//  Created by 김지현 on 12/16/24.
//

import SwiftUI

struct StarHeaderView: View {
	@Binding var viewType: FolderType
	@Binding var sortedType: StarSortedType
	@Binding  var expressActiveState: Bool
	@State private var selectedDirection: Direction? = nil
	
	enum Direction {
		case upward // 상행/외선
		case downward // 하행/내선
	}
	
	var body: some View {
		HStack {
			
			Button {
				sortedType = .all
				print("전체")
			} label: {
				if sortedType == .all {
					Text("전체")
						.font(.pretendard(size: 16, family: .semiBold))
                        .foregroundStyle(._333333)
				} else {
					Text("전체")
						.font(.pretendard(size: 16, family: .regular))
                        .foregroundStyle(.BFBFBF)
				}
			}
			
			Rectangle()
				.frame(width: 1,height: 12)
				.foregroundStyle(.gray)
			
			Button {
				sortedType = .upLine
				print("상행선")
			} label: {
				if sortedType == .upLine {
					Text("상행선")
						.font(.pretendard(size: 16, family: .semiBold))
                        .foregroundStyle(._333333)
				} else {
					Text("상행선")
						.font(.pretendard(size: 16, family: .regular))
                        .foregroundStyle(.BFBFBF)
				}
			}
			
			Rectangle()
				.frame(width: 1,height: 12)
				.foregroundStyle(.gray)
			
			Button {
				sortedType = .downLine
				print("하행선")
			} label: {
				if sortedType == .downLine {
					Text("하행선")
						.font(.pretendard(size: 16, family: .semiBold))
						.foregroundStyle(._333333)
				} else {
					Text("하행선")
						.font(.pretendard(size: 16, family: .regular))
						.foregroundStyle(.BFBFBF)
				}
			}
			
			Spacer()
			
			Toggle(isOn: $expressActiveState, label: {
				expressActiveState ? Image(.expressActive) : Image(.expressInactive)
			})
			.toggleStyle(.button)
			.buttonStyle(.plain)
			.padding(.leading, 16)
			
		}
	}
	
	private func changeViewType(_ type: FolderType) {
		viewType = type
	}
	
	private func changeSortedType(_ type: StarSortedType) {
		sortedType = type
	}
}

