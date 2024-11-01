//
//  HomeViewModel.swift
//  BarrioConectado
//
//  Created by Nicolas Martinez on 24/09/2024.
//

import Foundation
import PhotosUI
import _PhotosUI_SwiftUI
import FirebaseStorage

class HomeViewModel: ObservableObject {
    // MARK: Properties
    @Published var userModel: UserDataModel?
    @Published var neighbourhoodModel: NeighbourhoodModel?
    @Published var posts: [HomePostModel] = []
    @Published var errorMessage: String?
    @Published var showOnboarding: Bool = false
    @Published var comments: [String: [HomePostComment]] = [:]
    @Published var image: UIImage = .init(resource: .avatar)
    @Published var isLoadingImage: Bool = false
    @Published var cachedImagesForPosts: [String: (owner: String, image: UIImage)] = [:]
    @Published var cachedImagesForComments: [String: (owner: String, image: UIImage)] = [:]

    private var uid: String? {
        AuthManager.instance.currentUserUID
    }
    
    let carousel: [HomeCarouselCellModel] = [
        HomeCarouselCellModel(
            iconName: "fireworks",
            iconColor: Constants.Colors.caramel,
            iconBackgroundColor: Constants.Colors.peach,
            text: "Mira los últimos eventos por tu barrio.",
            correspondingTab: Constants.Tabs.events
        ),
        HomeCarouselCellModel(
            iconName: "exclamationmark.triangle.fill",
            iconColor: Constants.Colors.yellow,
            iconBackgroundColor: Constants.Colors.darkPeach,
            text: "Está al tanto de las emeregencias vecinales.",
            correspondingTab: Constants.Tabs.alerts
        ),
        HomeCarouselCellModel(
            iconName: "storefront",
            iconColor: Constants.Colors.darkNature,
            iconBackgroundColor: Constants.Colors.nature,
            text: "Vende o regala articulos que ya no utilices",
            correspondingTab: Constants.Tabs.announcements
        )
    ]
    
    // MARK: Methods

