//
//  InformationView.swift
//  ZeplinColorPicker
//
//  Created by Emmar Kardeslik on 2.08.2019.
//  Copyright © 2019 Zeplin. All rights reserved.
//

import Cocoa

final class InformationView: NSStackView {

    // MARK: Kind

    enum Kind {
        case empty
        case unselected

        // MARK: Properties

        var description: String {
            switch self {
            case .empty:
                return "No colors in the project/styleguide. 🎨"
            case .unselected:
                return "Open a project/styleguide in Zeplin to see the colors."
            }
        }

        var buttonTitle: String {
            switch self {
            case .empty:
                return "Go Add Some"
            case .unselected:
                return "Open Zeplin"
            }
        }
    }

    // MARK: Constants

    private static let stackViewSpacing: CGFloat = 12.0
    private static let stackViewEdgeInsets = NSEdgeInsets(top: 78.0, left: 24.0, bottom: 78.0, right: 24.0)

    // MARK: Properties

    private var kind: Kind?

    private let iconImageView: NSImageView = {
        let imageView = NSImageView()
        imageView.image = Bundle.colorPicker?.image(forResource: "logoZeplin")

        return imageView
    }()

    private let descriptionTextField: NSTextField = {
        let textField = NSTextField()
        textField.isBordered = false
        textField.drawsBackground = false
        textField.alignment = .center
        textField.isSelectable = false
        textField.usesSingleLineMode = false
        textField.lineBreakMode = .byWordWrapping
        textField.font = .systemFont(ofSize: 13.0)
        textField.textColor = .labelColor

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return textField
    }()

    private let launchButton: NSButton = {
        let button = NSButton()
        button.bezelStyle = .rounded
        button.setButtonType(.momentaryPushIn)
        button.font = .systemFont(ofSize: 13.0)

        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return button
    }()

    override var isFlipped: Bool { return true }

    // MARK: Initializers

    required init() {
        super.init(frame: .zero)

        orientation = .vertical
        spacing = InformationView.stackViewSpacing
        edgeInsets = InformationView.stackViewEdgeInsets

        setViews([iconImageView, descriptionTextField, launchButton], in: .top)

        launchButton.target = self
        launchButton.action = #selector(launchButtonClicked)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    // MARK: Actions

    @objc private func launchButtonClicked(_ sender: NSButton) {
        NSWorkspace.shared.launchApplication("Zeplin")
    }

    // MARK: Public

    func reload(kind: Kind) {
        descriptionTextField.stringValue = kind.description
        launchButton.title = kind.buttonTitle
    }
}
