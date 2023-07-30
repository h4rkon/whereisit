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

struct ImageModel: Identifiable {
    let id = UUID()
    let imageName: String
}

struct CustomRectangle : View{
    var column: Int
    var row: Int
    var position: CGPoint
    var size: CGSize
    
    init(column: Int, row: Int) {
        self.column = column
        self.row = row
        self.position = CustomRectangle.definePosition(column: column, row: row)
        self.size = CGSize(width: 200, height: 200)
    }
    
    static func definePosition(column: Int, row: Int) -> CGPoint {
        let columnOffset = column * 2 + 3
        let x = Int(Int(UIScreen.main.bounds.width) * columnOffset / 8)
        let rowOffset = row * 2 + 1
        let y = Int(Int(UIScreen.main.bounds.height) * rowOffset / 4)
        return CGPoint(x: x, y: y)
    }
    
    var body: some View {
        Rectangle()
            .frame(width: size.width, height: size.height)
            .position(position)
    }
}

struct ImageListView : View {
    
    let columns = [0, 1, 2]
    let rows = [0, 1]
    
    let framePosition: CGPoint
    let frameSize: CGSize
    let frameRect: CGRect
    
    init() {
        framePosition = CGPoint(x: UIScreen.main.bounds.width / 8, y: UIScreen.main.bounds.height / 2)
        frameSize = CGSize(width: 300, height: 300)
        frameRect = CGRect(x: framePosition.x - 150, y: framePosition.y - 150, width: 300, height: 300)
    }
    
    var body: some View {
        ZStack {
            
        
            Rectangle()
                .foregroundColor(Color.gray)
                .overlay(
                    Image("frame")
                        .resizable()
                )
                .frame(width: 300, height: 300)
                .position(framePosition)
                
            ForEach(rows, id: \.self) { row in
                ForEach(columns, id: \.self) { column in
                    CustomRectangle(column: column, row: row)
                }
            }
        }
    }
}

struct ImageListView2: View {
    
    
    @State private var textInput: String = ""

    @State private var images: [ImageModel] = [
        ImageModel(imageName: "clear"),
        ImageModel(imageName: "dog"),
        ImageModel(imageName: "ball"),
        ImageModel(imageName: "nose"),
        ImageModel(imageName: "car"),
        ImageModel(imageName: "feet"),
        ImageModel(imageName: "cat"),
    ]
    
    @State private var isImagePickerPresented00 = false
    @State private var isImagePickerPresented01 = false
    @State private var isImagePickerPresented02 = false
    @State private var isImagePickerPresented10 = false
    @State private var isImagePickerPresented11 = false
    @State private var isImagePickerPresented12 = false
    
    @State private var selectedImage00: ImageModel?
    @State private var selectedImage01: ImageModel?
    @State private var selectedImage02: ImageModel?
    @State private var selectedImage10: ImageModel?
    @State private var selectedImage11: ImageModel?
    @State private var selectedImage12: ImageModel?
    
    @State var targetObject: Int = 0
    
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
            
