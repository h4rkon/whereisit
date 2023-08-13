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
import AVFoundation

class ImageModel: ObservableObject {
    var id: Int
    let imageName: String
    let introSound: String
    let objectSound: String
    
    @Published var position: CGPoint = .zero
    @Published var originalPosition: CGPoint = .zero
    
    init(id: Int, imageName: String, introSound: String, objectSound: String) {
        self.id = id
        self.imageName = imageName
        self.introSound = introSound
        self.objectSound = objectSound
        changePosition()
    }
    
    func clonePosition(position: CGPoint) -> CGPoint {
        return CGPoint(x: position.x, y: position.y)
    }
    
    var player1: AVAudioPlayer?
    var player2: AVAudioPlayer?
    
    func playSounds(){
        if let soundURL1 = Bundle.main.url(forResource: introSound, withExtension: "m4a"),
           let soundURL2 = Bundle.main.url(forResource: objectSound, withExtension: "m4a") {
            do {
                player1 = try AVAudioPlayer(contentsOf: soundURL1)
                player1!.prepareToPlay()
                
                player2 = try AVAudioPlayer(contentsOf: soundURL2)
                player2!.prepareToPlay()
                
                player1!.play()
                
                let duration = player1!.duration
                let playerForClosure = player2
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    playerForClosure!.play()
                }
                
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }
    
    func resetPosition() {
        position = CGPoint(x: originalPosition.x, y: originalPosition.y)
    }
    
    func changePosition() {
        self.position = clonePosition(position: ImageListView.positions[self.id - 1])
        originalPosition = clonePosition(position: self.position)
    }
}

struct ImageListView: View {

    @ObservedObject var image1 = ImageModel(id: 1, imageName: "dog", introSound: "whereis", objectSound: "dog")
    @ObservedObject var image2 = ImageModel(id: 2, imageName: "ball", introSound: "whereis", objectSound: "ball")
    @ObservedObject var image3 = ImageModel(id: 3, imageName: "nose", introSound: "whereis", objectSound: "nose")
    @ObservedObject var image4 = ImageModel(id: 4, imageName: "car", introSound: "whereis", objectSound: "car")
    @ObservedObject var image5 = ImageModel(id: 5, imageName: "feet", introSound: "whereis", objectSound: "feet")
    @ObservedObject var image6 = ImageModel(id: 6, imageName: "cat", introSound: "whereis", objectSound: "cat")
    
    public static var positions: [CGPoint] = [
        CGPoint(x: UIScreen.main.bounds.width * 3 / 8, y: UIScreen.main.bounds.height / 4),
        CGPoint(x: UIScreen.main.bounds.width * 5 / 8, y: UIScreen.main.bounds.height / 4),
        CGPoint(x: UIScreen.main.bounds.width * 7 / 8, y: UIScreen.main.bounds.height / 4),
        CGPoint(x: UIScreen.main.bounds.width * 3 / 8, y: UIScreen.main.bounds.height * 3 / 4),
        CGPoint(x: UIScreen.main.bounds.width * 5 / 8, y: UIScreen.main.bounds.height * 3 / 4),
        CGPoint(x: UIScreen.main.bounds.width * 7 / 8, y: UIScreen.main.bounds.height * 3 / 4)
    ]
    
    @State private var selectedImage1: Bool = true
    @State private var selectedImage2: Bool = true
    @State private var selectedImage3: Bool = true
    @State private var selectedImage4: Bool = true
    @State private var selectedImage5: Bool = true
    @State private var selectedImage6: Bool = true
    
    @State var targetObject: Int = 0
    @State var targetImage: ImageModel? = nil
    
    @State private var tapCount: Int = 1
    
    @State var game: Bool = false
    
    let framePosition: CGPoint
    let frameSize: CGSize
    let frameRect: CGRect
    
    @State private var winning: Bool = false
    @State private var showConfetti: Bool = false
    let runs = 5
    @State private var successfull: Int = 0
    
    init() {
        framePosition = CGPoint(x: UIScreen.main.bounds.width / 8, y: UIScreen.main.bounds.height / 2)
        frameSize = CGSize(width: 300, height: 300)
        frameRect = CGRect(x: framePosition.x - 150, y: framePosition.y - 150, width: 300, height: 300)
    }
    
    func checkWinningCondition(image: ImageModel) -> Bool {
        if ( frameRect.contains(image.position) && image.id == targetObject) {
            return true
        }
        return false
    }
    
