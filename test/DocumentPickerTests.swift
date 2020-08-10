import XCTest
import SwiftUI
import SwiftUILib_DocumentPicker

final class DocumentPickerTests: XCTestCase {

  func testNotPresented() {
    _ = EmptyView().documentPicker(isPresented: .constant(false))
  }
  func testPresented() {
    _ = EmptyView().documentPicker(isPresented: .constant(true))
  }
}
