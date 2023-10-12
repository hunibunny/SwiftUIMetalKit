//
//  ShaderCompiler.swift
//  
//
//  Created by Pirita Minkkinen on 10/8/23.
//

import Foundation
import Metal

// Manages the compilation of shader source code into usable shaders.
class ShaderCompiler {
    //static let shared = ShaderCompiler(device: DeviceManager.shared.device)

    
    let device: MTLDevice = DeviceManager.shared.device!  //i should really remove the optionality lol
    let library: MTLLibrary
    
    init(library: MTLLibrary) {
        self.library = library
        
    }
    
    func compileShaderAsync(_ source: String, key: String, completion: @escaping (MTLFunction?) -> ()) {
            DispatchQueue.global().async {
                guard let shaderFunction = self.library.makeFunction(name: key) else {
                    completion(nil)
                    return
                }
                completion(shaderFunction)
            }
        }
}


