//
//  ForgotPasswordView.swift
//  fitness_assistant
//
//  Created by katuato on 29.11.2025.
//


import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("forget_password_background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack() {
                    Spacer()
                    Text("Forgot your password?")
                        .font(.system(size: 32, weight: .bold))
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.white)
                        .lineSpacing(0)
                        .padding(.horizontal,35)
                        .padding(.bottom, 45)
                    
                    Text("Enter your email address below and\nwe'll send you instructions to reset it")
                        .font(.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.white)
                        .lineSpacing(0)
                        .padding(.horizontal,35)
                        .padding(.bottom, 18)
                        
                    
                    CustomTextField(
                        text: $email,
                        placeholder: "email",
                        iconName: "envelope"
                    )
                    .padding(.horizontal, 45)
                    Spacer()
                    Button("RECOVER PASSWORD") {
                    }
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 339, height: 81)
                    .background(Color.white.opacity(0))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white, lineWidth: 2)
                    )
            .padding(.horizontal, 45)
            .padding(.bottom,70)
                    

                }
//                .padding(.top, 50)
            }

        }
        .preferredColorScheme(.dark)
    }
}
