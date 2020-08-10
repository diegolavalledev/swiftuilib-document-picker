**DocumentPicker** documentation

# View modifier: `documentPicker`

The only required parameter is `isPresented` which controls the document picker's presentation status.

```swift
extension View {

  @inlinable func documentPicker(
    isPresented: Binding<Bool>,
    documentTypes: [String] = [],
    onCancel: @escaping () -> () = { },
    onDocumentsPicked: @escaping (_: [URL]) -> () = { _ in }
  ) -> some View { … }
}
```

## Example

Ask the user to select a folder. Manage cancellation as well as successful picks.

```swift
import SwiftUI
import SwiftUILib_DocumentPicker
import MobileCoreServices

struct ContentView: View {

  @State var showDocPicker = false

  var body: some View {
    Button("Show document picker") {
      self.showDocPicker.toggle()
    }
    .documentPicker(
      isPresented: $showDocPicker,
      documentTypes: [kUTTypeFolder as String /* "public.folder" */ ],
      onCancel: {
        print("User cancelled.")
      }
    ) { urls in
      print("Selected folder: \(urls.first!)")
    }
  }
}
```
