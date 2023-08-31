//
//  PhoneAuthView.swift
//  News-iOS-Assignment
//
//  Created by Jay Firke on 01/09/23.
//

import SwiftUI
import Firebase

struct PhoneAuthView: View {
    @State private var phoneNumber = ""
    @State private var selectedCountryCode = "+91"
    @State private var showingOTPView = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var showingProgress = false
    var body: some View {
        
        ZStack {
            VStack {
                Text("Enter Your Phone Number")
                    .font(AppFont.defaultFont)
                    .padding(.bottom, 20)
                
                HStack {
                    Text("+91").tag("+91")
                        .font(AppFont.defaultFont)
                        .foregroundColor(AppColor.grayColor)
                    Text("|")
                        .font(AppFont.defaultFont)
                        .foregroundColor(AppColor.grayColor)
                    TextField("Phone Number", text: $phoneNumber)
                        .font(AppFont.defaultFont)
                        .foregroundColor(AppColor.blackColor)
                        .keyboardType(.numberPad)
                        .onChange(of: phoneNumber) { newValue in
                            if newValue.count > 10 {
                                phoneNumber = String(newValue.prefix(10))
                            }
                        }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                
                Spacer()
                
                Button(action: {
                    showingProgress.toggle()
                    let cleanedPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

                    guard !cleanedPhoneNumber.isEmpty else {
                        showingProgress.toggle()
                        alertMessage = "Please enter a valid phone number."
                        showAlert = true
                        return
                    }
                    
                    let phoneNumberLength = cleanedPhoneNumber.count
                    guard phoneNumberLength == 10 else {
                        showingProgress.toggle()
                        alertMessage = "Phone number length is not valid."
                        showAlert = true
                        return
                    }

                    // Combine the selected country code and cleaned phone number
                    let formattedPhoneNumber = "\(selectedCountryCode)\(cleanedPhoneNumber)"

                    print("Formatted phone number: \(formattedPhoneNumber)")

                    PhoneAuthProvider.provider().verifyPhoneNumber(formattedPhoneNumber, uiDelegate: nil) { verificationID, error in
                        DispatchQueue.main.async {
                            showingProgress.toggle()
                                  if let error = error {
                                      print("Phone verification error: \(error.localizedDescription)")
                                      return
                                  }
                                  UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                                  showingOTPView = true // Present the OTPView
                              }
                    }
                }) {
                    Text("Submit")
                        .font(AppFont.defaultBold)
                        .foregroundColor(AppColor.whiteColor)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColor.blackColor)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .disabled(showingProgress) // Disable the button while progress is shown
            
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Validation Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                


                .fullScreenCover(isPresented: $showingOTPView) {
                    // Present the OTPView using fullScreenCover
                    OTPView()
                }
                
            }
            .padding(.top, 50)
            
            if showingProgress {
                ProgressView("Sending OTP...") // Show progress view
                    .font(AppFont.defaultFont)
                    .foregroundColor(AppColor.grayColor)
            }
        }
    }
}


struct PhoneAuthView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneAuthView()
    }
}

