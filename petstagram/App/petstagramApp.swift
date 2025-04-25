//
//  petstagramApp.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import SwiftUI

@main
struct petstagramApp: App {
    var body: some Scene {
        WindowGroup {
            let repository = RepositoriesImpl()
            let postUseCase = PostUseCaseAdapter(repository: repository)
            ContentView()
        }
    }
}
