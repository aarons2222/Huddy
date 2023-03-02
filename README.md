# Huddy

Huddy is a lightweight and customizable progress indicator library for iOS that works with both UIKit and SwiftUI.


## Installation

### Swift Package Manager

You can install UnifiedToast using Swift Package Manager. In Xcode, go to `File > Swift Packages > Add Package Dependency` and enter the URL for this repository: https://github.com/aarons2222/Huddy

### Manual

Alternatively, you can also add the `Huddy.swift` file to your Xcode project manually.



## With SwiftUI 



```
import SwiftUI
import Huddy

struct ContentView: View {
    
    @State private var huddy: Huddy? = nil

    var body: some View {
        VStack {
            Button {
                huddy = Huddy(state: .loading, title: "Loading")
            } label: {
                Text("Run")
            }
        }
        .huddyView(huddy: $huddy)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


```






## With UIKit 



