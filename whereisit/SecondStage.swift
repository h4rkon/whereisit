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

class SecondStage: AnyGameStage {
    
    static let ballSize = CGFloat(200)
    static let frameSize = CGFloat(300)
    

    @Published var ballPosition: CGPoint = .zero // The position of the dog image
    @Published var originalBallPosition: CGPoint = .zero // The position of the ball image
    @Published var framePosition: CGPoint = .zero // The position of the picture frame image
    @Published var level: Int = 0
    @Published var winning: Bool = false
    
    @Published var audioPlayer: AVAudioPlayer?

    override init(name: String) {
        super.init(name: name)
        self.nextStage = nil
        updateFramePosition()
        generateRandomBallPosition()
    }

    func updateFramePosition() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        let frameX = screenWidth * 0.15 // 25% of the screen width (left side)
        let frameY = screenHeight * 0.5 // 50% of the screen height (middle)

        framePosition = CGPoint(x: frameX, y: frameY)
    }
    
    func generateRandomBallPosition() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        var randomBallX = CGFloat.random(in: (screenWidth * 0.3)...(screenWidth - SecondStage.ballSize))
        var randomBallY = CGFloat.random(in: 0...(screenHeight - SecondStage.ballSize))

        while CGRect(x: randomBallX, y: randomBallY, width: SecondStage.ballSize, height: SecondStage.ballSize).intersects(CGRect(origin: framePosition, size: CGSize(width: SecondStage.frameSize, height: SecondStage.frameSize))) {
            randomBallX = CGFloat.random(in: 0...(screenWidth - SecondStage.ballSize))
            randomBallY = CGFloat.random(in: 0...(screenHeight - SecondStage.ballSize))
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
        let ballSize: CGFloat = FirstStage.dogSize
        let frameSize: CGFloat = FirstStage.frameSize
        let frameTopLeft = framePosition
        
        let ballCenter = CGPoint(x: movedObjectFinalPosition.x + ballSize/2, y: movedObjectFinalPosition.y + ballSize/2)
        let frame = CGRect(origin: frameTopLeft, size: CGSize(width: frameSize, height: frameSize))
        
        return frame.contains(ballCenter)
    }
    
    override func resetGameState() {
        ballPosition = CGPoint(x: originalBallPosition.x, y: originalBallPosition.y)
        playSounds()
    }
    
    func nextLevel() {
        level += 1
        generateRandomBallPosition()
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
        if let soundURL1 = Bundle.main.url(forResource: "WoIst", withExtension: "m4a"),
           let soundURL2 = Bundle.main.url(forResource: "DerBall", withExtension: "m4a") {
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
        AnyView(SecondStageView(gameState: self as SecondStage))
    }
}
