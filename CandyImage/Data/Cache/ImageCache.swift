//
//  ImageCache.swift
//  CandyImage
//
//  Created by Matt Thomas on 06/11/2021.
//

import Foundation
import UIKit

public protocol ImageCacheType: AnyObject {
    func images(for term: String) -> [UIImage]?
    func insertImages(_ images: [UIImage]?, for term: String)
    func removeImages(for term: String)
    func removeAllImages()
    subscript(_ term: String) -> [UIImage]? { get set }
}

public final class ImageCache: ImageCacheType {
    static let shared = ImageCache()
    private let lock = NSLock()
    private let config: Config

    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()

    public struct Config {
        public let countLimit: Int
        public static let defaultConfig = Config(countLimit: 100)
    }

    public init(config: Config = Config.defaultConfig) {
        self.config = config
    }

    public func images(for term: String) -> [UIImage]? {
        lock.lock(); defer { lock.unlock() }
        if let image = imageCache.object(forKey: term as AnyObject) as? [UIImage] {
            return image
        }
        return nil
    }

    public func insertImages(_ image: [UIImage]?, for term: String) {
        guard let image = image else { return removeImages(for: term) }
        lock.lock(); defer { lock.unlock() }
        imageCache.setObject(image as NSArray, forKey: term as AnyObject, cost: 1)
    }

    public func removeImages(for term: String) {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeObject(forKey: term as AnyObject)
    }

    public func removeAllImages() {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeAllObjects()
    }

    public subscript(_ term: String) -> [UIImage]? {
        get {
            return images(for: term)
        }
        set {
            return insertImages(newValue, for: term)
        }
    }
}
