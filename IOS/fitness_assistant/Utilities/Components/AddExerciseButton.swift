//
//  AddExerciseButton.swift
//  fitness_assistant
//
//  Created by andrewfalse on 27.11.2025.
//

import SwiftUI

struct AddExerciseButton: View {
    let action: () -> Void
    
    init(action: @escaping () -> Void = {}) {
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .medium))
                
                Text("Add Exercise")
                    .font(.system(size: 16, weight: .medium))
                
                Spacer()
            }
            .foregroundColor(.gray)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
}

#Preview {
    AddExerciseButton()
        .padding()
        .background(Color.customBackground)
        .preferredColorScheme(.dark)
}
