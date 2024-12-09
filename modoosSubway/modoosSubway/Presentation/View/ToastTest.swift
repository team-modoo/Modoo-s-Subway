//
//  ToastTest.swift
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
                    title: toast.title) {
                        dismissToast()
                    }
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
    func toastView(toast: Binding<FancyToast?>) -> some View {
        self.modifier(FancyToastModifier(toast: toast))
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
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Image("icon_star_yellow_big")
                    .foregroundColor(type.themeColor)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)

                }
                
                Spacer(minLength: 10)
                
                Button {
                    homeViewModel.changeViewType(.Star)
                    dismiss()  // SelectedStationView 닫기
                } label: {
                    Text("이동하기")
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                            )
                        
                }
            }
            .padding()
        }
        .background(Color.black.opacity(0.5))
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(23)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
    }
}
