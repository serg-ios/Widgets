# Widgets

Hands-on the WWDC videos related to iOS widgets.

## [Widgets Code-along, part 1: The adventure begins](https://developer.apple.com/videos/play/wwdc2020/10034/)

A widget is a SwiftUI view that updates over time.

Create a widget target: `File > New > Target > Widget`.

Activate the target.

We can preview widgets using SwiftUI previews.

Add a preview context: `WidgetPreviewContext(family:)`.

`Widget` protocol has a body that is some `WidgetConfiguration`. In its body, we can have a static configuration containing modifiers like the configuration display name, the widget's description, and supported families.

The timeline provider provides snapshots when we want one entry (widget gallery).

`PlaceholderView` is what the widget should show when it's not ready.

To preview the placeholder view, do a `Group` inside the preview, and both views will be previewed (the placeholder and the actual widget).

There is a SwiftUI modifier `.redacted(reason: .placeholder)` that placeholders SwiftUI views very quickly.
