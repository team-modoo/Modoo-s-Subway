//
//  FolderDecorateView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/11/24.
//

import SwiftUI

struct EditFolderView: View {
    let section1: [EditFolderType] = [.modify, .attach, .delete]
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("더보기")
                        .font(.pretendard(size: 20, family: .bold))
                        .foregroundStyle(.black)
                        .padding(.leading, 20)
                    
                    Spacer()
                }
                .padding(.top,20)
                .padding(.leading,8)
                .background(.white)
                
                Spacer(minLength: 16)
                
                List {
                    ForEach(section1,id: \.self) { item in
                        EditFolderCell(title: item.rawValue, 
                                       destination: item.destinationView(),
                                       iconName: item.iconImage())
                            .listRowSeparator(.hidden)
                            .frame(height: 19)
                            .foregroundStyle(.blue)
                    }
                }
                .background(.white)
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
            }
        }
        
        
    }
}

#Preview {
    EditFolderView()
}

struct EditFolderCell: View {
    private var infoType: EditFolderType = .modify
    private var destination: AnyView?
    private var title: String
    private var iconName: String
    @State private var showFullScreen = false
    @State private var selectedDestination: AnyView? = nil  //
    @Environment(\.dismiss) var dismiss
    
    
    init(title: String, destination: AnyView,iconName: String) {
        self.title = title
        self.destination = destination
        self.iconName = iconName
    }
    
    var body: some View {
        if let destination = destination {
            HStack {
                Image("\(iconName)")
                    .resizable()
                    .frame(width: 18,height: 18)
                
                Text("\(title)")
                    .font(.pretendard(size: 16, family: .regular))
                    .foregroundStyle(.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.black)
                
            }
            .background(.red)
            .onTapGesture {
                //       selectedDestination = destination  // destination 설정
                showFullScreen = true
                print("cell \(destination) clicked")
            }
            
            .fullScreenCover(isPresented: $showFullScreen) {
                NavigationStack {
                    
                    destination
                    
                }
            }
            
        }
        
    }
}

enum EditFolderType: String {
    case modify = "폴더 수정하기"
    case attach = "사진 첨부하기"
    case delete = "폴더 삭제하기"
  
    
    func destinationView() -> AnyView {
        switch self {
        case .modify:
            return AnyView(ModifyFolderView())
        case .attach:
            return AnyView(FolderListView())
        case .delete:
            return AnyView(FolderView())
        }
    }
    
    func iconImage() -> String {
        switch self {
        case .modify:
            return "icon_edit"
        case .attach:
            return "icon_photo"
        case .delete:
            return "icon_trash"
        }
    }
    
}
