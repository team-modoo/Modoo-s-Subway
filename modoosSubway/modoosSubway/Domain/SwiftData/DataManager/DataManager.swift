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
           if let image = image,
              let imageData = image.jpegData(compressionQuality: 0.7) {
               imageString = imageData.base64EncodedString()
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
               print("폴더가 성공적으로 저장되었습니다:")
               print("제목: \(title)")
               print("이미지 여부: \(image != nil)")
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
}
