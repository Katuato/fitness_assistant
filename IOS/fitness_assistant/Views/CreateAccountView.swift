//
//  CreateAccountView.swift
//  fitness_assistant
//
//  Created by katuato on 29.11.2025.
//

import SwiftUI

struct CreateAccountView: View {
    @Environment(\.dismiss) var dismiss
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var birthDate = Date()
    @State private var selectedGender: String = ""
    @State private var selectedHeight: String = ""
    @State private var selectedWeight: String = ""
    @State private var selectedLevel: String = ""
    @State private var selectedGoal: String = ""
    
    let genders = ["Male", "Female", "Other"]
    let heights = Array(140...220).map { "\($0) cm" }
    let weights = Array(40...150).map { "\($0) kg" }
    let trainingLevels = ["Beginner", "Intermediate", "Advanced", "Professional"]
    let goals = ["Weight Loss", "Muscle Gain", "Maintenance", "Endurance", "General Fitness"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("create_account_view_background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 15) {
                        Text("LET’S CREATE\nYOUR ACCOUNT")
                            .font(.system(size: 32, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .lineSpacing(0)
                            .padding(.top, 92)
                            .padding(.bottom, 32)

                        Group {
                            CustomTextField(
                                text: $userName,
                                placeholder: "username",
                                iconName: "person"
                            )
                            
                            CustomTextField(
                                text: $email,
                                placeholder: "email",
                                iconName: "envelope"
                            )
                            
                            CustomTextField(
                                text: $password,
                                placeholder: "password",
                                iconName: "lock",
                                isSecure: true
                            )
                            
                            CustomTextField(
                                text: $confirmPassword,
                                placeholder: "confirm password",
                                iconName: "lock",
                                isSecure: true
                            )
                        }
                            
                        CustomDatePicker(selection: $birthDate,
                                        placeholder: "birthdate",
                                        iconName: "calendar")
                        

                        Group {
                            CustomDropdownMenu(
                                selectedValue: $selectedGender,
                                placeholder: "gender",
                                options: genders,
                                iconName: "person.2"
                            )
                            
                            CustomDropdownMenu(
                                selectedValue: $selectedHeight,
                                placeholder: "height",
                                options: heights,
                                iconName: "ruler"
                            )
                            
                            CustomDropdownMenu(
                                selectedValue: $selectedWeight,
                                placeholder: "weight",
                                options: weights,
                                iconName: "scalemass"
                            )
                            
                            CustomDropdownMenu(
                                selectedValue: $selectedLevel,
                                placeholder: "training level",
                                options: trainingLevels,
                                iconName: "chart.bar"
                            )
                            
                            CustomDropdownMenu(
                                selectedValue: $selectedGoal,
                                placeholder: "goal",
                                options: goals,
                                iconName: "target"
                            )
                        }

                        Button("SIGN UP") {
                            //Переход на главную страницу
                        }
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 339, height: 81)
                        .background(Color.white.opacity(0))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .padding(.top, 78)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func createAccount() {
        // Логика создания аккаунта
        dismiss()
    }
}

struct CustomDatePicker: View {
    @Binding var selection: Date
    let placeholder: String
    let iconName: String
    
    var body: some View {
        HStack {
            Text(placeholder)
                .foregroundColor(Color.white)
                .font(.system(size: 24, weight: .bold))
            
            Spacer()
            
            DatePicker("", selection: $selection, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .colorScheme(.dark)
                .accentColor(.white)
        }
        .foregroundColor(Color.white)
        .accentColor(Color.white)
        .font(.system(size: 24, weight: .bold))
        .padding()
        .frame(width: 339, height: 81)
        .background(Color.white.opacity(0))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white, lineWidth: 2)
        )
    }
}

struct CustomDropdownMenu: View {
    @Binding var selectedValue: String
    let placeholder: String
    let options: [String]
    let iconName: String
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(selectedValue.isEmpty ? placeholder : selectedValue)
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold))
                    .placeholder(when: selectedValue.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .bold))
                    }
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
            }
            .padding()
            .frame(width: 339, height: 81)
            .background(Color.white.opacity(0))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white, lineWidth: 2)
            )
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedValue = option
                                isExpanded = false
                            }
                        }) {
                            HStack {
                                Text(option)
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold))
                                Spacer()
                            }
                            .padding()
                            .frame(height: 60)
                            .background(Color.white.opacity(0))
                        }
                        
                        if option != options.last {
                            Divider()
                                .background(Color.white.opacity(0.5))
                        }
                    }
                }
                .background(Color.white.opacity(0))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white, lineWidth: 2)
                )
            }
        }
        .frame(width: 339)
    }
}
