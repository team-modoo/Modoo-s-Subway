//
//  CoachMarkTest.swift
//  modoosSubway
//
//  Created by 임재현 on 12/9/24.
//

import UIKit
import Instructions
import SwiftUI

struct CoachMarkView: View {
    let page: String
    let attributedTitle: AttributedString
    let onNext: () -> Void
    
    static func createAttributedTitle(normalText1: String, highlightedText: String, normalText2: String) -> AttributedString {
        var attributed = AttributedString(normalText1)
        attributed.font = .system(size: 16)
        
        var highlighted = AttributedString(highlightedText)
        highlighted.foregroundColor = .green
        highlighted.font = .system(size: 16, weight: .bold)
        
        var attributed2 = AttributedString(normalText2)
        attributed2.font = .system(size: 16)
        
        attributed.append(highlighted)
        attributed.append(attributed2)
        
        return attributed
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(page)
                .font(.system(size: 14))
                .foregroundColor(.green)
            
            Text(attributedTitle)
                .font(.system(size: 16, weight: .bold))
                .multilineTextAlignment(.leading)
            
            HStack {
                Spacer()
                Button(action: onNext) {
                    Text("다음")
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .cornerRadius(20)
                }
            }
        }
        .padding(16)
        .background(
            CustomShape()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
        )
    }
}

// CustomShape.swift
struct CustomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX - 10, y: 0))
        path.addLine(to: CGPoint(x: rect.midX, y: -10))
        path.addLine(to: CGPoint(x: rect.midX + 10, y: 0))
        
        let roundedRect = UIBezierPath(roundedRect: rect,
                                     cornerRadius: 12)
        path.addPath(Path(roundedRect.cgPath))
        
        return path
    }
}

