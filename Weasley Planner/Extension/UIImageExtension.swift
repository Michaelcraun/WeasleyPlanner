//
//  UIImageExtension.swift
//  Weasley Planner
//
//  Created by Michael Craun on 2/20/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

extension UIImage {
    /// Finds the shortest side of an image and creates a square crop of the original image, centered on the
    /// center point of the original image
    /// - returns: A UIImage that is a perfect square
    func cropSquare() -> UIImage {
        guard let cgImage = self.cgImage else { return self }
        let contextSize: CGSize = self.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgWidth: CGFloat = contextSize.width
        var cgHeight: CGFloat = contextSize.height
        
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgWidth = contextSize.height
            cgHeight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgWidth = contextSize.width
            cgHeight = contextSize.width
        }
        
        let rect = CGRect(x: posX, y: posY, width: cgWidth, height: cgHeight)
        let imageRef = cgImage.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!)
        
        return image
    }
    
    /// Resizes a given UIImage to decrease the overall file size
    /// - parameter targetSize: A CGSize value representing the maximum size you wish the resulting image to be
    /// - returns: A resized UIImage that is the size of the given targetSize
    func resizeImage(_ targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
