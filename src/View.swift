import SwiftUI

public extension View {

  @inlinable func documentPicker(
    isPresented: Binding<Bool>,
    documentTypes: [String] = [],
    onCancel: @escaping () -> () = { },
    onDocumentsPicked: @escaping (_: [URL]) -> () = { _ in }
  ) -> some View {
    Group {
      self
      DocumentPicker(isPresented: isPresented, documentTypes: documentTypes, onCancel: onCancel, onDocumentsPicked: onDocumentsPicked)
    }
  }
}
