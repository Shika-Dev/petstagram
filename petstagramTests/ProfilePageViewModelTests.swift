import XCTest
@testable import petstagram

@MainActor
final class ProfilePageViewModelTests: XCTestCase {
    var sut: ProfilePageViewModel!
    var mockAuthStateManager: MockAuthStateManager!
    var mockUserDefaultsManager: MockUserDefaultsManager!
    var mockUserUseCase: MockUserUseCases!
    var mockPostUseCase: MockPostUseCase!
    
    override func setUp() {
        super.setUp()
        mockAuthStateManager = MockAuthStateManager()
        mockUserDefaultsManager = MockUserDefaultsManager()
        mockUserUseCase = MockUserUseCases()
        mockPostUseCase = MockPostUseCase()
        
        sut = ProfilePageViewModel(
            authStateManager: mockAuthStateManager,
            useCase: mockUserUseCase,
            userDefaultsManager: mockUserDefaultsManager,
            postUseCase: mockPostUseCase
        )
    }
    
    override func tearDown() {
        sut = nil
        mockAuthStateManager = nil
        mockUserDefaultsManager = nil
        mockUserUseCase = nil
        mockPostUseCase = nil
        super.tearDown()
    }
    
    func testGetUserDataSuccess() async {
        // Given
        let mockUser = UserEntity(
            uid: "testUID",
            fullName: "Test User",
            userName: "testuser",
            dateOfBirth: Date(),
            bio: "Test bio",
            info: InfoData(
                name: "Test Pet",
                born: "2020",
                gender: "Male",
                breed: "Golden Retriever",
                favoriteToy: "Ball",
                habits: "Sleeping",
                characteristics: "Friendly",
                favoriteFood: "Dog food"
            ),
            lifeEvents: [["2020": "Born"], ["2021": "First walk"]]
        )
        mockUserUseCase.mockGetUserResult = mockUser
        mockUserDefaultsManager.userUID = "testUID"
        
        // When
        sut.getUserData()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Then
        XCTAssertEqual(sut.fullName, "Test User")
        XCTAssertEqual(sut.username, "testuser")
        XCTAssertEqual(sut.name, "Test Pet")
        XCTAssertEqual(sut.breed, "Golden Retriever")
        XCTAssertEqual(sut.listLifeEvents.count, 2)
    }
    
    func testGetUserDataNoUID() async {
        // Given
        mockUserDefaultsManager.userUID = nil
        
        // When
        sut.getUserData()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Then
        XCTAssertEqual(sut.fullName, "")
        XCTAssertEqual(sut.username, "")
    }
    
    func testSaveInfoSuccess() async {
        // Given
        mockUserDefaultsManager.userUID = "testUID"
        sut.name = "Test Pet"
        sut.born = "2020"
        sut.gender = "Male"
        sut.breed = "Golden Retriever"
        
        // When
        sut.saveInfo()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Then
        XCTAssertFalse(sut.showEditInfoSheet)
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testSaveInfoMissingRequiredFields() async {
        // Given
        mockUserDefaultsManager.userUID = "testUID"
        sut.name = ""
        sut.born = ""
        sut.gender = ""
        sut.breed = ""
        
        // When
        sut.saveInfo()
        
        // Then
        XCTAssertEqual(sut.error, "Please fill in all required fields")
    }
    
    func testSaveInfoNoUID() async {
        // Given
        mockUserDefaultsManager.userUID = nil
        sut.name = "Test Pet"
        sut.born = "2020"
        sut.gender = "Male"
        sut.breed = "Golden Retriever"
        
        // When
        sut.saveInfo()
        
        // Then
        XCTAssertEqual(sut.error, "User not authenticated")
    }
    
    func testFetchUserPostSuccess() async {
        // Given
        let mockPosts = [
            PostEntity(id: "1", imgUrl: "url1", caption: "caption1", likes: [], likesCount: 0, commentCount: 0, isLike: false, comments: [], meta: MetaData(fullName: "fullName", username: "username", profileImgUrl: "profileUrl", createdAt: "31-12-2024")),
            PostEntity(id: "2", imgUrl: "url2", caption: "caption2", likes: [], likesCount: 0, commentCount: 0, isLike: false, comments: [], meta: MetaData(fullName: "fullName", username: "username", profileImgUrl: "profileUrl", createdAt: "31-12-2024")),
        ]
        mockPostUseCase.mockPosts = mockPosts
        
        // When
        sut.fetchUserPost()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Then
        XCTAssertEqual(sut.posts.count, 2)
        XCTAssertEqual(sut.posts[0].id, "1")
        XCTAssertEqual(sut.posts[1].id, "2")
    }
    
    func testSignOutSuccess() {
        // When
        sut.signOut()
        
        // Then
        XCTAssertNil(mockAuthStateManager.currentUser)
        XCTAssertFalse(mockAuthStateManager.isAuthenticated)
        XCTAssertFalse(mockAuthStateManager.isNewUser)
        XCTAssertNil(mockUserDefaultsManager.userUID)
    }
}
