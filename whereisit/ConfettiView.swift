//
//  ConfettiView.swift
//  whereisit
//
//  Created by Sauermann, Victor on 23.07.23.
//

import SwiftUI
import AVFoundation

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}


struct ConfettiView: View {
    @State private var confettiPieces: [ConfettiPiece] = []
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        ZStack {
            ForEach(confettiPieces) { piece in
                Circle()
                    .fill(piece.color)
                    .frame(width: 10, height: 10)
                    .offset(x: piece.x, y: piece.y)
            }
        }
        .onAppear {
            generateConfetti()
            animateConfetti()
        }
    }
    
    private func generateConfetti() {
        let screenHeight = UIScreen.main.bounds.height
        
        for _ in 0..<1000 {
            let piece = ConfettiPiece(
                x: 0,
                y: -CGFloat.random(in: 0...(screenHeight / 2)),
                color: Color.random,
                gravity: CGFloat.random(in: 50...300)
            )
            confettiPieces.append(piece)
        }
    }
    
    private func animateConfetti() {
        
        if let soundURL = Bundle.main.url(forResource: "Super", withExtension: "m4a") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                let _ = print("Error playing sound: \(error.localizedDescription)")
            }
        }
        
        withAnimation(Animation.easeInOut(duration: 4)) {
            for index in 0..<confettiPieces.count {
                var piece = confettiPieces[index]
                piece.x = CGFloat.random(in: -1000...1000)
                piece.y = 0 // Start at the bottom of the screen
                confettiPieces[index] = piece
            }
        }
        
        // Simulate gravity for each piece
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            withAnimation(.linear(duration: 4)) {
                for index in 0..<self.confettiPieces.count {
                    var piece = self.confettiPieces[index]
                    piece.y += piece.gravity // Update the y position based on gravity
                    self.confettiPieces[index] = piece
                }
            }
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var color: Color
    var gravity: CGFloat
}


