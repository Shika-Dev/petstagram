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
        return PostService(db: firestore, cloudinaryService: claudinaryService)
    }()
    
    // MARK: - Repositories
    lazy var repository: Repositories = {
        return RepositoriesImpl(authService: authService, userService: userService, postService: postService)
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
    lazy var authStateManager: AuthStateManager = {
        return AuthStateManager()
    }()
    
    // MARK: - ViewModels
    func generateLoginPageViewModel() -> LoginPageViewModel {
        return LoginPageViewModel(useCase: authUseCase, authStateManager: authStateManager)
    }
    
    func generateRegisterPageViewModel() -> RegisterPageViewModel {
        return RegisterPageViewModel(useCase: authUseCase, authStateManager: authStateManager)
    }
    
    func generateEditProfilePageViewModel() -> EditProfilePageViewModel {
        return EditProfilePageViewModel(useCase: userUseCase)
    }
    
    func generateHomePageViewModel() -> HomePageViewModel {
        return HomePageViewModel(authStateManager: authStateManager)
    }
    
    func generateSelectPicturePageViewModel() -> SelectPicturePageViewModel {
        return SelectPicturePageViewModel(useCase: postUseCase)
    }
}
