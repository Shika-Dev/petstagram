//
//  UIImageExtension.swift
//  petstagram
//
//  Created by Parama Artha on 30/04/25.
//

import UIKit

extension UIImage {
    func convertToBase64() -> String? {
        guard let imageData = self.jpegData(compressionQuality: 0.5) else { return nil }
        return imageData.base64EncodedString()
    }
}
