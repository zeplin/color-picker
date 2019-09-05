//
//  ColorPicker.swift
//  ZeplinColorPicker
//
//  Created by Emmar Kardeslik on 1.08.2019.
//  Copyright © 2019 Zeplin. All rights reserved.
//

import Cocoa

final class ColorPicker: NSColorPicker {

    // MARK: Constants

    private static let minContentSize = NSSize(width: 200.0, height: 316.0)

    // MARK: Properties

    private lazy var colorPickerViewController = ColorPickerViewController()

    // MARK: NSColorPicker

    override var provideNewButtonImage: NSImage {
        guard let image = Bundle.colorPicker?.image(forResource: "pickerIcon") else { return NSImage() }

        return image
    }

    override var minContentSize: NSSize {
        return ColorPicker.minContentSize
    }
}

// MARK: NSColorPickingCustom

extension ColorPicker: NSColorPickingCustom {

    func supportsMode(_ mode: NSColorPanel.Mode) -> Bool {
        return mode == .RGB
    }

    func currentMode() -> NSColorPanel.Mode {
        return .RGB
    }

    func provideNewView(_ initialRequest: Bool) -> NSView {
        if initialRequest {
            colorPickerViewController.delegate = self
        }

        return colorPickerViewController.view
    }

    func setColor(_ newColor: NSColor) {
        self.colorPickerViewController.selectedColor = newColor
    }
}

// MARK: ColorPickerViewControllerDelegate

extension ColorPicker: ColorPickerViewControllerDelegate {

    func colorPickerViewController(_ colorPickerViewController: ColorPickerViewController,
                                   didSelectColor color: NSColor) {
        self.colorPanel.color = color
    }
}
