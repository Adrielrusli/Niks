//
//  EffectStyle.swift
//  Niks
//
//  Created by Deka Primatio on 02/05/23.
//

import SwiftUI

//MARK: - EXTENSION SPOTLIGHT TUTORIAL WITH VIEWBUILDER
extension View {
    @ViewBuilder
    
    //MARK: - by using Anchor Preference for Retreiving View's Bounds Region
    func addSpotlight(_ id: Int, shape: SpotlightShape = .rectangle, roundedRadius: CGFloat = 0, text: String = "") -> some View {
        self
            .anchorPreference(key: BoundsKey.self, value: .bounds) {[id: BoundsKeyProperties(shape: shape, anchor: $0, text: text, radius: roundedRadius)]}
    }
    
    //MARK: - Modifier to Display Spotlight that Overlay the Content (Add to Root View)
//    @ViewBuilder
//    func addSpotlightOverlay(show: Binding<Bool>, currentSpot: Binding<Int>) -> some View {
//        self
//            .overlayPreferenceValue(BoundsKey.self) { value in
//                GeometryReader { proxy in
//                    if let preference = values.first(where: { item in
//                        item.key == currentSpot.wrappedValue
//                    }) {
//                        let screenSize = proxy.size
//                        let anchor = proxy[preference.value.anchor]
//
//                        //MARK: - Spotlight View
//                        SpotlightHelperView(screenSize: screenSize, rect: anchor)
//                    }
//                }
//                .ignoresSafeArea()
//                .animation(.easeInOut, value: show.wrappedValue)
//                .animation(.easeInOut, value: currentSpot.wrappedValue)
//            }
//    }
    //MARK: - Helper View
    @ViewBuilder
    func SpotlightHelperView(screenSize: CGSize, rect: CGRect) -> some View {
        Rectangle()
            .fill(.ultraThinMaterial)
    }
}

//MARK: - SPOTLIGHT SHAPE
enum SpotlightShape {
    case circle
    case rectangle
    case rounded
}

//MARK: - BOUND PREFERENCE KEY
struct BoundsKey: PreferenceKey {
    static var defaultValue: [Int: BoundsKeyProperties] = [:]
    
    static func reduce(value: inout [Int : BoundsKeyProperties], nextValue: () -> [Int : BoundsKeyProperties]) {
        value.merge(nextValue()){$1}
    }
}

//MARK: - BOUND PREFERENCE KEY PROPERTIES
struct BoundsKeyProperties {
    var shape: SpotlightShape
    var anchor: Anchor<CGRect>
    var text: String = ""
    var radius: CGFloat = 0
}

//MARK: - PULSING ANIMATION CONTENT MODIFIER
struct PulsingAnimationModifier: ViewModifier {
    @State private var isPulsing = false
    
    let repeatForever: Bool
    let autoreverses: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 0.8 : 1.0)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.0 ).repeatForever(autoreverses: autoreverses)) {
                    isPulsing.toggle()
                }
            }
    }
}

//MARK: - EXTENSION FOR PULSING ANIMATION
extension View {
    func pulsingAnimation(repeatForever: Bool = true, autoreverses: Bool = true) -> some View {
        return self.modifier(PulsingAnimationModifier(repeatForever: repeatForever, autoreverses: autoreverses))
    }
}

//MARK: - EXTENSION FOR SHIMMER WITH @VIEWBUILDER
extension View {
    @ViewBuilder
    
    func shimmer(_ config: ShimmerConfig) -> some View {
        self
            .modifier(ShimmerEffect(config: config))
    }
}

//MARK: - SHIMMER EFFECT CONTENT MODIFIER
fileprivate struct ShimmerEffect: ViewModifier {
    var config: ShimmerConfig //Shimmer Config (Data Type)
    @State private var moveTo: CGFloat = -0.7 //Move to Property
    
    func body(content: Content) -> some View {
        content
            .overlay {
                Rectangle()
                    .fill(config.tint)
                    .mask{
                        content
                    }
                    .overlay {
                        // Shimmer
                        GeometryReader {
                            let size = $0.size
                            
                            Rectangle()
                                .fill(config.highlight)
                                .mask {
                                    Rectangle()
                                    //Gradient Glowing
                                        .fill(
                                            .linearGradient(colors: [.white.opacity(0), config.highlight.opacity(config.highlightOpacity)], startPoint: .top, endPoint: .bottom)
                                        )
                                    //Adding Blur Modifier
                                        .blur(radius: config.blur)
                                    //Rotating Degree
                                        .rotationEffect(.init(degrees: -70))
                                    //Moving from Start
                                        .offset(x: size.width * moveTo)
                                }
                        }
                        //Mask with the Content
                        .mask {
                            content
                        }
                    }
                    //Dispatch Queue with DispatchQueue to Avoid Animation Glitch
                    .onAppear{
                        DispatchQueue.main.async {
                            moveTo = 0.7
                        }
                    }
                    .animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
            }
    }
}

//Shimmer Animation Data Type
struct ShimmerConfig {
    var tint: Color
    var highlight: Color
    var blur: CGFloat = 0
    var highlightOpacity: CGFloat = 1
    var speed: CGFloat = 2
}

//MARK: - BACKGROUND EXAMPLE PREVIEW
struct EffectStyle_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundExampleView()
            .previewInterfaceOrientation(.landscapeLeft)
            .previewLayout(.sizeThatFits)
    }
}
