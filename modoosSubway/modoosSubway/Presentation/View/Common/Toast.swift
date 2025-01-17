//
//  Toast.swift
//  modoosSubway
//
//  Created by 임재현 on 11/29/24.
//

import SwiftUI

enum FancyToastStyle {
    case success
    case info
}

extension FancyToastStyle {
    var themeColor: Color {
        switch self {
        case .info: return Color.blue
        case .success: return Color.green
        }
    }
    
    var iconFileName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"

        }
    }
}

struct FancyToast: Equatable {
    var type: FancyToastStyle
    var title: String
    var duration: Double = 3
}

struct FancyToastModifier: ViewModifier {
    @Binding var toast: FancyToast?
    @State private var workItem: DispatchWorkItem?
    var onMoveToStarView: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .offset(y: -30)
                }.animation(.spring(), value: toast)
            )
            .onChange(of: toast) { _, value in
                showToast()
            }
    }
	
	@ViewBuilder func mainToastView() -> some View {
		if let toast = toast {
			VStack {
				Spacer()
				FancyToastView(
					type: toast.type,
					title: toast.title,
					onCancelTapped: {
						dismissToast()
					},
					onMoveToStarView: onMoveToStarView  // 콜백 전달
				)
			}
			.transition(.move(edge: .bottom))
		}
	}
	
	private func showToast() {
		guard let toast = toast else { return }
		
		UIImpactFeedbackGenerator(style: .light).impactOccurred()
		
		if toast.duration > 0 {
			workItem?.cancel()
			
			let task = DispatchWorkItem {
				dismissToast()
			}
			
			workItem = task
			DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
		}
	}
	
	private func dismissToast() {
		withAnimation {
			toast = nil
		}
		
		workItem?.cancel()
		workItem = nil
	}
}

extension View {
    func toastView(toast: Binding<FancyToast?>, onMoveToStarView: (() -> Void)? = nil) -> some View {
           self.modifier(FancyToastModifier(toast: toast, onMoveToStarView: onMoveToStarView))
       }
}

struct ContentView: View {
    var body: some View {
        TabView {
            VStack {
                EmptyView()
            }
            .tabItem {
                Text("기본검색")
            }
            VStack {
                ToastBasicView()
            }
            .tabItem {
                Text("토스트")
            }
            VStack {
                EmptyView()
            }
            .tabItem {
                Text("연습")
            }
            VStack {
                EmptyView()
            }
            .padding()
            .tabItem {
                Text("커스텀검색")
            }
        }
    }
}

struct ToastBasicView: View {
    @State private var toast: FancyToast? = nil
    var body: some View {
        VStack {
            Button {
                toast = FancyToast(type: .info, title: "제목으로 안내해봅니다")
            } label: {
                Text("안내")
            }

            Button {
                toast = FancyToast(type: .success, title: "제목으로 성공 알립니다")
            } label: {
                Text("성공")
            }
            
        }
        .toastView(toast: $toast)
    }
}

struct FancyToastView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    var type: FancyToastStyle
    var title: String
    var onCancelTapped: (() -> Void)
    var onMoveToStarView: (() -> Void)?
	
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
				Image(.iconStarYellow)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)

                }
                
                Spacer(minLength: 10)
                
                Button {
                    onMoveToStarView?()
                  
                } label: {
                    Text("이동하기")
						.foregroundColor(._333333)
						.font(.pretendard(size: 14, family: .medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white)
                            )
                        
                }
            }
            .padding()
        }
        .background(Color.black.opacity(0.5))
        .frame(minWidth: 0, maxWidth: 350)
		.frame(height: 56)
        .cornerRadius(28)
        .padding(.horizontal, 16)
    }
}
