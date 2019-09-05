//
//  ColorCell.swift
//  ZeplinColorPicker
//
//  Created by Emmar Kardeslik on 2.08.2019.
//  Copyright © 2019 Zeplin. All rights reserved.
//

import Cocoa

final class ColorCell: NSTableCellView {

    // MARK: Constants

    static let height: CGFloat = 43.0
    static let reuseIdentifier = NSUserInterfaceItemIdentifier(rawValue: "ColorCell")

    private static let colorSize = NSSize(width: 25.0, height: 25.0)
    private static let colorCornerRadius: CGFloat = 5.0
    private static let strokeWidth: CGFloat = 2.0
    private static let verticalMargin: CGFloat = (height - colorSize.height) / 2.0
    private static let horizontalMargin: CGFloat = 11.0
    private static let stackViewTopMargin: CGFloat = 7.0
    private static let stackViewLeftMargin = horizontalMargin + colorSize.width + 9.0

    // MARK: Properties

    private var color: Color? {
        didSet {
            guard let color = color else {
                nameTextField.stringValue = ""
                representationTextField.stringValue = ""

                return
            }

            nameTextField.stringValue = color.name
            representationTextField.stringValue = color.representation
        }
    }

    private let nameTextField: NSTextField = {
        let textField = NSTextField()
        textField.isBordered = false
        textField.drawsBackground = false
        textField.alignment = .left
        textField.isEditable = false
        textField.isSelectable = true
        textField.usesSingleLineMode = true
        textField.lineBreakMode = .byTruncatingTail
        textField.font = .systemFont(ofSize: 13.0)
        textField.textColor = .labelColor

        return textField
    }()

    private let representationTextField: NSTextField = {
        let textField = NSTextField()
        textField.isBordered = false
        textField.drawsBackground = false
        textField.alignment = .left
        textField.isEditable = false
        textField.isSelectable = true
        textField.usesSingleLineMode = true
        textField.lineBreakMode = .byCharWrapping
        textField.font = .systemFont(ofSize: 11.0)
        textField.textColor = .secondaryLabelColor

        return textField
    }()

    // MARK: Initializers

    required init() {
        super.init(frame: .zero)

        identifier = ColorCell.reuseIdentifier

        let stackView: NSStackView = {
            let stackView = NSStackView()
            stackView.orientation = .vertical
            stackView.alignment = .leading
            stackView.spacing = 0.0
            stackView.translatesAutoresizingMaskIntoConstraints = false

            return stackView
        }()

        addSubview(stackView)

        stackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: ColorCell.stackViewLeftMargin).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: ColorCell.horizontalMargin).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: ColorCell.stackViewTopMargin).isActive = true

        stackView.setViews([nameTextField, representationTextField], in: .top)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    // MARK: NSView

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        NSGraphicsContext.saveGraphicsState()

        let origin = NSPoint(x: ColorCell.horizontalMargin, y: ColorCell.verticalMargin)
        let rect = NSRect(origin: origin, size: ColorCell.colorSize)
        let path = NSBezierPath(roundedRect: rect,
                                xRadius: ColorCell.colorCornerRadius,
                                yRadius: ColorCell.colorCornerRadius)

        path.addClip()

        if let patternImage = Bundle.colorPicker?.image(forResource: "textureColor") {
            NSColor(patternImage: patternImage).setFill()
            path.fill()
        }

        if let color = color?.nsColor(with: .genericRGB) {
            color.setFill()
            path.fill()
        }

        NSColor.zeplinSeparatorColor.setStroke()
        path.lineWidth = ColorCell.strokeWidth
        path.stroke()

        NSGraphicsContext.restoreGraphicsState()
    }

    // MARK: Public

    func reload(with color: Color?) {
        self.color = color

        needsDisplay = true
    }
}
