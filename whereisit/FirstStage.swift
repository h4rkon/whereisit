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

import Foundation
import SwiftUI
import AVFoundation

class FirstStage: AnyGameStage {
    
    static let dogSize = CGFloat(200)
    static let frameSize = CGFloat(300)
    

    @Published var dogPosition: CGPoint = .zero // The position of the dog image
    @Published var originalDogPosition: CGPoint = .zero // The position of the dog image
    @Published var framePosition: CGPoint = .zero // The position of the picture frame image
    @Published var level: Int = 0
    @Published var winning: Bool = false
    
    @Published var audioPlayer: AVAudioPlayer?

    override init(name: String) {
        super.init(name: name)
        self.nextStage = nil
        updateFramePosition()
        generateRandomDogPosition()
    }

    func updateFramePosition() {
        // Get the screen width and height
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        // Calculate the x and y position for the frame to be in the middle on the left side
        let frameX = screenWidth * 0.15 // 25% of the screen width (left side)
        let frameY = screenHeight * 0.5 // 50% of the screen height (middle)

        framePosition = CGPoint(x: frameX, y: frameY)
    }
    
    func generateRandomDogPosition() {
        // Get the screen width and height
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        // Randomly generate x and y positions for the dog within the screen boundaries
        var randomDogX = CGFloat.random(in: (screenWidth * 0.3)...(screenWidth - FirstStage.dogSize))
        var randomDogY = CGFloat.random(in: 0...(screenHeight - FirstStage.dogSize))

        // Check if the randomly generated position overlaps with the frame
        while CGRect(x: randomDogX, y: randomDogY, width: FirstStage.dogSize, height: FirstStage.dogSize).intersects(CGRect(origin: framePosition, size: CGSize(width: FirstStage.frameSize, height: FirstStage.frameSize))) {
            // If it overlaps, generate new random positions until a valid position is found
            randomDogX = CGFloat.random(in: 0...(screenWidth - FirstStage.dogSize))
            randomDogY = CGFloat.random(in: 0...(screenHeight - FirstStage.dogSize))
        }

        // Set the dog position to the valid random position
        dogPosition = CGPoint(x: randomDogX, y: randomDogY)
        originalDogPosition = CGPoint(x: randomDogX, y: randomDogY)
    }
    
    func setWinning() {
        winning = true
    }
    
    func isWinning() -> Bool {
        return winning
    }
    
    override func checkWinningCondition(movedObjectFinalPosition: CGPoint) -> Bool {
        let dogSize: CGFloat = FirstStage.dogSize
        let frameSize: CGFloat = FirstStage.frameSize
        let frameTopLeft = framePosition
        
        let dogCenter = CGPoint(x: movedObjectFinalPosition.x + dogSize/2, y: movedObjectFinalPosition.y + dogSize/2)
        let frame = CGRect(origin: frameTopLeft, size: CGSize(width: frameSize, height: frameSize))
        
        return frame.contains(dogCenter)
    }
    
    override func resetGameState() {
        dogPosition = CGPoint(x: originalDogPosition.x, y: originalDogPosition.y)
        playSounds()
    }
    
    func nextLevel() {
        level += 1
        generateRandomDogPosition()
        winning = false
        if (level >= 3) {
            let _ = print("Stage \(self.name) was called accomplished=true")
            setAccomplished(accomplished: true)
        }
        else {
            playSounds()
        }
    }
    
    func playSounds() {
        if let soundURL1 = Bundle.main.url(forResource: "whereis", withExtension: "m4a"),
           let soundURL2 = Bundle.main.url(forResource: "dog", withExtension: "m4a") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL1)
                audioPlayer?.play()

                DispatchQueue.main.asyncAfter(deadline: .now() + audioPlayer!.duration) {
                    do {
                        self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL2)
                        self.audioPlayer?.play()
                    } catch {
                        let _ = print("Error playing sound: \(error.localizedDescription)")
                    }
                }
            } catch {
                let _ = print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }
    
    override func getNextStage() -> (AnyGameStage)? {
        if (isAccomplished()) {
            level = 1
            return nextStage
        }
        return nil
    }
    
    override func getView() -> AnyView {
        AnyView(FirstStageView(gameState: self as FirstStage))
    }
}
