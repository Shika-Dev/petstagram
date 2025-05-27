import XCTest
@testable import petstagram

@MainActor
final class HomePageViewModelTests: XCTestCase {
    var sut: HomePageViewModel!
    var mockPostUseCase: MockPostUseCase!
    var mockUserDefaultsManager: MockUserDefaultsManager!
    
    override func setUp() {
        super.setUp()
        mockPostUseCase = MockPostUseCase()
        mockUserDefaultsManager = MockUserDefaultsManager()
        mockUserDefaultsManager.userUID = "testUID"
        mockUserDefaultsManager.fullName = "Test User"
        mockUserDefaultsManager.profilePictureUrl = "testProfileUrl"
        
        sut = HomePageViewModel(
            useCase: mockPostUseCase,
            userDefaultsManager: mockUserDefaultsManager
        )
    }
    
    override func tearDown() {
        sut = nil
        mockPostUseCase = nil
        mockUserDefaultsManager = nil
        super.tearDown()
    }
    
    func testFetchPostsSuccess() async {
        // Given
        let mockPosts = [
            PostEntity(
                id: "1",
                imgUrl: "url1",
                caption: "caption1",
                likes: [],
                likesCount: 0,
                commentCount: 0,
                isLike: false,
                comments: [],
                meta: MetaData(
                    fullName: "User1",
                    username: "user1",
                    profileImgUrl: "profile1",
                    createdAt: "2024-05-21"
                )
            ),
            PostEntity(
                id: "2",
                imgUrl: "url2",
                caption: "caption2",
                likes: [],
                likesCount: 0,
                commentCount: 0,
                isLike: false,
                comments: [],
                meta: MetaData(
                    fullName: "User2",
                    username: "user2",
                    profileImgUrl: "profile2",
                    createdAt: "2024-05-22"
                )
            )
        ]
        mockPostUseCase.mockPosts = mockPosts
        
        // When
        await sut.fetchPosts()
        
        // Then
        XCTAssertEqual(sut.posts.count, 2)
        XCTAssertEqual(sut.posts[0].id, "1")
        XCTAssertEqual(sut.posts[1].id, "2")
        XCTAssertFalse(sut.isRefreshing)
        XCTAssertTrue(sut.error.isEmpty)
    }
    
    func testFetchPostsError() async {
        // Given
        mockPostUseCase.shouldThrowError = true
        
        // When
        await sut.fetchPosts()
        
        // Then
        XCTAssertTrue(sut.posts.isEmpty)
        XCTAssertFalse(sut.error.isEmpty)
    }
    
    @MainActor
    func testPostCommentSuccess() async {
        // Given
        let post = PostEntity(
            id: "1",
            imgUrl: "url1",
            caption: "caption1",
            likes: [],
            likesCount: 0,
            commentCount: 0,
            isLike: false,
            comments: [],
            meta: MetaData(
                fullName: "User1",
                username: "user1",
                profileImgUrl: "profile1",
                createdAt: "2024-05-21"
            )
        )
        sut.posts = [post]  // Set the mock posts
        let comment = "Test comment"
        
        // When
        await sut.postComment(postId: post.id, comment: comment)
        
        // Then
        XCTAssertTrue(mockPostUseCase.updateCommentCalled)
        XCTAssertTrue(sut.error.isEmpty, "Should not have any errors")
    }
    
    func testPostCommentNoUID() async {
        // Given
        mockUserDefaultsManager.userUID = nil
        let post = PostEntity(
            id: "1",
            imgUrl: "url1",
            caption: "caption1",
            likes: [],
            likesCount: 0,
            commentCount: 0,
            isLike: false,
            comments: [],
            meta: MetaData(
                fullName: "User1",
                username: "user1",
                profileImgUrl: "profile1",
                createdAt: "2024-05-21"
            )
        )
        sut.posts = [post]
        
        // When
        await sut.postComment(postId: post.id, comment: "Test comment")
        
        // Then
        XCTAssertEqual(sut.posts[0].comments.count, 0)
        XCTAssertEqual(sut.posts[0].commentCount, 0)
    }
    
    func testUpdateLikeSuccess() async {
        // Given
        let post = PostEntity(
            id: "1",
            imgUrl: "url1",
            caption: "caption1",
            likes: [],
            likesCount: 0,
            commentCount: 0,
            isLike: false,
            comments: [],
            meta: MetaData(
                fullName: "User1",
                username: "user1",
                profileImgUrl: "profile1",
                createdAt: "2024-05-21"
            )
        )
        sut.posts = [post]
        
        // When
        await sut.updateLike(id: post.id)
        
        // Then
        XCTAssertTrue(mockPostUseCase.updateLikeCalled)
        XCTAssertTrue(sut.error.isEmpty)
    }
    
    func testUpdateLikeNoUID() async {
        // Given
        mockUserDefaultsManager.userUID = nil
        let post = PostEntity(
            id: "1",
            imgUrl: "url1",
            caption: "caption1",
            likes: [],
            likesCount: 0,
            commentCount: 0,
            isLike: false,
            comments: [],
            meta: MetaData(
                fullName: "User1",
                username: "user1",
                profileImgUrl: "profile1",
                createdAt: "2024-05-21"
            )
        )
        sut.posts = [post]
        
        // When
        await sut.updateLike(id: post.id)
        
        // Then
        XCTAssertFalse(sut.posts[0].isLike)
        XCTAssertEqual(sut.posts[0].likesCount, 0)
        XCTAssertEqual(sut.posts[0].likes.count, 0)
    }
} 
