//
//  UIImage+Extension.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/10.
//

import UIKit

extension UIImage {
    class var defaultImage: UIImage? { return UIImage(named: "DefaultImage")}
    
    func downloadImage(from urlString: String) async throws -> UIImage {
        guard let imageURL = URL(string: urlString) else { return UIImage()}
        let (data, _) = try await URLSession.shared.data(from: imageURL)
        guard let image = UIImage(data: data) else {
            throw ImageError.invalidData
        }
        return image
    }
}
