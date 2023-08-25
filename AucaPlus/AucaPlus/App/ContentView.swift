//
//  ContentView.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 31/03/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var animatingOnBoarding = true
    @State private var showingOnBoarding = true
    
    @AppStorage(StorageKeys.isLoggedIn)
    private var isLoggedIn: Bool = false
    
    
    var body: some View {
        //        TestingView()
        if  isLoggedIn || AuthClient.shared.isAuthenticated  {
            AppTabView()
            
        } else {
            NavigationStack {
                ZStack {
                    AuthenticationView()
                    
                    if showingOnBoarding {
                        OnboardingView()
                            .opacity(animatingOnBoarding ? 1 : 0)
                            .animation(.easeInOut(duration: 0.5), value: animatingOnBoarding)
                            .onAppear() {
                                DispatchQueue.main.asyncAfter(deadline: OnboardingConstants.onboardingAnimateDelay) {
                                    animatingOnBoarding = false
                                }
                                DispatchQueue.main.asyncAfter(deadline: OnboardingConstants.onboardingDisplayDelay) {
                                    showingOnBoarding = false
                                }
                            }
                    }
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
