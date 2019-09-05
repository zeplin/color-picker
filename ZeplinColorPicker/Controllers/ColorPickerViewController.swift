//
//  ColorPickerViewController.swift
//  ZeplinColorPicker
//
//  Created by Emmar Kardeslik on 1.08.2019.
//  Copyright © 2019 Zeplin. All rights reserved.
//

import Cocoa

final class ColorPickerViewController: NSViewController {

    // MARK: Constants

    private static let colorPickerContentsDidChangeNotification =
        Notification.Name("ZeplinColorPickerContentsDidChangeNotification")

    private static let contentsFileName = "contents"
    private static let contentsFileExtension = "json"

    private static let menuOffset: CGFloat = 8.0
    private static let menuFont = NSFont.systemFont(ofSize: 11.0)

    // MARK: Properties

    weak var delegate: ColorPickerViewControllerDelegate?

    var selectedColor: NSColor? {
        didSet {
            guard
                let selectedColor = selectedColor,
                let index = contents?.colors.firstIndex(where: { $0.isSame(with: selectedColor, using: .genericRGB) })
            else {
                return
            }

            tableView.selectRowIndexes(IndexSet(integer: index), byExtendingSelection: false)
        }
    }

    private var contents: Contents? {
        didSet {
            if let contents = contents {
                headerView.isHidden = false
                headerView.reload(with: contents.name, kind: contents.kind)

                if contents.colors.isEmpty {
                    scrollView.documentView = informationView
                    informationView.reload(kind: .empty)
                } else {
                    scrollView.documentView = tableView
                    tableView.reloadData()
                }
            } else {
                headerView.isHidden = true

                scrollView.documentView = informationView
                informationView.reload(kind: .unselected)
            }

            if informationView.superview != nil {
                informationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
                informationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            }
        }
    }

    private let headerView = HeaderView()

    private let informationView: InformationView = {
        let informationView = InformationView()
        informationView.translatesAutoresizingMaskIntoConstraints = false

        return informationView
    }()

    private let scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.autohidesScrollers = true

        return scrollView
    }()

    private let tableView: NSTableView = {
        let tableView = NSTableView()
        tableView.headerView = nil
        tableView.intercellSpacing = .zero

        let column = NSTableColumn()
        column.resizingMask = .autoresizingMask
        tableView.addTableColumn(column)

        return tableView
    }()

    private let colorSpaces: [NSColorSpace]

    private var colorSpace: NSColorSpace {
        didSet {
            guard let selectedColor = color()?.nsColor(with: colorSpace) else { return }

            delegate?.colorPickerViewController(self, didSelectColor: selectedColor)
        }
    }

    // MARK: Initializers

    deinit {
        tableView.dataSource = nil
        tableView.delegate = nil

        DistributedNotificationCenter.default().removeObserver(self)
    }

    required init() {
        colorSpaces = NSColorSpace.availableColorSpaces(with: .rgb)
        colorSpace = .genericRGB

        super.init(nibName: nil, bundle: nil)

        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(reload),
            name: ColorPickerViewController.colorPickerContentsDidChangeNotification,
            object: nil,
            suspensionBehavior: .deliverImmediately
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    // MARK: NSViewController

    override func loadView() {
        view = {
            let stackView = NSStackView()
            stackView.orientation = .vertical
            stackView.spacing = 0.0
            stackView.detachesHiddenViews = true

            stackView.setViews([headerView, scrollView], in: .leading)

            return stackView
        }()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        headerView.delegate = self

        reload()
    }

    // MARK: Private

    @objc private func reload() {
        guard
            let contentsFileURL = Bundle.colorPicker?.resourceURL?
                .appendingPathComponent(ColorPickerViewController.contentsFileName)
                .appendingPathExtension(ColorPickerViewController.contentsFileExtension),
            let jsonData = try? Data(contentsOf: contentsFileURL)
        else {
            contents = nil

            return
        }

        contents = try? JSONDecoder().decode(Contents.self, from: jsonData)
    }

    private func color(for row: Int? = nil) -> Color? {
        let index = row.map { $0 } ?? tableView.selectedRow

        guard
            let colors = contents?.colors,
            colors.indices.contains(index)
        else {
            return nil
        }

        return colors[index]
    }

    // MARK: Actions

    @objc private func colorSpaceMenuItemClicked(_ item: NSMenuItem) {
        guard let colorSpace = item.representedObject as? NSColorSpace else { return }

        self.colorSpace = colorSpace
    }

    // MARK: Menu items

    @objc func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        guard let menuItemColorSpace = menuItem.representedObject as? NSColorSpace else { return false }

        if menuItemColorSpace == colorSpace {
            menuItem.state = .on
        } else {
            if let menuItemColorSpaceName = menuItemColorSpace.cgColorSpace?.name,
               let colorSpaceName = colorSpace.cgColorSpace?.name {
                menuItem.state = menuItemColorSpaceName == colorSpaceName ? .on : .off
            } else {
                menuItem.state = .off
            }
        }

        return true
    }
}

// MARK: NSTableViewDataSource

extension ColorPickerViewController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return contents?.colors.count ?? 0
    }
}

// MARK: NSTableViewDelegate

extension ColorPickerViewController: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: ColorCell.reuseIdentifier,
                                      owner: nil) as? ColorCell ?? ColorCell()

        cell.reload(with: color(for: row))

        return cell
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return ColorCell.height
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let selectedColor = color()?.nsColor(with: colorSpace) else { return }

        delegate?.colorPickerViewController(self, didSelectColor: selectedColor)
    }
}

// MARK: HeaderViewDelegate

extension ColorPickerViewController: HeaderViewDelegate {

    func headerView(_ headerView: HeaderView, didClickButton button: NSButton) {
        let menu = NSMenu(title: "Color space contextual menu")
        menu.font = ColorPickerViewController.menuFont

        for colorSpace in colorSpaces {
            guard
                let localizedName = colorSpace.localizedName,
                menu.items.contains(where: { $0.title == localizedName }) == false
            else {
                continue
            }

            let menuItem = NSMenuItem(title: localizedName,
                                      action: #selector(colorSpaceMenuItemClicked),
                                      keyEquivalent: "")
            menuItem.target = self
            menuItem.representedObject = colorSpace

            menu.addItem(menuItem)
        }

        let point = NSPoint(x: 0.0, y: button.bounds.height + ColorPickerViewController.menuOffset)
        menu.popUp(positioning: menu.items.first, at: point, in: button)
    }
}

// MARK: ColorPickerViewControllerDelegate

protocol ColorPickerViewControllerDelegate: class {

    func colorPickerViewController(_ colorPickerViewController: ColorPickerViewController,
                                   didSelectColor color: NSColor)
}
