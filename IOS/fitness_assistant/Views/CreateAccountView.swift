//
//  CreateAccountView.swift
//  fitness_assistant
//
//  Created by katuato on 29.11.2025.
//

import SwiftUI

struct CreateAccountView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
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
    @State private var showPasswordMismatchError: Bool = false
    
    let genders = ["male", "female", "other"]
    let heights = Array(140...220).map { "\($0) cm" }
    let weights = Array(40...150).map { "\($0) kg" }
    let trainingLevels = ["beginner", "intermediate", "advanced", "professional"]
    let goals = ["weight loss", "muscle gain", "maintenance", "endurance", "general fitness"]
    
    var isFormValid: Bool {
        !userName.isEmpty && 
        !email.isEmpty && 
        password.count >= 6 && 
        password == confirmPassword
    }
    
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

                        // Password mismatch error
                        if showPasswordMismatchError && password != confirmPassword {
                            Text("Passwords do not match")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.red)
                                .padding(.top, 5)
                        }
                        
                        // Server error message
                        if let errorMessage = authService.errorMessage {
                            Text(errorMessage)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.red)
                                .padding(.top, 5)
                        }

                        Button(action: {
                            showPasswordMismatchError = true
                            if isFormValid {
                                Task {
                                    // Форматируем дату в YYYY-MM-DD
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                    let formattedDate = dateFormatter.string(from: birthDate)
                                    
                                    await authService.register(
                                        email: email,
                                        password: password,
                                        name: userName,
                                        birthDate: formattedDate,
                                        gender: selectedGender.isEmpty ? nil : selectedGender.lowercased(),
                                        height: selectedHeight.isEmpty ? nil : selectedHeight,
                                        weight: selectedWeight.isEmpty ? nil : selectedWeight,
                                        locale: Locale.current.identifier
                                    )
                                    if authService.isAuthenticated {
                                        dismiss()
                                    }
                                }
                            }
                        }) {
                            if authService.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(width: 339, height: 81)
                            } else {
                                Text("SIGN UP")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 339, height: 81)
                            }
                        }
                        .background(Color.white.opacity(0))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(isFormValid ? Color.white : Color.white.opacity(0.5), lineWidth: 2)
                        )
                        .disabled(authService.isLoading)
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
            
            DatePicker("", selection: $selection, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .colorScheme(.dark)
                .accentColor(.white)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)

                .background(Color.white.opacity(0))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white, lineWidth: 1)
                )
        }
        .foregroundColor(Color.white)
        .accentColor(Color.white)
        .font(.system(size: 24, weight: .bold))
        .padding()
        .background(
            Image("custom_dropdown_menu_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 339, height: 81) 
                .cornerRadius(24)
        )
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
    @State private var showPicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                showPicker.toggle()
            }) {
                HStack {
                    Text(selectedValue.isEmpty ? placeholder : selectedValue)
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .bold))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                }
                .padding()
                .frame(width: 339, height: 81)
                .background(Color.white.opacity(0))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white, lineWidth: 2)
                )
            }
        }
        .frame(width: 339)
        .background(
            Image("custom_dropdown_menu_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 339, height: 81)
                .cornerRadius(24)
        )
        .frame(width: 339, height: 81)
        .sheet(isPresented: $showPicker) {
            NativePickerView(
                selectedValue: $selectedValue,
                options: options,
                showPicker: $showPicker
            )
            .presentationDetents([.height(250)])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(30)
        }
    }
    
    
}
struct NativePickerView: View {
    @Binding var selectedValue: String
    let options: [String]
    @Binding var showPicker: Bool
    
    @State private var tempSelection: String
    
    init(selectedValue: Binding<String>, options: [String], showPicker: Binding<Bool>) {
        self._selectedValue = selectedValue
        self.options = options
        self._showPicker = showPicker
        let currentValue = selectedValue.wrappedValue
        self._tempSelection = State(initialValue: currentValue.isEmpty && !options.isEmpty ? options[0] : currentValue)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Cancel") {
                    showPicker = false
                }
                .foregroundColor(.white)
                .font(.system(size: 17))
                .padding(.leading, 20)

                
                Spacer()
                
                Button("Done") {
                    selectedValue = tempSelection
                    showPicker = false
                }
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .semibold))
                .padding(.trailing, 20)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(.systemGray6))

            Picker("", selection: $tempSelection) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                        .tag(option)
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGray6))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
        .presentationDetents([.height(350)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(0)
        .interactiveDismissDisabled()
        .colorScheme(.dark)
    }
}
