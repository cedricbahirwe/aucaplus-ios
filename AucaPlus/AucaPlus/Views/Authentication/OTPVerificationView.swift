//
//  OTPVerificationView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 31/03/2023.
//

import SwiftUI

struct OTPVerificationView: View {
    @ObservedObject var authVM: AuthenticationViewModel
    @State private var goToUserInfo = false
    
    @State private var otp = ""
    @State private var previousOtp = ""
    @State private var elapsedTime: Int = 0
    
    private let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    private let otpResendTime = 180
    
    @FocusState private var focusedField: Bool
    
    var body: some View {
        VStack {
            AuthenticationView.TitleView(title: "Verifying your number")
            
            VStack(spacing: 20) {
                Text("Waiting to automatically detect an SMS sent\nto **\(authVM.authModel.formattedPhone())**. \(Text("Wrong number?").foregroundColor(.accentColor))")
                    .multilineTextAlignment(.center)
                
                
                TextField("- - -  - - -", text: $otp)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .focused($focusedField)
                    .fixedSize()
                    .overlay(alignment: .bottom) {
                        Color.accentColor.frame(height: 1)
                    }
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .opacity(0.9)
                    .frame(maxWidth: 150)
                    .onChange(of: otp, perform: handleOTP)
                
                
                Text("Enter 6-digit code")
                    .foregroundColor(.secondary)
                
                Button("Did not receive code?") {
                    // Should redirect to help center
                }
                .bold()
                
                Text("You may request a new code in **\(counterMessage())**")
            }
            
            if authVM.isValidatingOTP {
                ProgressView()
                    .tint(.accentColor)
            }
            Spacer()
        }
        .toolbar(.hidden, for: .navigationBar)
        .alert(item: $authVM.alertItem) { item in
            Alert(
                title: Text("OTP Error"),
                message: Text(item.message),
                dismissButton: .default(
                    Text("Got It!"),
                    action: {
                        otp = ""
                    }
                )
            )
        }
        .padding()
        .disabled(authVM.isValidatingOTP)
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.05) {
                focusedField = true
            }
        }
        .navigationDestination(isPresented: $authVM.goToUserDetails) {
            AuthInfoView(authVM: authVM)
        }
        .onReceive(timer) { _ in
            updateCounter()
        }
    }
    
    private func login() {
        otp = previousOtp
        hideKeyboard()

        let cleanOTP = otp.replacingOccurrences(of: " ", with: "")
        
        guard cleanOTP.count == 6 else { return }
        Task {
            await authVM.verifyOTP(cleanOTP)
        }
    }
    
    private func handleOTP(_ newOTP: String) {
        if previousOtp.count == 0 && newOTP.count == 6 {
            previousOtp = newOTP
            login()
            return
        }
        // Make sure they are not equal
        guard previousOtp != newOTP else { return }
        
        // Make sure they are 6 digits
        guard newOTP.count < 12 else { return }
        
        // Addition
        if newOTP.last != " " && previousOtp.count < newOTP.count {
            otp = newOTP + " "
            
            previousOtp = otp
        }
        // Removal
        else {
            previousOtp = String(newOTP.dropLast())
            
            otp = previousOtp
        }
        
        if previousOtp.count == 12 {
            login()
        }
    }
    
    private func updateCounter() {
        self.elapsedTime += 1
        
        if self.elapsedTime >= otpResendTime {
            timer.upstream.connect().cancel()
        }
    }
    
    private func counterMessage() -> String {
        let remainingTime = max(otpResendTime - elapsedTime, 0)
        let remainingMinutes = remainingTime / 60
        let remainingSeconds = remainingTime % 60
        
        return String(format: "%d:%02d", remainingMinutes, remainingSeconds)
    }
}


struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView(authVM: AuthenticationViewModel())
    }
}
