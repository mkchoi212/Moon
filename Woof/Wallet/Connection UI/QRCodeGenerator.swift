//
//  QRCodeGenerator.swift
//  Woof
//
//  Created by Mike Choi on 2/20/22.
//

import UIKit
import Foundation
import CoreGraphics

final class QRCodeGenerator {
    
    let queue = DispatchQueue(label: "com.woof.qr.code.generation")
    var qrData: Data? = nil

    var qrImage: UIImage? {
        if let qrData = qrData {
            return UIImage(data: qrData)
        } else {
            return nil
        }
    }
    
    var currentWalletAddress: String = "" {
        didSet {
            queue.async {
                self.qrData = self.getQRCodeDate(text: self.currentWalletAddress)
            }
        }
    }
    
    init() {
    }
    
    func getQRCodeDate(text: String) -> Data? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        
        let data = text.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciimage = filter.outputImage else {
            return nil
        }
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        return uiimage.pngData()!
    }
}
