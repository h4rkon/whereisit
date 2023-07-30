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


struct ImageListView: View {

    @State private var images: [ImageModel] = [
        ImageModel(imageName: "clear"),
        ImageModel(imageName: "dog"),
        ImageModel(imageName: "ball"),
        ImageModel(imageName: "nase"),
        ImageModel(imageName: "auto"),
        ImageModel(imageName: "fuesse"),
        ImageModel(imageName: "katze"),
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

    var body: some View {
        
        ZStack {
            GeometryReader { reader in
                
                Rectangle()
                    .foregroundColor(Color.gray)
                    .overlay(
                        Image("frame")
                            .resizable()
                    )
                    .frame(width: 300, height: 300)
                    .position(x: reader.size.width / 8, y: reader.size.height / 2)
                
                
                Rectangle()
                    .foregroundColor(selectedImage00 != nil ? .clear : .gray)
                    .overlay(selectedImage00 != nil ? Image(selectedImage00!.imageName).resizable() : nil)
                    .frame(width: 200, height: 200)
                    .position(x: reader.size.width * 3 / 8, y: reader.size.height / 4)
                    .foregroundColor(Color.gray)
                    .onTapGesture {
                        isImagePickerPresented00 = true
                    }
                    .sheet(isPresented: $isImagePickerPresented00) {
                        ImagePicker(images: $images, selectedImage: $selectedImage00, isPresented: $isImagePickerPresented00)
                    }
                
                Rectangle()
                    .foregroundColor(selectedImage01 != nil ? .clear : .gray)
                    .overlay(selectedImage01 != nil ? Image(selectedImage01!.imageName).resizable() : nil)
                    .frame(width: 200, height: 200)
                    .position(x: reader.size.width * 5 / 8, y: reader.size.height / 4)
                    .foregroundColor(Color.gray)
                    .onTapGesture {
                        isImagePickerPresented01 = true
                    }
                    .sheet(isPresented: $isImagePickerPresented01) {
                        ImagePicker(images: $images, selectedImage: $selectedImage01, isPresented: $isImagePickerPresented01)
                    }
                
                Rectangle()
                    .foregroundColor(selectedImage02 != nil ? .clear : .gray)
                    .overlay(selectedImage02 != nil ? Image(selectedImage02!.imageName).resizable() : nil)
                    .frame(width: 200, height: 200)
                    .position(x: reader.size.width * 7 / 8, y: reader.size.height / 4)
                    .foregroundColor(Color.gray)
                    .onTapGesture {
                        isImagePickerPresented02 = true
                    }
                    .sheet(isPresented: $isImagePickerPresented02) {
                        ImagePicker(images: $images, selectedImage: $selectedImage02, isPresented: $isImagePickerPresented02)
                    }
            
                Rectangle()
                    .foregroundColor(selectedImage10 != nil ? .clear : .gray)
                    .overlay(selectedImage10 != nil ? Image(selectedImage10!.imageName).resizable() : nil)
                    .frame(width: 200, height: 200)
                    .position(x: reader.size.width * 3 / 8, y: reader.size.height * 3 / 4)
                    .foregroundColor(Color.gray)
                    .onTapGesture {
                        isImagePickerPresented10 = true
                    }
                    .sheet(isPresented: $isImagePickerPresented10) {
                        ImagePicker(images: $images, selectedImage: $selectedImage10, isPresented: $isImagePickerPresented10)
                    }
                
                Rectangle()
                    .foregroundColor(selectedImage11 != nil ? .clear : .gray)
                    .overlay(selectedImage11 != nil ? Image(selectedImage11!.imageName).resizable() : nil)
                    .frame(width: 200, height: 200)
                    .position(x: reader.size.width * 5 / 8, y: reader.size.height * 3 / 4)
                    .foregroundColor(Color.gray)
                    .onTapGesture {
                        isImagePickerPresented11 = true
                    }
                    .sheet(isPresented: $isImagePickerPresented11) {
                        ImagePicker(images: $images, selectedImage: $selectedImage11, isPresented: $isImagePickerPresented11)
                    }
                
                Rectangle()
                    .foregroundColor(selectedImage12 != nil ? .clear : .gray)
                    .overlay(selectedImage12 != nil ? Image(selectedImage12!.imageName).resizable() : nil)
                    .frame(width: 200, height: 200)
                    .position(x: reader.size.width * 7 / 8, y: reader.size.height * 3 / 4)
                    .foregroundColor(Color.gray)
                    .onTapGesture {
                        isImagePickerPresented12 = true
                    }
                    .sheet(isPresented: $isImagePickerPresented12) {
                        ImagePicker(images: $images, selectedImage: $selectedImage12, isPresented: $isImagePickerPresented12)
                    }
                    
            }
            
        }
    }
}

struct ImagePicker: View {
    @Binding var images: [ImageModel]
    @Binding var selectedImage: ImageModel?
    @Binding var isPresented: Bool // Add this Binding

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


