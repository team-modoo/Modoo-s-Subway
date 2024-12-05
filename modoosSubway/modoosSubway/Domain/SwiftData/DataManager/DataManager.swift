//
//  DataManager.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/21.
//

import SwiftData
import SwiftUI

class DataManager {
	static let shared = DataManager()
	private var modelContext: ModelContext?
	
	func setModelContext(_ context: ModelContext) {
		self.modelContext = context
	}
	
	// MARK: - 즐겨찾기 추가
	func addStar(item: Star) {
		modelContext?.insert(item)
		print("add star complete \(item)")
	}
	
	// MARK: - 즐겨찾기 제거
	func deleteStar(item: Star) {
		modelContext?.delete(item)
		print("delete star complete \(item)")
	}
    
    //MARK: - 폴더 추가
    func createFolder(title: String,content: String?, image: UIImage?, context: ModelContext) {
           // 이미지 데이터를 문자열로 변환 (Base64)
           let imageString: String?
           if let image = image {
               let optimizedImage = optimizeImage(image)
               if let imageData = optimizedImage.jpegData(compressionQuality: 0.7) {
                   imageString = imageData.base64EncodedString()
                   print("원본 이미지 크기: \(image.size)")
                   print("최적화된 이미지 크기: \(optimizedImage.size)")
                   print("이미지 데이터 크기: \(Double(imageData.count) / 1024.0)KB")
               } else {
                   imageString = nil
               }
            
           } else {
               imageString = nil
           }
           let folder = Folder(
               timestamp: Date(),
               lineNumber: [], 
               title: title,
               content: content
           )
           folder.backgroundImage = imageString
           
           context.insert(folder)
           
           do {
               try context.save()
               print("""
                    폴더 생성 완료:
                    ID: \(folder.id)
                    제목: \(folder.title)
                    설명: \(folder.content ?? "설명 없음")
                    이미지 존재 여부: \(folder.backgroundImage != nil ? "O" : "X")
                    """)
           } catch {
               print("폴더 저장 실패: \(error)")
           }
       }
    //MARK: - 폴더 불러오기
    func getAllFolders() -> [Folder] {
           guard let context = modelContext else { return [] }
           
           let descriptor = FetchDescriptor<Folder>(
               sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
           )
           
           do {
               return try context.fetch(descriptor)
           } catch {
               print("Failed to fetch folders: \(error)")
               return []
           }
      }
      
    func updateFolder(_ folder: Folder, title: String? = nil, content: String? = nil,image:UIImage? = nil, context:ModelContext) {
        print("업데이트 전 폴더 상태:")
            print("ID: \(folder.id)")
            print("제목: \(folder.title)")
            print("설명: \(folder.content ?? "설명 없음")")
        
        if let title = title {
            folder.title = title
        }
        
        if let content = content {
            folder.content = content
        }
        
        if let image = image {
            let optimizedImage = optimizeImage(image)
            if let imageData = optimizedImage.jpegData(compressionQuality: 0.7) {
                folder.backgroundImage = imageData.base64EncodedString()
                print("원본 이미지 크기: \(image.size)")
                print("최적화된 이미지 크기: \(optimizedImage.size)")
                print("이미지 데이터 크기: \(Double(imageData.count) / 1024.0)KB")
            }
        }
        do {
            try context.save()
            print("""
                폴더 수정 완료:
                ID: \(folder.id)
                제목: \(folder.title)
                설명: \(folder.content ?? "설명 없음")
                이미지 존재 여부: \(folder.backgroundImage != nil ? "O" : "X")
                """)
        } catch {
            print("폴더 수정 실패: \(error)")
        }
        
    }
    
    func updateFolderCardOrder(_ folder:Folder, newOrder: [UUID],context:ModelContext) {
        print("카드 순서 업데이트 시작:")
        print("폴더 ID: \(folder.id)")
        print("이전 카드 순서: \(folder.cardIDs)")
        print("새로운 카드 순서: \(newOrder)")
        
        folder.cardIDs = newOrder
        
        do {
            try context.save()
            print("카드 순서 업데이트 완료")
        } catch {
            print("카드 순서 업데이트 실패: \(error)")
        }
    }
    
    
    //MARK: - 폴더 삭제하기
    func deleteFolder(_ folder:Folder, context: ModelContext) {
        print("삭제 시도:")
        print("ID: \(folder.id)")
        print("제목: \(folder.title)")
      
        do {
            context.delete(folder)
            try context.save()
            
            print("""
                폴더 삭제 완료:
                ID: \(folder.id)
                제목: \(folder.title)
                """)
            let descriptor = FetchDescriptor<Folder>(
                sortBy: [SortDescriptor(\.timestamp,order: .reverse)]
            )
            if let remainingFolders = try? context.fetch(descriptor) {
                print("남은 폴더 수: \(remainingFolders.count)")
            }

        } catch {
            print("폴더 삭제 실패: \(error)")
        }
    }
    
     func removeCardFromFolder(cardID:UUID, folder:Folder, context: ModelContext) -> Bool {
        print("폴더에서 카드 제거 시작:")
        print("폴더: \(folder.title)")
        print("카드 ID: \(cardID)")
        
        folder.cardIDs.removeAll {$0 == cardID}
        
        do {
            try context.save()
            print("카드가 폴더에서 제거되었습니다")
            return true
        } catch {
            print("카드 제거 실패: \(error)")
            return false
        }
        
    }
    
    
    
    
    private func optimizeImage(_ image: UIImage) -> UIImage {
        let maxSize: CGFloat = 1024
        
        let scale = min(maxSize/image.size.width, maxSize/image.size.height)
        
        if scale >= 1 {
            return image
        }
        
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
   
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let optimizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return optimizedImage ?? image
    
    }
    
    
    
}