    func nextLevel() {
        winning = false
        successfull += 1
        ImageListView.positions.shuffle()
        
        image1.changePosition()
        image2.changePosition()
        image3.changePosition()
        image4.changePosition()
        image5.changePosition()
        image6.changePosition()
        
        if( successfull == runs) {
            successfull = 0
            game = false
        }
    }

    var body: some View {
        
        VStack {
            
            Text("\(game ? "Spiel läuft - Anzahl \(successfull) von \(runs)" : "Konfiguration") ")
            
            HStack(alignment: .center) {
        
                ZStack {
                    GeometryReader { reader in
                        
                        Rectangle()
                            .foregroundColor(Color.gray)
                            .overlay(
                                Image("frame")
                                    .resizable()
                            )
                            .frame(width: 300, height: 300)
                            .position(framePosition)
                            .onTapGesture(count: 2) {
                                if (targetImage != nil) {
                                    game = true
                                }
                            }
                        
                        Rectangle()
                            .foregroundColor(!selectedImage1 ? (game ? .white : .gray) : nil)
                            .overlay(selectedImage1 ? Image(image1.imageName).resizable() : nil)
                            .overlay(targetObject == 1 && !game ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(image1.position)
                            .onTapGesture(count: 1) {
                                selectedImage1 = !selectedImage1
                                if (targetObject == 1) {
                                    targetObject = 0
                                    targetImage = nil
                                }
                            }
                            .gesture(DragGesture(coordinateSpace: .global)
                                .onChanged{value in
                                    if ( selectedImage1 ) {
                                        image1.position = value.location
                                    }
                                }
                                .onEnded { value in
                                    if (selectedImage1) {
                                        if (game) {
                                            if ( !checkWinningCondition(image: image1) ) {
                                                image1.resetPosition()
                                                targetImage!.playSounds()
                                            } else {
                                                winning = true
                                                //image1.resetPosition()
                                            }
                                        } else {
                                            image1.resetPosition()
                                            if (frameRect.contains(value.location)) {
                                                targetObject = 1
                                                targetImage = image1
                                                image1.playSounds()
                                            }
                                            else {
                                                targetObject = 0
                                                targetImage = nil
                                            }
                                        }
                                    }
                                }
                            )
                        
                        Rectangle()
                            .foregroundColor(!selectedImage2 ? (game ? .white : .gray) : nil)
                            .overlay(selectedImage2 ? Image(image2.imageName).resizable() : nil)
                            .overlay(targetObject == 2 && !game ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(image2.position)
                            .onTapGesture(count: 1) {
                                selectedImage2 = !selectedImage2
                                if (targetObject == 2) {
                                    targetObject = 0
                                    targetImage = nil
                                }
                            }
                            .gesture(DragGesture(coordinateSpace: .global)
                                .onChanged{value in
                                    if ( selectedImage2 ) {
                                        image2.position = value.location
                                    }
                                }
                                .onEnded { value in
                                    if (selectedImage2) {
                                        if (game) {
                                            if ( !checkWinningCondition(image: image2) ) {
                                                image2.resetPosition()
                                                targetImage!.playSounds()
                                            } else {
                                                winning = true
                                                image2.resetPosition()
                                            }
                                        } else {
                                            image2.resetPosition()
                                            if (frameRect.contains(value.location)) {
                                                targetObject = 2
                                                targetImage = image2
                                                image2.playSounds()
                                            }
                                            else {
                                                targetObject = 0
                                                targetImage = nil
                                            }
                                        }
                                    }
                                }
                            )
                        
                        Rectangle()
                            .foregroundColor(!selectedImage3 ? (game ? .white : .gray) : nil)
                            .overlay(selectedImage3 ? Image(image3.imageName).resizable() : nil)
                            .overlay(targetObject == 3 && !game ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(image3.position)
                            .onTapGesture(count: 1) {
                                selectedImage3 = !selectedImage3
                                if (targetObject == 3) {
                                    targetObject = 0
                                    targetImage = nil
                                }
                            }
                            .gesture(DragGesture(coordinateSpace: .global)
                                .onChanged{value in
                                    if ( selectedImage3 ) {
                                        image3.position = value.location
                                    }
                                }
                                .onEnded { value in
                                    if (selectedImage3) {
                                        if (game) {
                                            if ( !checkWinningCondition(image: image3) ) {
                                                image3.resetPosition()
                                                targetImage!.playSounds()
                                            } else {
                                                winning = true
                                                image3.resetPosition()
                                            }
                                        } else {
                                            image3.resetPosition()
                                            if (frameRect.contains(value.location)) {
                                                targetObject = 3
                                                targetImage = image3
                                                image3.playSounds()
                                            }
                                            else {
                                                targetObject = 0
                                                targetImage = nil
                                            }
                                        }
                                    }
                                }
                            )
                        
                        Rectangle()
                            .foregroundColor(!selectedImage4 ? (game ? .white : .gray) : nil)
                            .overlay(selectedImage4 ? Image(image4.imageName).resizable() : nil)
                            .overlay(targetObject == 4 && !game ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(image4.position)
                            .onTapGesture(count: 1) {
                                selectedImage4 = !selectedImage4
                                if (targetObject == 4) {
                                    targetObject = 0
                                    targetImage = nil
                                }
                            }
                            .gesture(DragGesture(coordinateSpace: .global)
                                .onChanged{value in
                                    if ( selectedImage4 ) {
                                        image4.position = value.location
                                    }
                                }
                                .onEnded { value in
                                    if (selectedImage4) {
                                        if (game) {
                                            if ( !checkWinningCondition(image: image4) ) {
                                                image4.resetPosition()
                                                targetImage!.playSounds()
                                            } else {
                                                winning = true
                                                image4.resetPosition()
                                            }
                                        } else {
                                            image4.resetPosition()
                                            if (frameRect.contains(value.location)) {
                                                targetObject = 4
                                                targetImage = image4
                                                image3.playSounds()
                                            }
                                            else {
                                                targetObject = 0
                                                targetImage = nil
                                            }
                                        }
                                    }
                                }
                            )
                        
                        Rectangle()
                            .foregroundColor(!selectedImage5 ? (game ? .white : .gray) : nil)
                            .overlay(selectedImage5 ? Image(image5.imageName).resizable() : nil)
                            .overlay(targetObject == 5 && !game ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(image5.position)
                            .onTapGesture(count: 1) {
                                selectedImage5 = !selectedImage5
                                if (targetObject == 5) {
                                    targetObject = 0
                                    targetImage = nil
                                }
                            }
                            .gesture(DragGesture(coordinateSpace: .global)
                                .onChanged{value in
                                    if ( selectedImage5 ) {
                                        image5.position = value.location
                                    }
                                }
                                .onEnded { value in
                                    if (selectedImage5) {
                                        if (game) {
                                            if ( !checkWinningCondition(image: image5) ) {
                                                image5.resetPosition()
                                                targetImage!.playSounds()
                                            } else {
                                                winning = true
                                                image5.resetPosition()
                                            }
                                        } else {
                                            image5.resetPosition()
                                            if (frameRect.contains(value.location)) {
                                                targetObject = 5
                                                targetImage = image5
                                                image5.playSounds()
                                            }
                                            else {
                                                targetObject = 0
                                                targetImage = nil
                                            }
                                        }
                                    }
                                }
                            )
                        
                        Rectangle()
                            .foregroundColor(!selectedImage6 ? (game ? .white : .gray) : nil)
                            .overlay(selectedImage6 ? Image(image6.imageName).resizable() : nil)
                            .overlay(targetObject == 6 && !game ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(image6.position)
                            .onTapGesture(count: 1) {
                                selectedImage6 = !selectedImage6
                                if (targetObject == 6) {
                                    targetObject = 0
                                    targetImage = nil
                                }
                            }
                            .gesture(DragGesture(coordinateSpace: .global)
                                .onChanged{value in
                                    if ( selectedImage6 ) {
                                        image6.position = value.location
                                    }
                                }
                                .onEnded { value in
                                    if (selectedImage6) {
                                        if (game) {
                                            if ( !checkWinningCondition(image: image6) ) {
                                                image6.resetPosition()
                                                targetImage!.playSounds()
                                            } else {
                                                winning = true
                                                image6.resetPosition()
                                            }
                                        } else {
                                            image6.resetPosition()
                                            if (frameRect.contains(value.location)) {
                                                targetObject = 6
                                                targetImage = image6
                                                image6.playSounds()
                                            }
                                            else {
                                                targetObject = 0
                                                targetImage = nil
                                            }
                                        }
                                    }
                                }
                            )
                        
                        if (winning) {
                            ConfettiView()
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        nextLevel()
                                        showConfetti = false
                                        targetImage!.resetPosition()
                                        targetImage!.playSounds()
                                    }
                                }
                                .onDisappear {
                                    showConfetti = true
                                }
                        }
                    }
                    .onChange(of: game, perform: { newValue in
                        if ( newValue ) {
                            targetImage!.playSounds()
                        }
                    })
                }
            }
        }
    }
}


