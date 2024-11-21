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
    @State var isSplashView = true
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                            isSplashView = false
                        }
                    }
                   
            } else {
                HomeView()
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
