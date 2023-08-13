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

class ImageModelOld: Identifiable {
    let id = UUID()
    let imageName: String
    let introSound: String
    let objectSound: String
    
    init(imageName: String, introSound: String, objectSound: String) {
        self.imageName = imageName
        self.introSound = introSound
        self.objectSound = objectSound
    }
    
    @Published var position: CGPoint = .zero
    
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
}

struct ImageListViewOld: View {

    @State private var images: [ImageModelOld] = [
        ImageModelOld(imageName: "clear", introSound: "", objectSound: ""),
        ImageModelOld(imageName: "dog", introSound: "whereis", objectSound: "dog"),
        ImageModelOld(imageName: "ball", introSound: "whereis", objectSound: "ball"),
        ImageModelOld(imageName: "nose", introSound: "whereis", objectSound: "nose"),
        ImageModelOld(imageName: "car", introSound: "whereis", objectSound: "car"),
        ImageModelOld(imageName: "feet", introSound: "whereis", objectSound: "feet"),
        ImageModelOld(imageName: "cat", introSound: "whereis", objectSound: "cat"),
    ]
    
    @State private var isImagePickerPresented00 = false
    @State private var isImagePickerPresented01 = false
    @State private var isImagePickerPresented02 = false
    @State private var isImagePickerPresented10 = false
    @State private var isImagePickerPresented11 = false
    @State private var isImagePickerPresented12 = false
    
    @State private var selectedImage00: ImageModelOld?
    @State private var selectedImage01: ImageModelOld?
    @State private var selectedImage02: ImageModelOld?
    @State private var selectedImage10: ImageModelOld?
    @State private var selectedImage11: ImageModelOld?
    @State private var selectedImage12: ImageModelOld?
    
    @State var targetObject: Int = 0
    
    @State private var tapCount: Int = 0
    
    @State var game: Bool = false
    
    let framePosition: CGPoint
    let frameSize: CGSize
    let frameRect: CGRect
    
    init() {
        framePosition = CGPoint(x: UIScreen.main.bounds.width / 8, y: UIScreen.main.bounds.height / 2)
        frameSize = CGSize(width: 300, height: 300)
        frameRect = CGRect(x: framePosition.x - 150, y: framePosition.y - 150, width: 300, height: 300)
    }

