//
//  modoosSubwayApp.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/20.
//

import SwiftUI
import SwiftData

@main
struct modoosSubwayApp: App {
    let container = DIContainer()
    @State var isSplashView = true
    @State private var isFirstLaunch = true
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
			Folder.self,
			Star.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if isSplashView {
                LaunchScreenView()
                    .ignoresSafeArea()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                            isSplashView = false
                        }
                    }
                   
            } else {
                if !hasLaunchedBefore  {
                    DemoStartView()
                } else {
                    HomeView(container: container)
                }
            }
            //SettingView()
         
        }
        .modelContainer(sharedModelContainer)
    }
}




//@main
//struct CampairApp: App {
//    @State var isSplashView = true
//    var body: some Scene {
//        WindowGroup {
//            if isSplashView {
//                LaunchScreenView()
//                    .ignoresSafeArea()
//                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//                            isSplashView = false
//                        }
//                    }
//            } else {
//                TabbarView()
//            }
//        }
//    }
//}

struct LaunchScreenView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIStoryboard(name: "Launch Screen", bundle: nil).instantiateInitialViewController()!
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct DemoStartView: View {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("지하철 앱에 오신 것을 환영합니다!")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("앱 사용이 처음이시네요!")
                .font(.headline)
            
            Button(action: {
                // UserDefaults에 값을 저장하고 상태를 업데이트
                hasLaunchedBefore = true
            }) {
                Text("시작하기")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}
