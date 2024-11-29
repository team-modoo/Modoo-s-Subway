//
//  MoreMenuListView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/22/24.
//

import SwiftUI

struct MoreMenuListView: View {
    var moreMenuType: [MoreMenuType]
    let card: CardViewEntity
    let folder: Folder?
    
    init(card: CardViewEntity,folder:Folder? = nil) {
        self.card = card
        self.folder = folder
        self.moreMenuType = folder != nil ? [.moveFolder, .changeOrder] : [.moveFolder]
      }
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("더보기")
                        .font(.pretendard(size: 20, family: .bold))
                        .foregroundStyle(.black)
                
                    Spacer()
                }
                .padding(.top,30)
                .padding(.leading, 20)
            
                List {
                    ForEach(moreMenuType,id: \.self) { item in
                        MoreMeCell(iconImage:item.iconImage,
                                   titleLabel: item.rawValue,
                                   destination: item.destinationView(card:card, folder: folder),
                                   menuType: item)
                    }
                    .listRowSeparator(.hidden)
                }
                .padding(.top, 10)
                .listStyle(.plain)
            
                Spacer()
            }
        }
    }
}

struct MoreMeCell: View {
    var iconImage: String = ""
    var titleLabel: String = ""
    var destination:AnyView?
    var menuType: MoreMenuType
    let folder: Folder?
    @State private var showSheet = false
    @State private var showFullScreen = false
 
    
    init(iconImage: String, titleLabel: String,destination:AnyView,menuType:MoreMenuType,folder: Folder? = nil) {
        self.iconImage = iconImage
        self.titleLabel = titleLabel
        self.destination = destination
        self.menuType = menuType
        self.folder = folder
    }
    
    var body: some View {
        HStack {
            HStack {
                Image("\(iconImage)")
                    .resizable()
                    .frame(width: 18,height: 18)
                
                Text("\(titleLabel)")
                    .font(.pretendard(size: 16, family: .medium))
                    .foregroundStyle(.black)
                
            }
            Spacer()
 
                Image(systemName: "chevron.right")
                    .foregroundStyle(.black)

        }
        .background(.red)
        .onTapGesture {
            switch menuType {
            case .moveFolder:
                showSheet = true
            case .changeOrder:
                showFullScreen = true
            }
                  
        }
        .sheet(isPresented: $showSheet) {
            NavigationStack {
                destination
            }
            .presentationDetents([.fraction(0.5)])
        }
                
        .fullScreenCover(isPresented: $showFullScreen) {
            NavigationStack {
                destination
            }
        }
    }
}

enum MoreMenuType: String {
    case moveFolder = "폴더 이동하기"
    case changeOrder = "순서 변경하기"
    
    func destinationView(card:CardViewEntity,folder:Folder?) -> AnyView {
        switch self {
        case .moveFolder:
            return AnyView(AddFolderView(card: card,currentFolder: folder))
        case .changeOrder:
            if let folder = folder {
                return AnyView(FilteredStarView(folder: folder, isEditingMode: true))
            }
            return AnyView(EmptyView())
        }
    }
    
    var iconImage: String {
        switch self {
        case .moveFolder:
             "icon_folder"
        case .changeOrder:
            "icon_sequence"
        }
    }

}
