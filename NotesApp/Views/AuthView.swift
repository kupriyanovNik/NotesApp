//
//  LoginView.swift
//  NotesApp
//
//  Created by Никита Куприянов on 20.08.2023.
//

import SwiftUI
import FirebaseAuth

struct AuthView: View {
    
    @State private var isLoginMode: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""
    @State private var errorMessage: String = ""
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        ZStack {
            informationView
        }
        .background {
            LinearGradient(colors: [.cyan, .pink, .purple, .green], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 0, y: 2))
                .ignoresSafeArea()
                .opacity(0.3)
        }
        .onChange(of: isLoginMode) { _ in
            withAnimation {
                self.errorMessage = ""
            }
        }
        .navigationTitle(isLoginMode ? "Log In" : "Create account")
    }
    
    private var informationView: some View {
        ScrollView {
            VStack {
                Picker("", selection: $isLoginMode) {
                    Text("Log In")
                        .tag(true)
                    Text("Create account")
                        .tag(false)
                }
                .pickerStyle(.segmented)
                .padding(.bottom)
                
                TextField("email", text: $email, axis: .horizontal)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.none)
                    .padding(12)
                    .background(colorScheme == .dark ? .black : .white)
                    .cornerRadius(5)
                VStack(spacing: 16) {
                    SecureField("password", text: $password)
                        .textInputAutocapitalization(.none)
                        .padding(12)
                        .background(colorScheme == .dark ? .black : .white)
                        .cornerRadius(5)
                    if !isLoginMode {
                        SecureField("confirm password", text: $passwordConfirmation)
                            .textInputAutocapitalization(.none)
                            .padding(12)
                            .background(colorScheme == .dark ? .black : .white)
                            .cornerRadius(5)
                            .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
                    }
                }
                .padding(.top)
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(errorMessage.lowercased().contains("success") ? .green : .red)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .transition(.scale)
                        .font(.headline)
                        .padding(.top, 16)
                }
                
                Button {
                    handleAuth()
                } label: {
                    HStack {
                        Spacer()
                        Text(isLoginMode ? "Log In" : "Create account")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .bold()
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .background(settingsViewModel.appAccentColor.toColor())
                    .cornerRadius(5)
                    .transition(.slide)
                    .opacity(errorMessage == "" ? 1 : errorMessage.lowercased().contains("success") ? 1 : 0.5)
                }
                .padding(.top, 16)
                
                
                Spacer()
            }
            .padding()
        }
        .animation(.linear(duration: 0.2), value: isLoginMode)
    }
    private var loader: some View {
        Color.black.opacity(0.5)
            .ignoresSafeArea()
            .overlay {
                ProgressView()
                    .scaleEffect(2)
                    .offset(y: 100)
            }
    }
    
    private func handleAuth() {
        hideKeyboard()
        withAnimation {
            self.errorMessage = ""
        }
        if isLoginMode {
            logInUser()
        } else {
            createNewAccount()
        }
    }
    
    private func logInUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error {
                withAnimation {
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            settingsViewModel.isAuth = true 
            dismiss()
        }
        
    }
    
    private func createNewAccount() {
        if password == passwordConfirmation {
            FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
                if let error {
                    withAnimation {
                        self.errorMessage = error.localizedDescription
                    }
                    return
                }
                storeUserInformation()
            }
        } else {
            withAnimation {
                self.errorMessage = "Password is not equal to password confirmation"
            }
        }
    }
    private func storeUserInformation() {
        let manager = FirebaseManager.shared
        guard let uid = manager.auth.currentUser?.uid else { return }
        let userData = ["email" : self.email, "password" : password, "uid" : uid]
        manager.firestore
            .collection("users")
            .document(uid)
            .setData(userData) { error in
                if let error {
                    print(error)
                    withAnimation {
                        self.errorMessage = error.localizedDescription
                    }
                    return
                }
                settingsViewModel.isAuth = true
                dismiss()
            }
    }
    
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(SettingsViewModel())
    }
}
