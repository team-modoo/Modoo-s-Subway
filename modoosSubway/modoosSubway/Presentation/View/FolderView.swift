//
//  FolderView.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/21.
//

import SwiftUI
import SwiftData

struct FolderView: View {
	@Environment(\.modelContext) private var modelContext
//    @Query private var folders: [Folder]
    @State private var viewType: FolderType = .Card
    @State private var sortedType: FolderSortedType = .name
    var item: [Int] = [1,2,3]
    
    var folders: [Folder] {
            let descriptor = FetchDescriptor<Folder>(
                sortBy: sortedType == .latest ?
                    [SortDescriptor(\Folder.timestamp, order: .reverse)] :
                    [SortDescriptor(\Folder.title, order: .forward)]
            )
            return (try? modelContext.fetch(descriptor)) ?? []
        }
    

	var body: some View {
        NavigationStack {
            VStack {
                GeometryReader(content: { geometry in
                    if  folders.isEmpty {
                        VStack {
                            Image(.bookmarkCircle)
                            Text("자주 타는 지하철 노선을 꾸며보세요")
                                .font(.pretendard(size: 16, family: .regular))
                                .foregroundStyle(Color("5C5C5C"))
                                .padding(.top, 8)
                        }
                        .frame(width: geometry.size.width, height: 196)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.EDEDED)
                        )
                        
                    } else {
                        VStack {
                            FolderHeaderView(viewType: $viewType,sortedType: $sortedType)
                            //Spacer()
                            
                            if viewType == .Card {
                                ScrollView(showsIndicators: false) {
                                    LazyVGrid(columns: [GridItem()],spacing: 16) {
                                        ForEach(folders, id: \.self) { folders in
                                            FolderCardView(folder: folders)
                                                .id(folders.id)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 24)
                                }
                            } else {
                                VStack {
                                    FolderListView(folder: folders)
                                }
                            }
                        }
                        
                    }
                })
            }
        }
        .onChange(of: folders) { old, new in
                 print("폴더 데이터 변경됨")
                 print("현재 폴더 개수: \(new.count)")
                 for folder in new {
                     print("폴더 ID: \(folder.id), 제목: \(folder.content)")
                 }
             }
        .task {
              let allFolders = DataManager.shared.getAllFolders()
              for folder in allFolders {
                  
                  let imageSize: String
                        if let base64String = folder.backgroundImage,
                           let imageData = Data(base64Encoded: base64String),
                           let image = UIImage(data: imageData) {
                           let dimensions = "(\(Int(image.size.width)) x \(Int(image.size.height)))"
                           let fileSize = Double(imageData.count) / 1024.0
                            imageSize = "\(dimensions), \(String(format: "%.2f", fileSize))KB"
                        } else {
                            imageSize = "이미지 없음"
                        }
                  
                  let imagePreview = folder.backgroundImage?.prefix(100)
                  print("""
                      ID: \(folder.id)
                      제목: \(folder.title)
                      내용: \(String(describing: folder.content))
                      호선: \(folder.lineNumber)
                      이미지 존재 여부: \(folder.backgroundImage != nil ? "있음" : "없음")
                      이미지 데이터 길이: \(folder.backgroundImage?.count ?? 0)
                       이미지 미리보기: \(imagePreview ?? "없음")...
                      이미지 크기: \(imageSize)
                      포함된 카드: \(folder.cardIDs)
                      폴더생성일시: \(folder.timestamp)
                      --------------------------------
                      """)
              }
          }
        .onAppear {
            print("folderview init()")

              }
		.padding(.top, 22)
	}
        
    // MARK: - 폴더 or 즐겨찾기
    private func changeViewType(_ type: FolderType) {
        viewType = type
    }
    
    private func changeSortedType(_ type: FolderSortedType) {
        sortedType = type
    }
	
	private func addItem() {
		withAnimation {
            let newItem = Folder(timestamp: Date(), lineNumber: ["1","3","7"], title: "123", content: "후후후후후")
			modelContext.insert(newItem)
            print("add item complete\(newItem)")
		}
	}
}




class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    func get(forkey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func set(_ image: UIImage, forkey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
}

struct FolderBackgroundImage: View {
    let imageString: String?
    @State private var image: UIImage?
    @State private var displayImage: UIImage?
    
    var body: some View {
        Group {
            if let uiImage = displayImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image("image 5 (1)")
            }
        }
        .task {
            await loadImage()
        }
        .onChange(of: imageString) { _, _ in
                   Task {
                       await loadImage()
                   }
               }
    }
    
    private func loadImage() async {
        guard let base64String = imageString else { return }
        
        if let cachedImage = ImageCache.shared.get(forkey: base64String) {
            displayImage = cachedImage
            return
        }
    
            if let imageData = Data(base64Encoded: base64String),
               let uiImage = UIImage(data: imageData) {
                ImageCache.shared.set(uiImage, forkey: base64String)
                await MainActor.run {
                   displayImage = uiImage
                }
            }
       
    }
}


