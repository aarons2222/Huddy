//
//  File.swift
//  
//
//  Created by Aaron Strickland on 02/03/2023.
//


import Foundation
import SwiftUI



@available(iOS 14.0, *)
struct HuddyView: View {
    var state: HuddyState
    var title: String
 
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .center) {
                if state == .purchasing || state == .loading {
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


enum HuddyState {
    case loading
    case purchasing
    case success
    case error
}







struct Huddy: Equatable {
    var type: HuddyState
    var title: String
    var duration: Double = 2.5
}

@available(iOS 14.0, *)
struct HuddyModifier: ViewModifier {
    @Binding var huddy: Huddy?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
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
                    state: huddy.type,
                    title: huddy.title)
                
                Spacer()
            }
            .transition(.move(edge: .top))
        }
    }
    
    private func showHuddy() {
        guard let huddy = huddy else { return }
        
        
        if huddy.type == .error || huddy.type == .success{
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            
            if huddy.duration > 0 {
                workItem?.cancel()
                
                let task = DispatchWorkItem {
                    dismissHuddy()
                }
                
                workItem = task
                DispatchQueue.main.asyncAfter(deadline: .now() + huddy.duration, execute: task)
            }
        }
    }
    
    private func dismissHuddy() {
        withAnimation {
            huddy = nil
        }
        
        workItem?.cancel()
        workItem = nil
    }
}


@available(iOS 14.0, *)
extension View {
    func huddyView(huddy: Binding<Huddy?>) -> some View {
        self.modifier(HuddyModifier(huddy: huddy))
    }
}


