import Foundation

final class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    // MARK: - Network
    // lazy var networkService: NetworkServiceProtocol = {
    //     return NetworkService()
    // }()
    
    // MARK: - Repositories
    lazy var repository: Repositories = {
        return RepositoriesImpl()
    }()
    
    // MARK: - UseCases
    lazy var userUseCase: UserUseCases = {
        return UserUseCaseAdapter(repository: repository)
    }()
    lazy var postUseCase: PostUseCases = {
        return PostUseCaseAdapter(repository: repository)
    }()
    
    // MARK: - ViewModels
    func generateLoginPageViewModel() -> LoginPageViewModel {
        return LoginPageViewModel(usecase: userUseCase)
    }
} 