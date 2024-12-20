//
//  FolderListView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/10/24.
//

import SwiftUI

struct FolderListView: View {
    
    @State private var showModal = false
    var folder: Folder
	
    init(folder: Folder) {
        self.folder = folder
    }
    
	var body: some View {
		ZStack {
			NavigationLink(destination: FolderDetailView(folder: folder)) {
				VStack(alignment: .leading, spacing: 16) {
					HStack {
						HStack{
							ForEach(folder.lineNumber,id: \.self) { line in
								Text(line.replacingOccurrences(of: "0", with: ""))
									.font(.pretendard(size: 14, family: .regular))
									.tint(.white)
									.padding(.horizontal, 14)
									.padding(.vertical, 7.5)
									.background(Capsule().fill(Util.getLineColor(line)))
									.foregroundColor(.white)
							}
						}
						
						Spacer()
						
						Button {
							showModal.toggle()
						} label: {
							Image("icon_more")
						}
						.buttonStyle(.borderless)
					}
					
					Text(folder.title)
						.font(.pretendard(size: 20, family: .medium))
						.foregroundStyle(._333333)
						.padding(.bottom, 4)
					
					Rectangle()
						.frame(height: 1)
						.foregroundStyle(.D_9_D_9_D_9)
				}
				.padding(.top, 20)
				.sheet(isPresented: $showModal) {
					EditFolderView(folder: folder)
						.presentationDetents([.fraction(1/4)])
						.presentationDragIndicator(.visible)
						.presentationCornerRadius(30)
				}
			}
		}
	}
}
