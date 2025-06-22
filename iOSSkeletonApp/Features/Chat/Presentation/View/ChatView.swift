//
//  ChatView.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 22/6/25.
//  

import SwiftUI
import Moya

struct ChatView: View {
    
    @StateObject var viewModel = ChatViewModel()
    
    var body: some View {
        Text("Hello, ChatView!")
    }
}

// MARK: - Preview
/// Mock ViewModel for Preview
class MockChatViewModel: ChatViewModel {
  override init() {
      super.init()
      // Init stub here
  }
}

#Preview {
    let mockViewModel = MockChatViewModel()
    return ChatView(viewModel: mockViewModel)
}
