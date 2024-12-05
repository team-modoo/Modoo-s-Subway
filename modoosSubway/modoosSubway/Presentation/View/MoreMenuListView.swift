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
        self.moreMenuType = folder != nil ? [.moveFolder, .changeOrder,.removeFolder] : [.moveFolder]
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
                        MoreMenuCell(iconImage:item.iconImage,
                                     titleLabel: item.rawValue,
                                     destination: item.destinationView(card:card, folder: folder),
                                     menuType: item,folder: folder,
                                     card: card)
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

struct MoreMenuCell: View {
    var iconImage: String = ""
    var titleLabel: String = ""
    var destination:AnyView?
    var menuType: MoreMenuType
    let folder: Folder?
    let card: CardViewEntity
    @Environment(\.modelContext) private var modelContext
    @State private var showSheet = false
    @State private var showFullScreen = false
    @State private var showAlert = false
    @State private var showCompletionAlert = false
    @Environment(\.dismiss) private var dismiss
 
    
    init(iconImage: String, 
         titleLabel: String,
         destination:AnyView,
         menuType:MoreMenuType,
         folder: Folder? = nil,
         card:CardViewEntity) {
        self.iconImage = iconImage
        self.titleLabel = titleLabel
        self.destination = destination
        self.menuType = menuType
        self.folder = folder
        self.card = card
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
            case .removeFolder:
                showAlert = true
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
        .alert("폴더에서 제거", isPresented: $showAlert) {
            Button("취소", role: .cancel) { }
            Button("제거", role: .destructive) {
                print("폴더에서 카드 제거 시작2222 ")
                if let folder = folder {
                    if DataManager.shared.removeCardFromFolder(cardID: card.id, folder: folder, context: modelContext) {
                        showCompletionAlert = true
                    }
                    print("폴더에서 카드 제거 시작 ")
                }
            }
        } message: {
            Text("이 카드를 폴더에서 제거하시겠습니까?")
        }
        .alert("완료", isPresented: $showCompletionAlert) {
                    Button("확인") {
                        dismiss()
                    }
                } message: {
                    Text("폴더에서 카드가 제거되었습니다.")
                }
    }
}

enum MoreMenuType: String {
    case moveFolder = "폴더 이동하기"
    case changeOrder = "순서 변경하기"
    case removeFolder = "폴더에서 삭제하기"
    
    func destinationView(card:CardViewEntity,folder:Folder?) -> AnyView {
        switch self {
        case .moveFolder:
            return AnyView(AddFolderView(card: card,currentFolder: folder))
        case .changeOrder:
            if let folder = folder {
                return AnyView(FilteredStarView(folder: folder, isEditingMode: true))
            }
            return AnyView(EmptyView())
        case .removeFolder:
            return AnyView(EmptyView())
        }
    }
    
    var iconImage: String {
        switch self {
        case .moveFolder:
             "icon_folder"
        case .changeOrder:
            "icon_sequence"
        case .removeFolder:
            "icon_trash"
        }
    }

}
