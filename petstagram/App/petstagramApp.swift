//
//  petstagramApp.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if !isRunningUnitTests() {
            FirebaseApp.configure()
        }
        return true
    }
    
    private func isRunningUnitTests() -> Bool {
        let env = ProcessInfo.processInfo.environment
        let isXCTest = env["XCTestConfigurationFilePath"]?.contains(".xctest") == true
        let isUITest = ProcessInfo.processInfo.arguments.contains("UITests")
        return isXCTest && !isUITest
    }
}

@main
struct petstagramApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            LoginPageView()
        }
    }
}
