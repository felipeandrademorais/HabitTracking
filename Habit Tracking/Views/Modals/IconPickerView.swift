import SwiftUI
import MCEmojiPicker

struct IconPickerView: View {
    @Binding var selectedIcon: String
    @Binding var isPresented: Bool
    
    var body: some View {
        EmojiPickerWrapper(selectedIcon: $selectedIcon, isPresented: $isPresented)
            .navigationTitle("Escolha um Emoji")
    }
}

struct EmojiPickerWrapper: UIViewControllerRepresentable {
    @Binding var selectedIcon: String
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> MCEmojiPickerViewController {
        let viewController = MCEmojiPickerViewController()
        viewController.delegate = context.coordinator
        viewController.modalPresentationStyle = .pageSheet
        viewController.isModalInPresentation = false
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: MCEmojiPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MCEmojiPickerDelegate {
        var parent: EmojiPickerWrapper
        
        init(_ parent: EmojiPickerWrapper) {
            self.parent = parent
        }
        
        func didGetEmoji(emoji: String) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.parent.selectedIcon = emoji
                if let viewController = self.parent.findViewController() {
                    viewController.dismiss(animated: true) {
                        self.parent.isPresented = false
                    }
                }
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
        }
    }
}

struct IconPickerView_Previews: PreviewProvider {
    static var previews: some View {
        IconPickerPreviewWrapper()
    }
}

struct IconPickerPreviewWrapper: View {
    @State private var selectedIcon: String = "⭐️"
    @State private var isPresented: Bool = true
    
    var body: some View {
        IconPickerView(selectedIcon: $selectedIcon, isPresented: $isPresented)
            .frame(height: 400)
            .previewLayout(.sizeThatFits)
    }
}

extension EmojiPickerWrapper {
    func findViewController() -> UIViewController? {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let rootViewController = window.rootViewController {
            var currentController = rootViewController
            while let presentedController = currentController.presentedViewController {
                currentController = presentedController
            }
            return currentController
        }
        return nil
    }
}
