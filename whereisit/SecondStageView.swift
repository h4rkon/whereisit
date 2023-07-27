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

struct SecondStageView: View {
    @ObservedObject var gameState: SecondStage
    
    @State private var ballImage = UIImage(named: "ball")
    @State private var frameImage = UIImage(named: "frame")
    @State private var showConfetti: Bool = false

    var body: some View {
        ZStack {
            Color.clear.onAppear {
                gameState.playSounds()
            }
            
            if let ballImage = ballImage,
               let frameImage = frameImage {
                
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 2, height: geometry.size.height)
                        .position(x: (0.30 * geometry.size.width), y: (geometry.size.height / 2))
                }
                
                Image(uiImage: frameImage)
                    .resizable()
                    .frame(width: FirstStage.frameSize, height: FirstStage.frameSize)
                    .position(gameState.framePosition)
                
                Image(uiImage: ballImage)
                    .resizable()
                    .frame(width: FirstStage.dogSize, height: FirstStage.dogSize)
                    .position(gameState.ballPosition)
                
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
                    gameState.ballPosition = value.location
                }
                .onEnded { value in
                    if (gameState.checkWinningCondition(movedObjectFinalPosition: value.location) == false) {
                        gameState.resetGameState()
                        let _ = print("Try harder")
                    }
                    else {
                        let _ = print("You won!")
                        gameState.setWinning()
                    }
                }
        )
    }
}