    func showErrorMessage(_ message: String) {
        errorMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.errorMessage = nil
        }
    }

    /// Fetches user data from the database.
    @MainActor
    func fetchUserData(
        retries: Int = 0
    ) {
        guard let uid else {
            let error = AuthenticaitonError.UserIdentifierIsNil
            return showErrorMessage(error.spanishDescription)
        }
        Task { [weak self] in
            guard let self else { return }
            let result = await DatabaseManager.instance.searchUserData(for: uid)
            switch result {
            case .success(let userData):
                userModel = userData
                showOnboarding = userModel?.neighbourhood == nil
                if !showOnboarding {
                    fetchNeighbourhoodData()
                }
                downloadProfilePicture()
            case .failure(let error):
                if retries > 0 {
                    try? await Task.sleep(nanoseconds: UInt64(2_000_000_000))
                    fetchUserData(retries: retries - 1)
                } else {
                    showErrorMessage(error.spanishDescription)
                }
            }
        }
    }

    @MainActor
    func updateDescription(
        description: String
    ) {
        guard var userModel else {
            return
        }
        userModel.description = description
        Task { [weak self] in
            guard let self else { return }
            let result = await DatabaseManager.instance.updateUser(userData: userModel)
            switch result {
            case .success(let userModel):
                self.userModel = userModel
            case .failure(let error):
                showErrorMessage(error.spanishDescription)
            }
        }
    }

    @MainActor
    func fetchNeighbourhoodData() {
        guard let neighbourhood = userModel?.neighbourhood else {
            return
        }
        Task { [weak self] in
            guard let self else { return }
            let result = await DatabaseManager.instance.searchNeighbourhoodData(for: neighbourhood)
            switch result {
            case .success(let neighbourhoodModel):
                self.neighbourhoodModel = neighbourhoodModel
                fetchPosts()
                return
            case .failure(let error):
                showErrorMessage(error.spanishDescription)
            }
        }
    }
    
    @MainActor
    func fetchPosts() {
        guard let neighbourhood = userModel?.neighbourhood else {
            return
        }
        Task { [weak self] in
            guard let self else { return }
            let result = await DatabaseManager.instance.searchPosts(for: neighbourhood)
            switch result {
            case .success(let posts):
                self.posts = posts
                return
            case .failure(let error):
                showErrorMessage(error.spanishDescription)
            }
        }
    }
    
    @MainActor
    func addPost(
        text: String
    ) {
        guard let userModel = userModel,
              let neighbourhood = userModel.neighbourhood
        else {
            return
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                try await DatabaseManager.instance.insertPost(
                    text: text,
                    for: userModel,
                    in: neighbourhood
                )
            } catch {
                showErrorMessage(error.spanishDescription)
            }
        }
    }
    
    @MainActor
    func addComment(
        text: String,
        for post: HomePostModel
    ) async {
        guard let userModel else {
            return
        }
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index].amountOfComments += 1
            do {
                await DatabaseManager.instance.updatePost(post: posts[index])
                try await DatabaseManager.instance.insertComment(text: text, for: userModel, in: post)
            } catch {
                showErrorMessage(error.spanishDescription)
            }
        }
    }

    @MainActor
    func toggleLike(
        for post: HomePostModel
    ) {
        guard let uid else {
            return
        }
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            var postCopy = posts[index]
            var liked = postCopy.liked
            liked.toggle()
            postCopy.amountOfLikes += liked ? 1 : -1
            if liked {
                postCopy.likedBy.append(uid)
            } else {
                postCopy.likedBy.removeAll { $0 == uid }
            }
            posts[index] = postCopy
            Task { [weak self] in
                guard let self else { return }
                let result = await DatabaseManager.instance.updatePost(post: posts[index])
                switch result {
                case .success(_):
                    return
                case .failure(let error):
                    showErrorMessage(error.spanishDescription)
                }
            }
        }
    }

    @MainActor
    func toggleLike(
        for comment: HomePostComment
    ) {
        guard let uid else {
            return
        }
        var commentCopy = comment
        var liked = commentCopy.liked
        liked.toggle()
        commentCopy.amountOfLikes += liked ? 1 : -1
        if liked {
            commentCopy.likedBy.append(uid)
        } else {
            commentCopy.likedBy.removeAll { $0 == uid }
        }
        if let index = comments[comment.post]?.firstIndex(where: { $0.id == comment.id }) {
            comments[comment.post]?[index] = commentCopy
        }
        Task { [weak self] in
            guard let self else { return }
            let result = await DatabaseManager.instance.updateComment(comment: commentCopy)
            switch result {
            case .success(_):
                return
            case .failure(let error):
                showErrorMessage(error.spanishDescription)
            }
        }
    }

    @MainActor 
    func fetchComments(
        for post: HomePostModel
    ) async {
        Task { [weak self] in
            guard let self else { return }
            let result = await DatabaseManager.instance.searchComments(for: post)
            switch result {
            case .success(let comments):
                guard !comments.isEmpty else { 
                    if self.comments[post.id] != nil {
                        self.comments[post.id] = nil
                    }
                    return
                }
                self.comments[post.id] = comments
            case .failure(let error):
                showErrorMessage(error.spanishDescription)
            }
        }
    }

    @MainActor
    func uploadImage(
        newImage: PhotosPickerItem?
    ) {
        Task { [weak self] in
            guard let self else {
                return
            }
            
            do {
                guard var userModel else {
                    throw DatabaseError.UserNotFound
                }
                
                guard let newImage else {
                    throw BCError.UploadedImageIsNil
                }

                guard let imageAsData = try await newImage.loadTransferable(type: Data.self) else {
                    throw BCError.ImageLoadFailed
                }

                guard let fileType = imageAsData.getFileType() else {
                    throw BCError.NotAllowedImageType
                }
                
                guard imageAsData.sizeIsLessThan10MB() else {
                    throw BCError.ImageSizeIsBiggerThan10MB
                }

                guard let imageAsUIImage = UIImage(data: imageAsData) else {
                    throw BCError.ImageLoadFailed
                }

                guard let croppedImage = imageAsUIImage.cropAndResize(to: CGSize(width: 65, height: 65))?.jpegData(compressionQuality: 1) else {
                    throw BCError.ImageLoadFailed
                }
                
                isLoadingImage = true
                
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let previousPhotoRef = storageRef.child("images/\(userModel.id)/\(userModel.pictureUrl)")
                let newImageName = "\(UUID().uuidString).\(fileType)"
                let newPhotoRef = storageRef.child("images/\(userModel.id)/\(newImageName)")
                
                // Update new photo
                _ = try await newPhotoRef.putDataAsync(croppedImage)
                
                // Download previous photo
                if let _ = try? await previousPhotoRef.getMetadata() {
                    // Delete the previous photo if it exists
                    try await previousPhotoRef.delete()
                }
                
                // Update user's picture URL
                userModel.pictureUrl = newImageName
                let updateUserResult = await DatabaseManager.instance.updateUser(userData: userModel)
                
                // Update the picture of each post of the owner
                try await DatabaseManager.instance.updatePictureOfPostsAndComments(newImageName: newImageName, for: userModel.id)
    
                switch updateUserResult {
                case .success(let userModel):
                    self.userModel = userModel
                    if let image = UIImage(data: imageAsData) {
                        self.image = image
                        updateCachedImages(newImage: image, for: userModel.id)
                    } else {
                        downloadProfilePicture()
                    }
                case .failure(let error):
                    throw error
                }
                isLoadingImage = false
            } catch {
                isLoadingImage = false
                showErrorMessage(error.spanishDescription)
            }
        }
    }

    @MainActor
    func updateCachedImages(
        newImage: UIImage,
        for uid: String
    ) {
        for (postId, data) in cachedImagesForPosts where data.owner == uid {
            cachedImagesForPosts[postId] = (data.owner, newImage)
        }

        for (commentId, data) in cachedImagesForComments where data.owner == uid {
            cachedImagesForComments[commentId] = (data.owner, newImage)
        }
    }

    @MainActor
    func downloadProfilePicture() {
        isLoadingImage = true
        Task { [weak self] in
            guard let self else { return }
            do {
                guard let userModel else {
                    throw DatabaseError.UserNotFound
                }
                guard !userModel.pictureUrl.isEmpty else {
                    throw BCError.ImageIsEmpty
                }
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let photoRef = storageRef.child("images/\(userModel.id)/\(userModel.pictureUrl)")
                if let downloadedImage = try? await photoRef.data(maxSize: 10 * 1024 * 1024),
                   let image = UIImage(data: downloadedImage) {
                    self.image = image
                }
                isLoadingImage = false
            } catch {
                print(error)
                isLoadingImage = false
            }
        }
    }

    @MainActor
    func fetchImage(
        for post: HomePostModel
    ){
        Task { [weak self] in
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let photoRef = storageRef.child("images/\(post.owner)/\(post.ownerPictureUrl)")
            do {
                let downloadedImage = try await photoRef.data(maxSize: 10 * 1024 * 1024)
                if let image = UIImage(data: downloadedImage) {
                    self?.cachedImagesForPosts[post.id] = (post.owner, image)
                }
            } catch {
                print(error)
            }
        }
    }

    @MainActor
    func fetchImage(
        for comment: HomePostComment
    ){
        Task { [weak self] in
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let photoRef = storageRef.child("images/\(comment.owner)/\(comment.ownerPictureUrl)")
            do {
                let downloadedImage = try await photoRef.data(maxSize: 10 * 1024 * 1024)
                if let image = UIImage(data: downloadedImage) {
                    self?.cachedImagesForComments[comment.id] = (comment.owner, image)
                }
            } catch {
                print(error)
            }
        }
    }
}
