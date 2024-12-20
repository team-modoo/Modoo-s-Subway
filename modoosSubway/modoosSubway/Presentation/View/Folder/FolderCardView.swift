	//
	//  FolderCardView.swift
	//  modoosSubway
	//
	//  Created by 임재현 on 11/10/24.
	//

import SwiftUI
import SwiftData

struct FolderCardView: View {
	
	@State private var showModal = false
	@State private var showAlert = false
	@State private var isRefreshing = false
	let folder: Folder
	
	private var cardHeight: CGFloat {
		folder.backgroundImage == nil ? 140 : 196
	}
	
	var body: some View {
		ZStack {
			NavigationLink(destination: FolderDetailView(folder: folder)) {
				ZStack {
					FolderBackgroundImage(imageString: folder.backgroundImage)
						.frame(width: .infinity, height: cardHeight)
						.clipShape(RoundedRectangle(cornerRadius: 14))
					
					Group {
						RoundedRectangle(cornerRadius: 14)
							.fill(._333333)
							.opacity(0.5)
					}
					.frame(width: .infinity, height: cardHeight)
					
					VStack(alignment: .leading) {
						HStack {
							HStack {
								ForEach(folder.lineNumber, id: \.self) { line in
									Text(line.replacingOccurrences(of: "0", with: ""))
										.font(.pretendard(size: 14, family: .regular))
										.tint(.white)
										.padding(.horizontal, 12)
										.padding(.vertical, 7.5)
										.background(Capsule().fill(Util.getLineColor(line)))
										.foregroundColor(.white)
								}
							}
							.padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
							
							Spacer()
						}
						
						Spacer()
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(folder.title)
                                .font(.pretendard(size: 20, family: .medium))
                                .foregroundStyle(.white)
                            
                            if let content = folder.content, !content.isEmpty {
                                Text(content)
                                    .font(.pretendard(size: 14, family: .regular))
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 0))
					}
					.frame(width: .infinity, height: cardHeight)
					
				}
			}
			
			VStack {
				HStack {
					Spacer()
					Button {
						showModal.toggle()
					} label: {
						Image(.iconMoreWhite)
							.padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 20))
					}
				}
				Spacer()
			}
			.frame(width: .infinity, height: cardHeight)
		}
		.sheet(isPresented: $showModal) {
			EditFolderView(folder: folder)
				.presentationDetents([.fraction(1/4)])
				.presentationDragIndicator(.visible)
				.presentationCornerRadius(30)
		}
	}
}
