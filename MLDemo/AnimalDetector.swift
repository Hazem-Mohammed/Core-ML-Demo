//
//  AnimalDetector.swift
//  MLDemo
//
//  Created by Hazem Mohammed on 6/10/20.
//  Copyright © 2020 Hazem Mohammed. All rights reserved.
//

import UIKit
import Vision

class AnimalDetector {
    
    //Recive image view and return handler with all classification result
    
    static func startAnimalDetection(_ imageView: UIImageView, completion: @escaping (_ classification:[String]) -> Void) {
        
        let imageOrientation = CGImagePropertyOrientation(imageView.image!.imageOrientation)
        
        let visionRequestHandler = VNImageRequestHandler(cgImage: imageView.image!.cgImage!, orientation: imageOrientation, options: [:])
        
        // create Core ML Model
        
        guard let catDogModel = try? VNCoreMLModel(for: CatDogClassifier().model) else { print("ERROR"); return }
        
        // create deticion request
        
        
        let animalDetectionRequest = VNCoreMLRequest(model: catDogModel) { (request , error) in
            
            guard let observation = request.results else { print("NO RESULT"); return }
            
            let classification = observation
                .compactMap( { $0 as? VNClassificationObservation } )
                .filter( { $0.confidence > 0.9} )
                .map( { $0.identifier } )
            
            completion(classification)
        }
        
        do {
            try visionRequestHandler.perform([animalDetectionRequest])
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

extension CGImagePropertyOrientation {
    
    init(_ orientation: UIImage.Orientation) {
        
        switch orientation {
            
        case .up:
            self = .up
        case .down:
            self = .down
        case .left:
            self = .left
        case .right:
            self = .right
        case .upMirrored:
            self = .upMirrored
        case .downMirrored:
            self = .downMirrored
        case .leftMirrored:
            self = .leftMirrored
        case .rightMirrored:
            self = .rightMirrored
        }
    }
}
