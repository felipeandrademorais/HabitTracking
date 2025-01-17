import SwiftUI

struct EditNameModalView: View {
    @EnvironmentObject var profileStore: UserProfileStore
    @State private var newName: String = ""

    var body: some View {
        ZStack {
            Color.color2.ignoresSafeArea()
            
            Form {
                Text("Edit Name")
                    .font(Font.custom("Poppins-Regular", size: 16))
                
                Section {
                    TextField("Seu nome", text: $newName)
                        .font(Font.custom("Poppins-Regular", size: 14))
                        .padding(.vertical, 10)
                        .overlay(
                            Rectangle()
                                .frame(height: 1.8)
                                .foregroundColor(.blackSoft.opacity(0.4))
                                .padding(.top, 40),
                            alignment: .bottom
                        )
                        .padding(.bottom, 12)
                }
                
                Button(action: addName) {
                    Text("Adicionar")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.fontSoft)
                }
                .disabled(newName.isEmpty && newName == profileStore.user.name)
            }
            .onAppear {
                newName = profileStore.user.name
            }
        }
        .scrollContentBackground(.hidden)
    }
    
    private func addName() {
        profileStore.updateUserName(newName)
    }
}
