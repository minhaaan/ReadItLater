import ComposableArchitecture
import Foundation
import Testing

@testable import ReadItLater

final class MainInputTests {
  init() async throws {}

  @Test func textFieldChanged() async throws {
    // GIVEN
    let mainInput = MainInput()
    var currentState = MainInput.State()
    #expect(currentState.writeButtonIsHidden == true)
    #expect(currentState.text.isEmpty == true)
    
    let dummyText = "test"

    // WHEN
    _ = mainInput.reduce(into: &currentState, action: .textFieldChanged(dummyText))

    // THEN
    #expect(currentState.writeButtonIsHidden == false)
    #expect(currentState.text == dummyText)
  }
  
  @Test() func textFieldChangedWriteButtonDisabled() async throws {
    // GIVEN
    let mainInput = MainInput()
    var currentState = MainInput.State()
    #expect(currentState.writeButtonDisabled == true)
    
    let dummyText = "test"
    
    // WHEN
    _ = mainInput.reduce(into: &currentState, action: .textFieldChanged(dummyText))
    
    // THEN
    #expect(currentState.writeButtonDisabled == false)
  }
}
