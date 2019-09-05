//
//  Contents.swift
//  ZeplinColorPicker
//
//  Created by Emmar Kardeslik on 1.08.2019.
//  Copyright © 2019 Zeplin. All rights reserved.
//

import Foundation

struct Contents: Codable {

    // MARK: Properties

    let name: String
    let kind: String
    let colors: [Color]
}
