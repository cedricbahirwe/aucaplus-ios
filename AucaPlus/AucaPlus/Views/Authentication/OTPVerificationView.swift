//
//  OTPVerificationView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 31/03/2023.
//

import SwiftUI

struct OTPVerificationView: View {
    let phoneNumber: String
    @State private var otp = ""
    @State private var previousOtp = ""
    @State private var elapsedTime: Int = 0
    @AppStorage("isLoggedIn")
    private var isLoggedIn: Bool = false
    
    private let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    private let otpResendTime = 180 // seconds
    
    var body: some View {
        VStack {
            AuthenticationView().titleView
            
            VStack(spacing: 20) {
                Text("Waiting to automatically detect an SMS sent\nto **\(phoneNumber)**. \(Text("Wrong number?").foregroundColor(.accentColor))")
                    .multilineTextAlignment(.center)
                
                
                TextField("- - -  - - -", text: $otp)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(width: 150)
                    .overlay(alignment: .bottom) {
                        Color.accentColor.frame(height: 1)
                    }
                    .multilineTextAlignment(otp.isEmpty ? .center : .leading)
                    .font(.title)
                    .opacity(0.9)
                    .onChange(of: otp, perform: handleOTP)
                
                
                Text("Enter 6-digit code")
                    .foregroundColor(.secondary)
                
                
                
                Button("Did not receive code?") {
                    
                }
                .bold()
                
                Text("You may request a new code in **\(counterMessage())**")
                
                
            }
            
            Spacer()
        }
        .toolbar(.hidden, for: .navigationBar)
        .padding()
        .onReceive(timer) { _ in
            updateCounter()
        }
    }
    
    private func handleOTP(_ newOTP: String) {
        // Make sure they are not equal
        guard previousOtp != newOTP else { return }
        
        // Make sure they are 6 digits
        guard newOTP.count < 12 else {
            otp = previousOtp
            isLoggedIn = true
            return
        }
        
        // Addition
        if newOTP.last != " " && previousOtp.count < newOTP.count {
            print("Addition")
            otp = newOTP + " "
            
            previousOtp = otp
            
        }
        // Removal
        else {
            print("Removal")
            previousOtp = String(newOTP.dropLast())
            
            otp = previousOtp
            
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
        OTPVerificationView(phoneNumber: "+250 782 600000")
    }
}
