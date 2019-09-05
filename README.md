# Zeplin Color Picker 🎨

[Zeplin](https://zeplin.io)'s macOS color picker that lets you select colors from the project you have open in Zeplin. Installing Zeplin's macOS app automatically installs this color picker as well.

## Installation

Building the Xcode project produces a bundle called `ZeplinColorPicker.colorPicker`. Copying this bundle to the `~/Library/ColorPickers/` directory installs it systemwide.

## Handy tips

### Automate installation

You can install the picker systemwide automatically by adding a run script to the project:

```sh
rm -rf ~/Library/ColorPickers/ZeplinColorPicker.colorPicker
cp -R $BUILD_DIR/Debug/ZeplinColorPicker.colorPicker ~/Library/ColorPickers/ZeplinColorPicker.colorPicker
```

### Testing

To simplify testing the picker, you can create an application using the Script Editor:

- Launch `Script Editor.app` and create a document.
- Paste the following AppleScript code:

```applescript
choose color
```

- Save the document in “Application” format.

Furthermore, you can launch this application automatically by adding a run script to the project:

```sh
kill `pgrep applet`
open APPLICATION_PATH
```

## License

Zeplin Color Picker is released under the MIT license. See [LICENSE](LICENSE) for details.

---

<a href="https://zeplin.io"><img src="img/logo.svg" alt="Zeplin Logo" /></a>

Zeplin Color Picker is crafted and maintained by the crew behind [Zeplin](https://zeplin.io). Follow [@zeplin](https://twitter.com/zeplin) on Twitter for project updates and releases.
