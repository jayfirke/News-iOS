//
//  OTPView.swift
//  News-iOS-Assignment
//
//  Created by Jay Firke on 01/09/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct OTPView: View {
    @State private var otp: String = ""
    @State private var isUserSignedIn = false

    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")

    @State private var showingProgress = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            VStack {
                Text("Enter OTP")
                    .font(AppFont.mediumFont)
                    .foregroundColor(AppColor.blackColor)
                    .padding()
                
                HStack(spacing: 10) {
                    ForEach(0..<6, id: \.self) { index in
                        DigitView(value: otp.digit(at: index))
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                NumericKeyboard(otp: $otp) {
                    self.verifyOTP()
                }
                
            }
            VStack {
                if showingProgress {
                    ProgressView("Verifying...") // Show progress view
                        .font(AppFont.defaultFont)
                        .foregroundColor(AppColor.grayColor)
                }
            }
            .onDisappear {
                saveUserSignedInStatus(isUserSignedIn)
            }

            .fullScreenCover(isPresented: $isUserSignedIn) {
                ContentView()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if alertTitle == "Success" {
                            // Perform action for successful OTP verification
                        }
                        otp = "" // Clear the entered OTP
                        showAlert = false // Reset the alert
                    }
                )
        }
        }
    }
    
    func verifyOTP() {
        showingProgress.toggle()
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID ?? "",
            verificationCode: otp
        )
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                let authError = error as NSError
                showingProgress.toggle()
                showAlert = true
                alertTitle = "Error"
                alertMessage = "OTP is incorrect!"
                return
            }
            showingProgress.toggle()
            print("User is signed in")
            saveUserSignedInStatus(true)
            isUserSignedIn = true // Set user signed in flag
        }
    }
    



}

struct DigitView: View {
    var value: Int?
    
    var body: some View {
        Text(value != nil ? "\(value!)" : "")
            .font(.title)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
    }
}

struct NumericKeyboard: View {
    @Binding var otp: String
    var onCompletion: () -> Void
    
    let rows: [[Int]] = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [-1, 0, -2]]
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { number in
                        Button(action: {
                            if number >= 0 {
                                otp.append("\(number)")
                            } else if number == -1 {
                                if !otp.isEmpty {
                                    otp.removeLast()
                                }
                            } else if number == -2 {
                                onCompletion() // Call the completion block
                            }
                        }) {
                            if number == -2 { // "Verify" button
                                    Text("Verify")
                                        .underline()
                                        .font(AppFont.defaultBold)
                                        .foregroundColor(AppColor.blackColor)
                                        .frame(width: 80, height: 80)
                                        .background(AppColor.whiteColor)
                                        .foregroundColor(.black)
                                        .cornerRadius(40)
                            } else {
                                if number >= 0 {
                                    Text(number >= 0 ? "\(number)" : "Delete")
                                        .font(AppFont.mediumBold)
                                        .foregroundColor(AppColor.whiteColor)
                                        .frame(width: 80, height: 80)
                                        .background(AppColor.blackColor.opacity(number >= 0 ? 1 : 0))
                                        .foregroundColor(.black)
                                        .cornerRadius(40)
                                }else{
                                    Image(systemName: "delete.left.fill")
                                        .foregroundColor(AppColor.whiteColor)
                                        .font(AppFont.defaultBold)
                                        .frame(width: 80, height: 80)
                                        .background(AppColor.blackColor.opacity(1))
                                        .cornerRadius(40)
                                    
                                }
                               
                            }
                        }
                    }
                }
            }
        }
    }
}

extension String {
    func digit(at index: Int) -> Int? {
        guard index >= 0 && index < count else {
            return nil
        }
        let digitIndex = self.index(startIndex, offsetBy: index)
        return Int(String(self[digitIndex]))
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView()
    }
}
