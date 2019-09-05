//
//  HeaderView.swift
//  ZeplinColorPicker
//
//  Created by Emmar Kardeslik on 2.08.2019.
//  Copyright © 2019 Zeplin. All rights reserved.
//

import Cocoa

final class HeaderView: NSBox {

    // MARK: Constants

    private static let height: CGFloat = 30.0
    private static let horizontalMargin: CGFloat = 10.0
    private static let separatorHeight: CGFloat = 1.0

    // MARK: Properties

    weak var delegate: HeaderViewDelegate?

    private let titleTextField: NSTextField = {
        let textField = NSTextField()
        textField.isBordered = false
        textField.drawsBackground = false
        textField.alignment = .left
        textField.isEditable = false
        textField.isSelectable = false
        textField.usesSingleLineMode = true
        textField.lineBreakMode = .byTruncatingTail
        textField.font = .systemFont(ofSize: 13.0)
        textField.textColor = .labelColor

        return textField
    }()

    private let settingsButton: NSButton = {
        let button = NSButton()
        button.image = NSImage(named: "NSSmartBadgeTemplate")
        button.imageScaling = .scaleProportionallyDown
        button.bezelStyle = .shadowlessSquare
        button.isBordered = false

        return button
    }()

    private let separatorView: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.zeplinSeparatorColor.cgColor

        view.heightAnchor.constraint(equalToConstant: HeaderView.separatorHeight).isActive = true

        return view
    }()

    override var intrinsicContentSize: NSSize {
        return NSSize(width: NSView.noIntrinsicMetric, height: HeaderView.height)
    }

    // MARK: Initializers

    required init() {
        super.init(frame: .zero)

        fillColor = .windowBackgroundColor
        borderColor = .clear
        borderWidth = 0.0
        boxType = .custom
        contentViewMargins = .zero

        let horizontalStackView: NSStackView = {
            let stackView = NSStackView()
            stackView.spacing = 0.0
            stackView.edgeInsets = NSEdgeInsets(top: 0.0,
                                                left: HeaderView.horizontalMargin,
                                                bottom: 0.0,
                                                right: HeaderView.horizontalMargin)

            stackView.setViews([titleTextField, NSView(), settingsButton], in: .leading)

            return stackView
        }()

        contentView = {
            let stackView = NSStackView()
            stackView.orientation = .vertical
            stackView.spacing = 0.0
            stackView.setHuggingPriority(.defaultHigh, for: .vertical)

            stackView.setViews([horizontalStackView, separatorView], in: .top)

            return stackView
        }()

        settingsButton.target = self
        settingsButton.action = #selector(settingsButtonClicked)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    // MARK: Public

    func reload(with name: String, kind: String) {
        titleTextField.stringValue = name + ", " + kind
    }

    // MARK: Actions

    @objc private func settingsButtonClicked(_ sender: NSButton) {
        delegate?.headerView(self, didClickButton: sender)
    }
}

// MARK: HeaderViewDelegate

protocol HeaderViewDelegate: class {

    func headerView(_ headerView: HeaderView, didClickButton button: NSButton)
}
