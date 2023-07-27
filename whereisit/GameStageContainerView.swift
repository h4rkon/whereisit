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

class GameStageContainer: ObservableObject {
    @Published var currentStage: AnyGameStage
    @Published var currentStageAccomplished: Bool
    
    init() {
        let secondStage = SecondStage(name: "Second", nextState: nil)
        let firstStage = FirstStage(name: "First", nextState: secondStage)
        secondStage.nextState = firstStage
        currentStage = firstStage
        currentStageAccomplished = false
    }
    
    func updateStages() {
        currentStage.gameStageContainer = self
        currentStage.nextState!.gameStageContainer = self
    }
    
    func moveToNextStage() {
        if let nextStage = currentStage.nextStage(), nextStage.isAccomplished() {
            currentStage = nextStage
            currentStageAccomplished = false
        }
    }
}

struct GameStageContainerView: View {
    
    @EnvironmentObject var gameStageContainer: GameStageContainer

        var body: some View {
            Group {
                let _ = print("Stage \(gameStageContainer.currentStage.name) used for getView()")
                gameStageContainer.currentStage.getView()
            }
            .onChange(of: gameStageContainer.currentStageAccomplished) { accomplished in
                let _ = print("onChange triggered. Accomplished: \(accomplished)")
                
                if accomplished {
                    gameStageContainer.moveToNextStage()
                }
            }
        }
}
