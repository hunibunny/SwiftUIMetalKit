//
//  MetalViewRepresentables.swift
//
//A SwiftUI representable for integrating Metal-based rendering in SwiftUI views.
//
//  Created by Pirita Minkkinen on 8/22/23.
//

import SwiftUI


/// `MetalNSViewRepresentable` (macOS) or `MetalUIViewRepresentable` (iOS) are SwiftUI views that facilitate the rendering of Metal content.
/// They act as a bridge between `ShaderView` and `MetalRenderView`, handling the necessary setup and updates for Metal rendering.
///
/// - Note: These representables handle the basic displaying process but do not manage errors related to shader compilation,
///   Metal device initialization, or runtime issues. Users should handle these aspects separately.
#if os(macOS)
public struct MetalNSViewRepresentable<Input: ShaderInputProtocol>: NSViewRepresentable {
    public typealias NSViewType = MetalRenderView
    
    let drawableSize: CGSize
    let fragmentShaderName: String
    let vertexShaderName: String
    let shaderInput: Input
    

    /// Initializes a new `MetalNSViewRepresentable` instance for macOS.
        /// - Parameters:
        ///   - drawableSize: The size of the drawable area for Metal rendering.
        ///   - fragmentShaderName: The name of the fragment shader.
        ///   - vertexShaderName: The name of the vertex shader.
        ///   - shaderInput: The input data for the shader.
    public init(drawableSize: CGSize, fragmentShaderName: String, vertexShaderName: String, shaderInput: Input) {
        self.drawableSize = drawableSize
        self.fragmentShaderName = fragmentShaderName
        self.vertexShaderName = vertexShaderName
        self.shaderInput = shaderInput
        
    }
    
    /// Creates the `MetalRenderView` view for Metal rendering in a SwiftUI context.
    public func makeNSView(context: Context) -> NSViewType<Input> {
        let metalRenderView = MetalRenderView(fragmentShaderName: fragmentShaderName, vertexShaderName: vertexShaderName, shaderInput: shaderInput)
        metalRenderView.delegate = metalRenderView
        metalRenderView.drawableSize = drawableSize
        return metalRenderView
    }
    
    /// Updates the `MetalRenderView` view with the latest drawable size and triggers a redraw if needed.
    public func updateNSView(_ nsView: MetalRenderView<Input>, context: Context) {
        nsView.frame.size = drawableSize
        nsView.drawableSize = drawableSize
        nsView.needsDisplay = true
    }
    
}

#else
/// `MetalUIViewRepresentable` is the iOS equivalent of `MetalNSViewRepresentable`.
public struct MetalUIViewRepresentable<Input: ShaderInputProtocol>: UIViewRepresentable {
    let drawableSize: CGSize
    let fragmentShaderName: String
    let vertexShaderName: String
    public typealias UIViewType = MetalRenderView
    let shaderInput: Input
    
    /// Initializes a new `MetalUIViewRepresentable` instance for iOS.
       /// - Parameters:
       ///   - drawableSize: The size of the drawable area for Metal rendering.
       ///   - fragmentShaderName: The name of the fragment shader.
       ///   - vertexShaderName: The name of the vertex shader.
       ///   - shaderInput: The input data for the shader.
    public init(drawableSize: CGSize, fragmentShaderName: String,  vertexShaderName: String,  shaderInput: Input) {
        self.drawableSize = drawableSize
        self.fragmentShaderName = fragmentShaderName
        self.vertexShaderName = vertexShaderName
        self.shaderInput = shaderInput
    }
    
    /// Creates the `MetalRenderView` view for Metal rendering in a SwiftUI context.
    public func makeUIView(context: Context) -> UIViewType<Input> {
        let metalRenderView = MetalRenderView(fragmentShaderName: fragmentShaderName, vertexShaderName: vertexShaderName, shaderInput: shaderInput)
        metalRenderView.delegate = metalRenderView
        metalRenderView.drawableSize = drawableSize
        return metalRenderView
    }
    
    /// Updates the `MetalRenderView` view with the latest drawable size and triggers a redraw if needed.
    public func updateUIView(_ uiView: MetalRenderView<Input>, context: Context) {
        uiView.frame.size = drawableSize
        uiView.drawableSize = drawableSize
        uiView.setNeedsDisplay()
    }
    
}
#endif
