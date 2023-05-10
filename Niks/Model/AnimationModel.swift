//
//  AnimationModel.swift
//  Niks
//
//  Created by Adriel Bernard Rusli on 03/05/23.
//

import Foundation

//struct AnimationModel: Hashable, Equatable {
//    let animation: String
//    let length: Int
//    let animationImageNames: [String]
//    
//    init(animation: String, length: Int) {
//        self.animation = animation
//        self.length = length
//        self.animationImageNames = (0...length).map({"\(animation)-\($0)"})
//    }
//}
class AnimationViewModel: ObservableObject {
    @Published var index: Int = 0
    
    //    @Published var data: [AnimationModel] = [
    //        AnimationModel(animation: "UjayiBreath", length: 32),
    //        AnimationModel(animation: "StandingHalfForwardBend", length: 15),
    //        AnimationModel(animation: "StandingForwardBend", length: 21),
    //        AnimationModel(animation: "WideKneeChildRose", length: 2),
    //        AnimationModel(animation: "RecliningBoundAngle", length: 2),
    //        AnimationModel(animation: "LegsUpTheWall", length: 2),
    //        AnimationModel(animation: "LegsOnChair", length: 2),
    //        AnimationModel(animation: "CorpsePose", length: 18)
    //    ]
    func changeIndex(with: Int) -> () {
        index = with
    }
    func incrementIndex() -> () {
        index += 1
    }
}
