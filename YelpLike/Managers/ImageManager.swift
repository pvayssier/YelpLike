//
//  ImageManager.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import Photos
import UIKit.UIImage

final class ImageManager {

    static let shared = ImageManager()

    private let cachingManager = PHCachingImageManager.default()

    private(set) lazy var defaultImage = UIImage(systemName: "photo.on.rectangle.angled")!

    private(set) lazy var pendingRequestId: PHImageRequestID? = nil

    func fetchImage(
        from assetIdentifier: String,
        size: CGSize,
        resultHandler: @escaping (UIImage) -> Void
    ) {
        let phFetchOptions =  PHFetchOptions()

        let phAssetFetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: phFetchOptions)

        guard let fetchedAsset = phAssetFetchResult.firstObject else {
            resultHandler(defaultImage)
            return
        }

        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.deliveryMode = .opportunistic
        imageRequestOptions.resizeMode = .exact

        pendingRequestId = cachingManager.requestImage(
            for: fetchedAsset,
            targetSize: size,
            contentMode: .aspectFill,
            options: imageRequestOptions,
            resultHandler: { [weak self] generatedImage, infoKeys in
                guard let self else { return }
                resultHandler(generatedImage ?? self.defaultImage)
            }
        )
    }

    func cancelPendingRequest() {
        guard let requestId = pendingRequestId else { return }
        cachingManager.cancelImageRequest(requestId)
    }
}
