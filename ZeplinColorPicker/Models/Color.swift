//
//  Color.swift
//  ZeplinColorPicker
//
//  Created by Emmar Kardeslik on 1.08.2019.
//  Copyright © 2019 Zeplin. All rights reserved.
//

import Cocoa

struct Color: Codable {

    // MARK: Constants

    private static let numberOfColorComponents = 3

    // MARK: Properties

    let name: String
    let representation: String
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double

    // MARK: Public

    func nsColor(with colorSpace: NSColorSpace) -> NSColor? {
        guard colorSpace.numberOfColorComponents == Color.numberOfColorComponents else { return nil }

        let components = [
            CGFloat(red) / 255.0,
            CGFloat(green) / 255.0,
            CGFloat(blue) / 255.0,
            CGFloat(alpha)
        ]

        return NSColor(colorSpace: colorSpace, components: components, count: components.count)
    }

    func isSame(with color: NSColor, using colorSpace: NSColorSpace) -> Bool {
        guard
            let nsColor = self.nsColor(with: colorSpace),
            let adjustedColor = color.usingColorSpace(colorSpace)
        else {
            return false
        }

        return nsColor.redComponent.isAlmostEqual(to: adjustedColor.redComponent) &&
               nsColor.greenComponent.isAlmostEqual(to: adjustedColor.greenComponent) &&
               nsColor.blueComponent.isAlmostEqual(to: adjustedColor.blueComponent) &&
               nsColor.alphaComponent.isAlmostEqual(to: adjustedColor.alphaComponent)
    }
}

// MARK: CGFloat extension

private extension CGFloat {

    func isAlmostEqual(to float: CGFloat) -> Bool {
        return abs(self.distance(to: float)) <= 1.0e-2
    }
}
