import SwiftUI
import StoreKit

@MainActor
class VersionChecker: ObservableObject, @unchecked Sendable {
    static let shared = VersionChecker()
    
    @Published var isUpdateAvailable = false
    private let appStoreId = "YOUR_APP_STORE_ID" // Replace with your app's App Store ID
    
    func checkForUpdate() async {
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
              let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(Bundle.main.bundleIdentifier ?? "")") else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONDecoder().decode(AppStoreResponse.self, from: data)
            
            if let appStoreVersion = json.results.first?.version {
                let isNewer = compareVersions(appStoreVersion, isNewerThan: currentVersion)
                DispatchQueue.main.async {
                    self.isUpdateAvailable = isNewer
                }
            }
        } catch {
            print("Error checking for app update: \(error)")
        }
    }
    
    private func compareVersions(_ version1: String, isNewerThan version2: String) -> Bool {
        let v1Components = version1.split(separator: ".")
        let v2Components = version2.split(separator: ".")
        
        let maxLength = max(v1Components.count, v2Components.count)
        
        for i in 0..<maxLength {
            let v1 = i < v1Components.count ? Int(v1Components[i]) ?? 0 : 0
            let v2 = i < v2Components.count ? Int(v2Components[i]) ?? 0 : 0
            
            if v1 > v2 {
                return true
            } else if v1 < v2 {
                return false
            }
        }
        return false
    }
    
    func openAppStore() {
        guard let url = URL(string: "https://apps.apple.com/app/id\(appStoreId)") else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - App Store Response Models
struct AppStoreResponse: Codable {
    let results: [AppStoreResult]
}

struct AppStoreResult: Codable {
    let version: String
}

// MARK: - Update Alert View
struct UpdateAlertView: View {
    @ObservedObject private var versionChecker = VersionChecker.shared
    
    var body: some View {
        ZStack {
            if versionChecker.isUpdateAvailable {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Update Required")
                        .font(.title2)
                        .bold()
                    
                    Text("A new version of the app is available. Please update to continue using the app.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: {
                        versionChecker.openAppStore()
                    }) {
                        Text("Update Now")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .padding(.horizontal, 40)
            }
        }
        .task {
            await versionChecker.checkForUpdate()
        }
    }
}