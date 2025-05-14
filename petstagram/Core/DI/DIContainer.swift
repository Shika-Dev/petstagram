import Foundation
import FirebaseFirestore

@MainActor
final class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    // MARK: - FirebaseFirestore
    lazy var firestore: Firestore = {
        return Firestore.firestore()
    }()
    
    //MARK: - Cloudinary
    lazy var claudinaryService: CloudinaryService = {
        return CloudinaryService()
    }()
    
    // MARK: - Network
     lazy var authService: AuthService = {
         return AuthService()
     }()
    
    lazy var userService: UserService = {
        return UserService(db: firestore, cloudinaryService: claudinaryService)
    }()
    
    lazy var postService: PostService = {
        return PostService(db: firestore, cloudinaryService: claudinaryService, userService: userService)
    }()
    
    // MARK: - Repositories
    lazy var repository: Repositories = {
        return RepositoriesImpl(authService: authService, userService: userService, postService: postService, userDefaultsManager: userDefaultsManager)
    }()
    
    // MARK: - UseCases
    lazy var userUseCase: UserUseCases = {
        return UserUseCaseAdapter(repository: repository)
    }()

    lazy var postUseCase: PostUseCases = {
        return PostUseCaseAdapter(repository: repository)
    }()
    
    lazy var authUseCase: AuthUseCases = {
        return AuthUseCaseAdapter(repository: repository)
    }()
    
    // MARK: - Managers
    lazy var userDefaultsManager: UserDefaultsManager = {
        return UserDefaultsManager()
    }()
    lazy var authStateManager: AuthStateManager = {
        return AuthStateManager(userDefaultsManager: userDefaultsManager)
    }()
    
    // MARK: - ViewModels
    func generateLoginPageViewModel() -> LoginPageViewModel {
        return LoginPageViewModel(useCase: authUseCase, authStateManager: authStateManager, userUseCase: userUseCase, userDefaultsManager: userDefaultsManager)
    }
    
    func generateRegisterPageViewModel() -> RegisterPageViewModel {
        return RegisterPageViewModel(useCase: authUseCase, authStateManager: authStateManager, userDefaultsManager: userDefaultsManager)
    }
    
    func generateEditProfilePageViewModel() -> EditProfilePageViewModel {
        return EditProfilePageViewModel(useCase: userUseCase, userDefaultsManager: userDefaultsManager)
    }
    
    func generateHomePageViewModel() -> HomePageViewModel {
        return HomePageViewModel(useCase: postUseCase, userDefaultsManager: userDefaultsManager)
    }
    
    func generateSelectPicturePageViewModel() -> SelectPicturePageViewModel {
        return SelectPicturePageViewModel(useCase: postUseCase)
    }
    
    func generateProfilePageViewModel() -> ProfilePageViewModel {
        return ProfilePageViewModel(authStateManager: authStateManager, useCase: userUseCase, userDefaultsManager: userDefaultsManager, postUseCase: postUseCase)
    }
}
