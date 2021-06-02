## LPSnackbar


<p align="center">
<img src="https://raw.githubusercontent.com/carlosDigio/LPSnackbar/master/.github/Screen2.png"/>  
</p>

## Features 

- Flexible, easy to use and customizable.
- _Snacks_ are stackable and swipeable.
- _Snacks_ are actionable.
	
	<img src="https://raw.githubusercontent.com/carlosDigio/LPSnackbar/master/.github/Screen3.jpg" width="350"/>  

- Supports iOS 11.0 +
- Written with the latest Swift (Swift 5)

## Installation

### Cocoapods (recommended)

1. Install [CocoaPods](https://cocoapods.org).
2. Add this pod to your `Podfile`.

	```ruby
	target 'Example' do
	  use_frameworks!

	  pod 'LPSnackbar'
	end
	```
3. Run `pod install`.
4. Open up the `.xcworkspace` that CocoaPods created.
5. Import `LPSnackbar` into any source file where it's needed.

### From Source

1. Simply download the source from [here](https://github.com/carlosDigio/LPSnackbar/tree/master/LPSnackbar) and add it to your Xcode project.


## Usage

Snacks can be simple

```swift
// Yes, this simple.
let snackbar = LPSnackbarManager.createSnackBar(title: "I'm a snack!")
snackbar.viewToDisplayIn = view

LPSnackbarManager.show(snackBar: snackbar)
```

Snacks can be customized

```swift
let snackbar = LPSnackbarManager.createSnackBar(title: text, buttonTitle: "Undo", delegate: self)
snackbar.viewToDisplayIn = view
snackbar.bottomSpacing = (tabBarController?.tabBar.frame.height ?? 0) + 12
snackbar.adjustsPositionForSafeArea = false

LPSnackbarManager.show(snackBar: snackbar)
```

## Example

Download and run the example project

## Documentation

Full documentation available [here](https://htmlpreview.github.io/?https://github.com/luispadron/LPSnackbar/blob/master/docs/index.html)
