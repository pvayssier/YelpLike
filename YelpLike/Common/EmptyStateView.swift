//
//  EmptyStateView.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import SwiftUI

struct EmptyStateView: View {
    var imageSystemName: String
    var text: String

    func makeHostingController() -> UIHostingController<EmptyStateView> {
        let hostingView = UIHostingController(rootView: self)
        return hostingView
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            HStack {
                Spacer()
                Image(systemName: imageSystemName)
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)
                    .shadow(color: .accentColor, radius: 20)
                Spacer()
            }

                Text(text)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)

            Spacer()
        }
        .background(Color(.systemGroupedBackground))
    }
}

