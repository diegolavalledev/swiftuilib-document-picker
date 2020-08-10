import SwiftUI

#if os(macOS)

@usableFromInline struct DocumentPicker: View {

  @Binding var isPresented: Bool
  var documentTypes: [String] // [kUTTypeFolder as String]
  var onCancel: () -> ()
  var onDocumentsPicked: (_: [URL]) -> ()

  @usableFromInline init(
     isPresented: Binding<Bool>,
     documentTypes: [String],
     onCancel: @escaping () -> (),
     onDocumentsPicked: @escaping (_: [URL]) -> ()
  ) {
    self._isPresented = isPresented
    self.documentTypes = documentTypes
    self.onCancel = onCancel
    self.onDocumentsPicked = onDocumentsPicked
  }

  @usableFromInline var body: some View {
    Color.clear.frame(width: 0, height: 0)
    .id(isPresented)
    .onAppear {
      if self.isPresented {
          let panel = NSOpenPanel()
          panel.canChooseFiles = true
          panel.canChooseDirectories = true
          panel.allowedFileTypes = self.documentTypes
          panel.resolvesAliases = true
          panel.isAccessoryViewDisclosed = false

          // panel.allowsMultipleSelection = true
          // panel.directoryURL = URL()

          let result = panel.runModal()
          guard result == .OK else {
            self.isPresented.toggle()
            self.onCancel()
            return
          }
          self.isPresented.toggle()
          self.onDocumentsPicked(panel.urls)
        }
    }
  }
}

#else
import UIKit

@usableFromInline struct DocumentPicker: UIViewControllerRepresentable {

  @usableFromInline class Coordinator: NSObject {

    var parent: DocumentPicker
    var pickerController: UIDocumentPickerViewController
    var presented = false

    init(_ parent: DocumentPicker) {
      self.parent = parent
      self.pickerController = UIDocumentPickerViewController(documentTypes: parent.documentTypes,
      in: .open)

      // self.pickerController.allowsMultipleSelection = true
      // self.pickerController.directoryURL = URL()

      super.init()
      pickerController.delegate = self
    }
  }

  @Binding var isPresented: Bool
  var documentTypes: [String] // [kUTTypeFolder as String]
  var onCancel: () -> ()
  var onDocumentsPicked: (_: [URL]) -> ()

  @usableFromInline init(
     isPresented: Binding<Bool>,
     documentTypes: [String],
     onCancel: @escaping () -> (),
     onDocumentsPicked: @escaping (_: [URL]) -> ()
  ) {
    self._isPresented = isPresented
    self.documentTypes = documentTypes
    self.onCancel = onCancel
    self.onDocumentsPicked = onDocumentsPicked
  }
  
  @usableFromInline func makeUIViewController(context: Context) -> UIViewController {
    UIViewController()
  }

  @usableFromInline func updateUIViewController(_ presentingController: UIViewController, context: Context) {
    let pickerController = context.coordinator.pickerController
    if isPresented && !context.coordinator.presented {
      context.coordinator.presented.toggle()
      presentingController.present(pickerController, animated: true)
    } else if !isPresented && context.coordinator.presented {
      context.coordinator.presented.toggle()
      pickerController.dismiss(animated: true)
    }
  }

  @usableFromInline  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
}

extension DocumentPicker.Coordinator: UIDocumentPickerDelegate {
  @usableFromInline func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    parent.isPresented.toggle()
    parent.onDocumentsPicked(urls)
  }
  
  @usableFromInline func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    parent.isPresented.toggle()
    parent.onCancel()
  }
}
#endif

struct DocumentPicker_Previews: PreviewProvider {
  static var previews: some View {
    Text("Document picker")
    .documentPicker(
      isPresented: .constant(true),
      documentTypes: ["public.folder"]
    )
  }
}
