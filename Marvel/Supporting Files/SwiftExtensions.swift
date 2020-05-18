//
//  SwiftExtensions.swift
//  Marvel
//
//  Created by MarvelDev on 14/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

extension String {
    public var localized: String {
        get {
            return NSLocalizedString(self, comment: "")
        }
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UIView {
    func addRoundCornersView(corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            var maskedCorners = CACornerMask()
            if corners.contains(.bottomLeft) {
                maskedCorners.insert(.layerMinXMaxYCorner)
            }
            if corners.contains(.bottomRight) {
                maskedCorners.insert(.layerMaxXMaxYCorner)
            }
            if corners.contains(.topLeft) {
                maskedCorners.insert(.layerMinXMinYCorner)
            }
            if corners.contains(.topRight) {
                maskedCorners.insert(.layerMaxXMinYCorner)
            }
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = maskedCorners
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.frame = bounds
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}

public protocol StructDecodable: Decodable, Encodable {
    static func getModelFrom(_ data: Data) -> Self?
}

extension StructDecodable {
    public static func getModelFrom(_ data: Data) -> Self? {
        do {
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            return nil
        }
    }
}
