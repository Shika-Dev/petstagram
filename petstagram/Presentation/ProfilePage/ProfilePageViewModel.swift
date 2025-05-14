//
//  ProfilePageViewModel.swift
//  petstagram
//
//  Created by Parama Artha on 08/05/25.
//

import Foundation

@MainActor
final class ProfilePageViewModel: ObservableObject {
    @Published var imgUrl: String = ""
    @Published var bio: String = ""
    @Published var username: String = ""
    @Published var fullName: String = ""
    @Published var dateOfBirth: String = ""
    @Published var userDateOfBirth: Date = Date()
    @Published var showEditInfoSheet = false
    @Published var showEditLifeEventSheet = false
    @Published var error: String?
    @Published var isLoading: Bool = false
    
    @Published var name: String = ""
    @Published var born: String = ""
    @Published var gender: String = ""
    @Published var breed: String = ""
    @Published var favoriteToy: String = ""
    @Published var habits: String = ""
    @Published var characteristics: String = ""
    @Published var favoriteFood: String = ""
    
    @Published var listLifeEvents: [[String: String]] = []
    
    @Published var posts: [PostEntity] = []
    
    private let authStateManager: AuthStateManager
    private let userDefaultsManager: UserDefaultsManager
    private let useCase: UserUseCases
    private let postUseCase: PostUseCases
    
    init(authStateManager: AuthStateManager, useCase: UserUseCases, userDefaultsManager: UserDefaultsManager, postUseCase: PostUseCases) {
        self.authStateManager = authStateManager
        self.userDefaultsManager = userDefaultsManager
        self.useCase = useCase
        self.postUseCase = postUseCase
        getUserData()
        fetchUserPost()
    }
    
    func getUserData() {
        Task {
            do {
                guard let uid = userDefaultsManager.userUID else {
                    print("Error: UID is nil in UserDefaults")
                    return
                }
                
                guard let user = try await useCase.getUser(uid: uid) else { return }
                
                imgUrl = user.profileImageUrl ?? ""
                bio = user.bio ?? ""
                username = user.userName
                fullName = user.fullName
                userDateOfBirth = user.dateOfBirth
                
                let date = user.dateOfBirth
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMMM yyyy"
                let dateString = formatter.string(from: date)
                
                dateOfBirth = dateString
                
                name = user.info.name
                born = user.info.born
                gender = user.info.gender
                breed = user.info.breed
                favoriteToy = user.info.favoriteToy
                habits = user.info.habits
                characteristics = user.info.characteristics
                favoriteFood = user.info.favoriteFood
                listLifeEvents = user.lifeEvents
            } catch {
                print("Error getting user data: \(error.localizedDescription)")
            }
        }
    }
    
    func saveInfo() {
        guard !name.isEmpty, !born.isEmpty, !gender.isEmpty, !breed.isEmpty else {
            error = "Please fill in all required fields"
            return
        }
        
        guard let uid = userDefaultsManager.userUID else {
            error = "User not authenticated"
            return
        }
        
        isLoading = true
        error = nil
        
        Task {
            do {
                let user = UserEntity(
                    uid: uid,
                    fullName: fullName,
                    userName: username,
                    dateOfBirth: userDateOfBirth,
                    bio: bio,
                    info: InfoData(
                        name: name, born: born, gender: gender, breed: breed, favoriteToy: favoriteToy, habits: habits, characteristics: characteristics, favoriteFood: favoriteFood
                    ),
                    lifeEvents: listLifeEvents
                )
                
                // Pass the new image if there is one, otherwise just update the text fields
                try await useCase.createOrUpdateUser(
                    user: user, newImage: nil
                )
                
            } catch {
                self.error = error.localizedDescription
            }
            
            isLoading = false
            showEditInfoSheet = false
        }
    }
    
    func fetchUserPost() {
        Task {
            do {
                posts = try await postUseCase.fetchUserPosts()
            } catch {
                print("Error getting user data: \(error.localizedDescription)")
            }
        }
    }
    
    func signOut() {
        do {
            try authStateManager.signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
