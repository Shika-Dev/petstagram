import Foundation

@MainActor
final class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    // MARK: - Network
     lazy var authService: AuthService = {
         return AuthService()
     }()
    
    // MARK: - Repositories
    lazy var repository: Repositories = {
        return RepositoriesImpl(authService: authService)
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
    
    func generateContentViewModel() -> ContentViewModel {
        return ContentViewModel(authStateManager: authStateManager)
    }
} 
