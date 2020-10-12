import SwiftUI

///This is our all in one modifier that we can add as many attributes to as we want!
struct FloatieAccessibilityModifier: ViewModifier { 
     
    ///A label that is visible to UI tests AND VoiceOver
    let label: String?
    
    ///An identifier that is visible to UI tests NOT VoicOver
    let identifier: String?
    
    ///A value that tells VoiceOver and UI tests what a Stepper, Slider or Toggle's current state is
    let value: String?
    
    ///An extra hint that is read by VoiceOver after the label and value to give extra context
    let hint: String?
    
    ///A bool that determines whether VoiceOver will ignore this View, such as an icon that doesn't add any additional context
    let hidden: Bool?
    
    ///The required function that returns our View with the necessary accessibility modifiers
    func body(content: Content) -> some View {
        content
            .accessibility(label: Text(label ?? ""))
            .accessibility(identifier: identifier ?? "")
            .accessibility(value: Text(value ?? ""))
            .accessibility(hint: Text(hint ?? ""))
            .accessibility(hidden: hidden ?? false)
    }
}

extension View {
    ///This wrapper simplifies the call so we don't have to use the .modifier(A11yModifier()) syntax
    func accessable(label: String = "", identifier: String = "", value: String = "", hint: String = "", hidden: Bool = false) -> some View {
        self.modifier(FloatieAccessibilityModifier(label: label, identifier: identifier, value: value, hint: hint, hidden: hidden))
    }
}
