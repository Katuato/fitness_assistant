//
//  AuthView.swift
//  fitness_assistant
//
//  Created by katuato on 29.11.2025.
//

import SwiftUI

struct AuthView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingCreateAccount = false
    @State private var showingForgotPassword = false
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        ZStack {
            Image("auth_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            VStack() {
                HStack {
                       Spacer()
                       Text("Are you already\nin our team?")
                           .font(.system(size: 32, weight: .bold))
                           .multilineTextAlignment(.trailing)
                           .foregroundColor(.white)
                           .lineSpacing(0)
                           .padding(.top, 47)
                           .padding(.trailing, 27)
                       }
                .padding(.bottom, 205)
                
 
//                HStack(spacing: 15) {
//                    SocialAuthButton(iconName: "vk", text: "Continue with VK")
//                    SocialAuthButton(iconName: "google", text: "Continue with Google")
//                    SocialAuthButton(iconName: "apple", text: "Continue with Apple")
//                }
//                .padding(.horizontal, 40)
                
                VStack(spacing: 11) {
                    CustomTextField(
                        text: $email,
                        placeholder: "login",
                        iconName: "envelope"
                    )
                    
                    CustomTextField(
                        text: $password,
                        placeholder: "password",
                        iconName: "lock",
                        isSecure: true
                    )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 15)
                

                HStack() {
                    Button("Create\naccount") {
                        showingCreateAccount = true
                    }
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .lineSpacing(0)
                    .underline()
                
                    Spacer()
                    
                    Button("Forget the\npassword?") {
                        showingForgotPassword = true
                    }
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .lineSpacing(0)
                    .underline()
                }
                .padding(.horizontal,60)
                
                
                Spacer()
                Button("SIGN IN") {
//                    authService.login(email: email, password: password)
                    authService.isAuthenticated = true
                    
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
                .padding(.bottom,80)
            }
        }
        .sheet(isPresented: $showingCreateAccount) {
            CreateAccountView()
        }
        .sheet(isPresented: $showingForgotPassword) {
            ForgotPasswordView()
        }
    }
}


struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let iconName: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(Color.white)
                    .accentColor(Color.white)
                    .placeholder(when: text.isEmpty) {
                                            Text(placeholder)
                                                .foregroundColor(Color.white)
                                                .font(.system(size: 24, weight: .bold))
                                        }
                
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(Color.white)
                    .accentColor(Color.white)
                    .placeholder(when: text.isEmpty) {
                                            Text(placeholder)
                                                .foregroundColor(Color.white)
                                                .font(.system(size: 24, weight: .bold))
                                        }
            }
        }
        .foregroundColor(Color.white)
        .accentColor(Color.white)
        .font(.system(size: 24, weight: .bold))
        .padding()
        .frame(width: 339, height: 81)
        .background(Color.white.opacity(0))
        .background(
            Image("custom_dropdown_menu_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 339, height: 81)
                .cornerRadius(24)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white, lineWidth: 2)
        )
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct SocialAuthButton: View {
    let iconName: String
    let text: String
    
    var body: some View {
        Button(action: {
          
        }) {

                Image(systemName: iconName)
                    .foregroundColor(.white)
            
            .padding()
            .background(Color.white.opacity(0.15))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
