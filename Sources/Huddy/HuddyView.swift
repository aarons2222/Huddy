//
//  File.swift
//  
//
//  Created by Aaron Strickland on 02/03/2023.
//


import Foundation
import SwiftUI



@available(iOS 14.0, *)
public struct HuddyView: View {
    var state: HuddyState
    var title: String
 
    public var body: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .center) {
                if state == .purchasing || state == .loading || state == .loadingFinished {
                    ProgressView()
                        .frame(width: 25.0, height: 25.0)
                        .foregroundColor(.primary)
                } else if state == .success {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                        .foregroundColor(.green)
                      
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                        .foregroundColor(.red)
                       
                }
                
                VStack(alignment: .leading) {
                    Text(title)
                }
            }.padding(.vertical, 10)
             .padding(.horizontal)
          
            
        }
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
    }
}


public enum HuddyState {
    case loading
    case purchasing
    case success
    case error
    case loadingFinished
}





public struct Huddy: Equatable {
    
    var state: HuddyState
    var title: String
    var duration: Double = 2.5
    
    public init(state: HuddyState, title: String, duration: Double = 2.5) {
        self.state = state
        self.title = title
        self.duration = duration
    }
}




@available(iOS 14.0, *)
public struct HuddyModifier: ViewModifier {
    @Binding var huddy: Huddy?
    @State private var workItem: DispatchWorkItem?
    
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainHuddyView()
                        .offset(y: -30)
                }.animation(.spring(), value: huddy)
            )
            .onChange(of: huddy) { value in
                showHuddy()
            }
    }
    
    
    
    
    
    @ViewBuilder func mainHuddyView() -> some View {
        if let huddy = huddy {
            VStack {
                
                
                Text("").padding(5)
                HuddyView(
                    state: huddy.state,
                    title: huddy.title)
                
                Spacer()
            }
            .transition(.move(edge: .top))
        }
    }
    
    public func showHuddy() {
        guard let huddy = huddy else { return }
        
        
        if huddy.state == .error || huddy.state == .success || huddy.state == .loadingFinished{
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            
            if huddy.duration > 0 {
                workItem?.cancel()
                
                let task = DispatchWorkItem {
                    dismissHuddy()
                }
                
                workItem = task
                
                let delay = huddy.state == .loadingFinished ? DispatchTimeInterval.milliseconds(200) : DispatchTimeInterval.seconds(Int(huddy.duration))
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: task)

                
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: task)
            }
        }
    }
    
    public func dismissHuddy() {
        withAnimation {
            huddy = nil
        }
        
        workItem?.cancel()
        workItem = nil
    }
}


@available(iOS 14.0, *)
public extension View {
    func huddyView(huddy: Binding<Huddy?>) -> some View {
        self.modifier(HuddyModifier(huddy: huddy))
    }
}


