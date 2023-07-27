//
// Copyright 2023 Victor Sauermann, Andrea Schindler-Sauermann
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameState: GameState
    @State private var dogImage = UIImage(named: "dog")
    @State private var frameImage = UIImage(named: "frame")
    @State private var showConfetti: Bool = false

    var body: some View {
        ZStack {
            Color.clear.onAppear {
                gameState.playSounds()
            }
            
            if let dogImage = dogImage,
               let frameImage = frameImage {
                
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 2, height: geometry.size.height)
                        .position(x: (0.30 * geometry.size.width), y: (geometry.size.height / 2))
                }
                
                Image(uiImage: frameImage)
                    .resizable()
                    .frame(width: GameState.frameSize, height: GameState.frameSize)
                    .position(gameState.framePosition)
                
                Image(uiImage: dogImage)
                    .resizable()
                    .frame(width: GameState.dogSize, height: GameState.dogSize)
                    .position(gameState.dogPosition)
                
                if (gameState.isWinning()) {
                    ConfettiView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                gameState.nextLevel()
                                showConfetti = false
                            }
                        }
                        .onDisappear {
                            showConfetti = true // Show confetti again when winning
                        }
                }
            }
        }
        .gesture(
            DragGesture(coordinateSpace: .global)
                .onChanged { value in
                    // Update the positions of the images during the drag gesture
                    gameState.dogPosition = value.location
                }
                .onEnded { value in
                    if (checkForWinningCondition(finalDogPosition: value.location) == false) {
                        gameState.resetLevel()
                        let _ = print("Try harder")
                    }
                    else {
                        let _ = print("You won!")
                        gameState.setWinning()
                    }
                }
        )
    }
    
    func checkForWinningCondition(finalDogPosition: CGPoint) -> Bool {
        let dogSize: CGFloat = GameState.dogSize
        let frameSize: CGFloat = GameState.frameSize
        let frameTopLeft = gameState.framePosition
        
        let dogCenter = CGPoint(x: finalDogPosition.x + dogSize/2, y: finalDogPosition.y + dogSize/2)
        let frame = CGRect(origin: frameTopLeft, size: CGSize(width: frameSize, height: frameSize))
        
        return frame.contains(dogCenter)
    }
}
