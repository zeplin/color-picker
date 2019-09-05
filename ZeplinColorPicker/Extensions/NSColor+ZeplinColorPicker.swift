//
//  Extensions.swift
//  ZeplinColorPicker
//
//  Created by Emmar Kardeslik on 6.08.2019.
//  Copyright © 2019 Zeplin. All rights reserved.
//

import Cocoa

extension NSColor {

    // MARK: Constants

    static let zeplinSeparatorColor: NSColor = {
        guard #available(OSX 10.14, *) else { return NSColor.zeplinGandalf.withAlphaComponent(0.25) }

        return separatorColor
    }()

    private static let zeplinGandalf = NSColor(srgbRed: 151.0 / 255.0,
                                               green: 145.0 / 255.0,
                                               blue: 151.0 / 255.0,
                                               alpha: 1.0)
}
