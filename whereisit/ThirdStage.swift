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

class ThirdStage: AnyGameStage {
    
    static let dogSize = CGFloat(200)
    static let ballSize = CGFloat(200)
    static let frameSize = CGFloat(300)
    

    @Published var dogPosition: CGPoint = .zero
    @Published var originalDogPosition: CGPoint = .zero
    @Published var ballPosition: CGPoint = .zero
    @Published var originalBallPosition: CGPoint = .zero
    @Published var framePosition: CGPoint = .zero
    
    @Published var level: Int = 0
    @Published var winning: Bool = false
    
    @Published var audioPlayer: AVAudioPlayer?

    override init(name: String) {
        super.init(name: name)
        self.nextStage = nil
        updateFramePosition()
        generateRandomDogPosition()
        generateRandomBallPosition()
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
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        let randomDogX = CGFloat.random(in: (screenWidth * 0.3)...(screenWidth - ThirdStage.dogSize))
        let randomDogY = CGFloat.random(in: 0...(screenHeight - ThirdStage.dogSize))

        dogPosition = CGPoint(x: randomDogX, y: randomDogY)
        originalDogPosition = CGPoint(x: randomDogX, y: randomDogY)
    }
    
    func generateRandomBallPosition() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        var randomBallX = CGFloat.random(in: (screenWidth * 0.3)...(screenWidth - ThirdStage.ballSize))
        var randomBallY = CGFloat.random(in: 0...(screenHeight - ThirdStage.ballSize))

        while CGRect(x: randomBallX, y: randomBallY, width: ThirdStage.ballSize, height: ThirdStage.ballSize).intersects(CGRect(origin: dogPosition, size: CGSize(width: ThirdStage.dogSize, height: ThirdStage.dogSize))) {
            randomBallX = CGFloat.random(in: (screenWidth * 0.3)...(screenWidth - ThirdStage.ballSize))
            randomBallY = CGFloat.random(in: 0...(screenHeight - ThirdStage.ballSize))
        }

        ballPosition = CGPoint(x: randomBallX, y: randomBallY)
        originalBallPosition = CGPoint(x: randomBallX, y: randomBallY)
    }
    
    func setWinning() {
        winning = true
    }
    
    func isWinning() -> Bool {
        return winning
    }
    
    override func checkWinningCondition(movedObjectFinalPosition: CGPoint) -> Bool {
        let dogSize: CGFloat = ThirdStage.dogSize
        let frameSize: CGFloat = ThirdStage.frameSize
        let frameTopLeft = framePosition
        
        let dogCenter = CGPoint(x: movedObjectFinalPosition.x + dogSize/2, y: movedObjectFinalPosition.y + dogSize/2)
        let frame = CGRect(origin: frameTopLeft, size: CGSize(width: frameSize, height: frameSize))
        
        return frame.contains(dogCenter)
    }
    
    override func resetGameState() {
        dogPosition = CGPoint(x: originalDogPosition.x, y: originalDogPosition.y)
        ballPosition = CGPoint(x: originalBallPosition.x, y: originalBallPosition.y)
        playSounds()
    }
    
    func nextLevel() {
        level += 1
        generateRandomDogPosition()
        generateRandomBallPosition()
        winning = false
        let _ = print("Success number \(level)")
        if (level >= 3) {
            let _ = print("Stage \(self.name) was called accomplished=true")
            setAccomplished(accomplished: true)
        }
        else {
            playSounds()
        }
    }
    
    func playSounds() {
        if let soundURL1 = Bundle.main.url(forResource: "WoIst", withExtension: "m4a"),
           let soundURL2 = Bundle.main.url(forResource: "DerHund", withExtension: "m4a") {
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
        AnyView(ThirdStageView(gameState: self as ThirdStage))
    }
}
