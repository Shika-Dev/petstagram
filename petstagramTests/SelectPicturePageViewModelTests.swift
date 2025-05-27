//
//  SelectPicturePageViewModelTest.swift
//  petstagramTests
//
//  Created by Parama Artha on 21/05/25.
//


import XCTest
@testable import petstagram

@MainActor
final class SelectPicturePageViewModelTests: XCTestCase {
    var sut: SelectPicturePageViewModel!
    var mockPostUseCase: MockPostUseCase!
    
    override func setUp() {
        super.setUp()
        mockPostUseCase = MockPostUseCase()
        sut = SelectPicturePageViewModel(useCase: mockPostUseCase)
    }
    
    override func tearDown() {
        sut = nil
        mockPostUseCase = nil
        super.tearDown()
    }
    
    func testDidSelectImageShouldUpdateSelectedImage() {
        // Given
        let testImage = UIImage(systemName: "photo")!
        
        // When
        sut.didSelectImage(testImage)
        
        // Then
        XCTAssertNotNil(sut.selectedImage)
        XCTAssertEqual(sut.selectedImage, testImage)
    }
    
    func testUploadPostWithEmptyCaption() async {
        // Given
        sut.selectedImage = UIImage(systemName: "photo")!
        sut.imageCaption = ""
        
        // When
        await sut.uploadPost()
        
        // Then
        XCTAssertEqual(sut.error, "Please fill in all required fields")
        XCTAssertFalse(sut.isPostSaved)
    }
    
    func testUploadPostWithNoImage() async {
        // Given
        sut.selectedImage = nil
        sut.imageCaption = "Test caption"
        
        // When
        await sut.uploadPost()
        
        // Then
        XCTAssertEqual(sut.error, "Please fill in all required fields")
        XCTAssertFalse(sut.isPostSaved)
    }
    
    func testUploadPostwithValidData() async {
        // Given
        sut.selectedImage = UIImage(systemName: "photo")!
        sut.imageCaption = "Test caption"
        
        // When
        await sut.uploadPost()
        
        // Then
        XCTAssertTrue(sut.isPostSaved)
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testUploadPostFailed() async {
        // Given
        sut.selectedImage = UIImage(systemName: "photo")!
        sut.imageCaption = "Test caption"
        mockPostUseCase.shouldThrowError = true
        
        // When
        await sut.uploadPost()
        
        // Then
        XCTAssertFalse(sut.isPostSaved)
        XCTAssertNotNil(sut.error)
        XCTAssertFalse(sut.isLoading)
    }
}
