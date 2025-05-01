import Foundation

@MainActor
final class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    // MARK: - Network
     lazy var authService: AuthService = {
         return AuthService()
     }()
    
    lazy var userService: UserService = {
        return UserService()
    }()
    
    // MARK: - Repositories
    lazy var repository: Repositories = {
        return RepositoriesImpl(authService: authService, userService: userService)
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
    
    func generateContentViewModel() -> ContentViewModel {
        return ContentViewModel(authStateManager: authStateManager)
    }
} 