    var body: some View {
        
        VStack {
            
            //Image("play")
            //    .resizable()
            //    .frame(width: 133, height: 100)
            
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
                                tapCount += 1
                                let test = (tapCount - 1 ) % 4
                                if (test != 0) {
                                    game = true
                                } else {
                                    game = false
                                }
                            }
                        
                        
                        Rectangle()
                            .foregroundColor( (selectedImage00 != nil || game) ? .clear : .gray)
                            .overlay(selectedImage00 != nil ? Image(selectedImage00!.imageName).resizable() : nil)
                            .overlay(( targetObject == 1 && !game) ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(x: reader.size.width * 3 / 8, y: reader.size.height / 4)
                            .onTapGesture {
                                isImagePickerPresented00 = true
                            }
                            .sheet(isPresented: $isImagePickerPresented00) {
                                // ImagePicker(images: $images, selectedImage: $selectedImage00, isPresented: $isImagePickerPresented00)
                            }
                            .gesture(DragGesture(coordinateSpace: .global)
                                .onChanged{value in
                                    if (selectedImage00 != nil) {
                                        
                                    }
                                }
                                .onEnded { value in
                                    if (selectedImage00 != nil) {
                                        if (frameRect.contains(value.location)) {
                                            targetObject = 1
                                            selectedImage00?.playSounds()
                                        }
                                        else if (targetObject > 0) {
                                            targetObject = 0
                                        }
                                    }
                                }
                            )
                        
                        Rectangle()
                            .foregroundColor(( selectedImage01 != nil || game) ? .clear : .gray)
                            .overlay(selectedImage01 != nil ? Image(selectedImage01!.imageName).resizable() : nil)
                            .overlay(( targetObject == 2 && !game) ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(x: reader.size.width * 5 / 8, y: reader.size.height / 4)
                            .onTapGesture {
                                isImagePickerPresented01 = true
                            }
                            .sheet(isPresented: $isImagePickerPresented01) {
                                // ImagePicker(images: $images, selectedImage: $selectedImage01, isPresented: $isImagePickerPresented01)
                            }
                            .gesture(DragGesture(coordinateSpace: .global)
                                .onChanged{value in
                                    if (selectedImage01 != nil) {
                                    }
                                }
                                .onEnded { value in
                                    if (selectedImage01 != nil) {
                                        if (frameRect.contains(value.location)) {
                                            targetObject = 2
                                            selectedImage01?.playSounds()
                                        }
                                        else if (targetObject > 0) {
                                            targetObject = 0
                                        }
                                    }
                                }
                            )
                        
                        Rectangle()
                            .foregroundColor(( selectedImage02 != nil || game) ? .clear : .gray)
                            .overlay(selectedImage02 != nil ? Image(selectedImage02!.imageName).resizable() : nil)
                            .overlay(( targetObject == 3 && !game) ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(x: reader.size.width * 7 / 8, y: reader.size.height / 4)
                            .onTapGesture {
                                isImagePickerPresented02 = true
                            }
                            .sheet(isPresented: $isImagePickerPresented02) {
                                // ImagePicker(images: $images, selectedImage: $selectedImage02, isPresented: $isImagePickerPresented02)
                            }
                            .gesture(DragGesture(coordinateSpace: .global)
                                .onChanged{value in
                                    if (selectedImage02 != nil) {
                                    }
                                }
                                .onEnded { value in
                                    if (selectedImage02 != nil) {
                                        if (frameRect.contains(value.location)) {
                                            targetObject = 3
                                            selectedImage02?.playSounds()
                                        }
                                        else if (targetObject > 0) {
                                            targetObject = 0
                                        }
                                    }
                                }
                            )
                        
                        Rectangle()
                            .foregroundColor((selectedImage10 != nil || game) ? .clear : .gray)
                            .overlay(selectedImage10 != nil ? Image(selectedImage10!.imageName).resizable() : nil)
                            .overlay(( targetObject == 4 && !game) ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(x: reader.size.width * 3 / 8, y: reader.size.height * 3 / 4)
                            .onTapGesture {
                                isImagePickerPresented10 = true
                            }
                            .sheet(isPresented: $isImagePickerPresented10) {
                                // ImagePicker(images: $images, selectedImage: $selectedImage10, isPresented: $isImagePickerPresented10)
                            }
                            .gesture(DragGesture(coordinateSpace: .global)
                                .onChanged{value in
                                    if (selectedImage10 != nil) {
                                    }
                                }
                                .onEnded { value in
                                    if (selectedImage10 != nil) {
                                        if (frameRect.contains(value.location)) {
                                            targetObject = 4
                                            selectedImage10?.playSounds()
                                        }
                                        else if (targetObject > 0) {
                                            targetObject = 0
                                        }
                                    }
                                }
                            )
                        
                        Rectangle()
                            .foregroundColor((selectedImage11 != nil || game) ? .clear : .gray)
                            .overlay(selectedImage11 != nil ? Image(selectedImage11!.imageName).resizable() : nil)
                            .overlay(( targetObject == 5 && !game) ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(x: reader.size.width * 5 / 8, y: reader.size.height * 3 / 4)
                            .onTapGesture {
                                isImagePickerPresented11 = true
                            }
                            .sheet(isPresented: $isImagePickerPresented11) {
                                // ImagePicker(images: $images, selectedImage: $selectedImage11, isPresented: $isImagePickerPresented11)
                            }
                            .gesture(DragGesture(coordinateSpace: .global)
                                .onChanged{value in
                                    if (selectedImage11 != nil) {
                                    }
                                }
                                .onEnded { value in
                                    if (selectedImage11 != nil) {
                                        if (frameRect.contains(value.location)) {
                                            targetObject = 5
                                            selectedImage11?.playSounds()
                                        }
                                    }
                                    else if (targetObject > 0) {
                                        targetObject = 0
                                    }
                                }
                            )
                        
                        Rectangle()
                            .foregroundColor((selectedImage12 != nil || game) ? .clear : .gray)
                            .overlay(selectedImage12 != nil ? Image(selectedImage12!.imageName).resizable() : nil)
                            .overlay(( targetObject == 6 && !game) ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(x: reader.size.width * 7 / 8, y: reader.size.height * 3 / 4)
                            .onTapGesture {
                                isImagePickerPresented12 = true
                            }
                            .sheet(isPresented: $isImagePickerPresented12) {
                                // ImagePicker(images: $images, selectedImage: $selectedImage12, isPresented: $isImagePickerPresented12)
                            }
                            .gesture(DragGesture(coordinateSpace: .global)
                                .onChanged{value in
                                    if (selectedImage12 != nil) {
                                        
                                    }
                                }
                                .onEnded { value in
                                    if (selectedImage12 != nil) {
                                        if (frameRect.contains(value.location)) {
                                            targetObject = 6
                                            selectedImage12?.playSounds()
                                        }
                                    }
                                    else if (targetObject > 0) {
                                        targetObject = 0
                                    }
                                }
                            )
                        }
                }
            }
        }
    }
}

struct ImagePickerOld: View {
    @Binding var images: [ImageModelOld]
    @Binding var selectedImage: ImageModelOld?
    @Binding var isPresented: Bool

    var body: some View {
        List(images) { image in
            Image(image.imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .onTapGesture {
                    if (selectedImage != nil) {
                        images.append(selectedImage!)
                        selectedImage = nil
                    }
                    if (image.imageName == "clear") {
                    }
                    else {
                        if let index = images.firstIndex(where: { $0.id == image.id }) {
                                                images.remove(at: index)
                                            }
                        selectedImage = image
                    }
                    isPresented = false
                }
        }
    }
}