            HStack(alignment: .center) {
        
                ZStack {
                    GeometryReader { reader in
                        
                        TextField("Level Name", text: $textInput)
                            .frame(width: 300)
                            .position(x: reader.size.width/2)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Rectangle()
                            .foregroundColor(Color.gray)
                            .overlay(
                                Image("frame")
                                    .resizable()
                            )
                            .frame(width: 300, height: 300)
                            .position(framePosition)
                        
                        
                        Rectangle()
                            .foregroundColor(selectedImage00 != nil ? .clear : .gray)
                            .overlay(selectedImage00 != nil ? Image(selectedImage00!.imageName).resizable() : nil)
                            .overlay(targetObject == 1 ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(x: reader.size.width * 3 / 8, y: reader.size.height / 4)
                            .onTapGesture {
                                isImagePickerPresented00 = true
                            }
                            .sheet(isPresented: $isImagePickerPresented00) {
                                ImagePicker(images: $images, selectedImage: $selectedImage00, isPresented: $isImagePickerPresented00)
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
                                        }
                                        else if (targetObject > 0) {
                                            targetObject = 0
                                        }
                                    }
                                }
                            )
                        
                        Rectangle()
                            .foregroundColor(selectedImage01 != nil ? .clear : .gray)
                            .overlay(selectedImage01 != nil ? Image(selectedImage01!.imageName).resizable() : nil)
                            .overlay(targetObject == 2 ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(x: reader.size.width * 5 / 8, y: reader.size.height / 4)
                            .onTapGesture {
                                isImagePickerPresented01 = true
                            }
                            .sheet(isPresented: $isImagePickerPresented01) {
                                ImagePicker(images: $images, selectedImage: $selectedImage01, isPresented: $isImagePickerPresented01)
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
                                        }
                                        else if (targetObject > 0) {
                                            targetObject = 0
                                        }
                                    }
                                }
                            )
                        
                        Rectangle()
                            .foregroundColor(selectedImage02 != nil ? .clear : .gray)
                            .overlay(selectedImage02 != nil ? Image(selectedImage02!.imageName).resizable() : nil)
                            .overlay(targetObject == 3 ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(x: reader.size.width * 7 / 8, y: reader.size.height / 4)
                            .onTapGesture {
                                isImagePickerPresented02 = true
                            }
                            .sheet(isPresented: $isImagePickerPresented02) {
                                ImagePicker(images: $images, selectedImage: $selectedImage02, isPresented: $isImagePickerPresented02)
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
                                        }
                                        else if (targetObject > 0) {
                                            targetObject = 0
                                        }
                                    }
                                }
                            )
                        
                        Rectangle()
                            .foregroundColor(selectedImage10 != nil ? .clear : .gray)
                            .overlay(selectedImage10 != nil ? Image(selectedImage10!.imageName).resizable() : nil)
                            .overlay(targetObject == 4 ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(x: reader.size.width * 3 / 8, y: reader.size.height * 3 / 4)
                            .onTapGesture {
                                isImagePickerPresented10 = true
                            }
                            .sheet(isPresented: $isImagePickerPresented10) {
                                ImagePicker(images: $images, selectedImage: $selectedImage10, isPresented: $isImagePickerPresented10)
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
                                        }
                                        else if (targetObject > 0) {
                                            targetObject = 0
                                        }
                                    }
                                }
                            )
                        
                        Rectangle()
                            .foregroundColor(selectedImage11 != nil ? .clear : .gray)
                            .overlay(selectedImage11 != nil ? Image(selectedImage11!.imageName).resizable() : nil)
                            .overlay(targetObject == 5 ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(x: reader.size.width * 5 / 8, y: reader.size.height * 3 / 4)
                            .onTapGesture {
                                isImagePickerPresented11 = true
                            }
                            .sheet(isPresented: $isImagePickerPresented11) {
                                ImagePicker(images: $images, selectedImage: $selectedImage11, isPresented: $isImagePickerPresented11)
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
                                        }
                                    }
                                    else if (targetObject > 0) {
                                        targetObject = 0
                                    }
                                }
                            )
                        
                        Rectangle()
                            .foregroundColor(selectedImage12 != nil ? .clear : .gray)
                            .overlay(selectedImage12 != nil ? Image(selectedImage12!.imageName).resizable() : nil)
                            .overlay(targetObject == 6 ? Rectangle().stroke(Color.red, lineWidth: 2): nil)
                            .frame(width: 200, height: 200)
                            .position(x: reader.size.width * 7 / 8, y: reader.size.height * 3 / 4)
                            .onTapGesture {
                                isImagePickerPresented12 = true
                            }
                            .sheet(isPresented: $isImagePickerPresented12) {
                                ImagePicker(images: $images, selectedImage: $selectedImage12, isPresented: $isImagePickerPresented12)
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
                                        }
                                    }
                                    else if (targetObject > 0) {
                                        targetObject = 0
                                    }
                                }
                            )
                        }
                    VStack {
                        Spacer() // Push the "Speichern" button to the bottom
                        Button("Speichern") {
                            let _ = print("Speichern")
                        }
                        .frame(width: 300)
                    }
                }
            }
        }
    }
}

struct ImagePicker: View {
    @Binding var images: [ImageModel]
    @Binding var selectedImage: ImageModel?
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


