import SwiftUI
import UIKit
import Vision

struct ContentView: View {
    @State private var uiimage : UIImage?
    @State private var Uiimagetext: String = ""
    var body: some View {
        VStack {
            if let uiimage = uiimage{
                Image(uiImage: uiimage)
                    .resizable()
                    .scaledToFit()
            }
            else{
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
            }
            
            Text(Uiimagetext.isEmpty ? "Tap the to covert to text" : Uiimagetext)
            Button ("image to text"){
                self.uiimage = UIImage(named: "screenshot")
                if self.uiimage != nil{
                    processImage(uiimage: self.uiimage!)
                }
            }
        }
        .padding()
    }
    func processImage(uiimage: UIImage) -> Void {
        guard let cgImage = uiimage.cgImage else{
            print("unable convert to cgi Image")
            return
        }
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { request, error in
            guard let results = request.results as? [VNRecognizedTextObservation],
                  error == nil
            else{
                print("conversion Is invalid")
                return
            }
            let output = results.compactMap { observations in
                observations.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            DispatchQueue.main.async {
                self.Uiimagetext = output
            }
        }
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try imageRequestHandler.perform([request])
                } catch {
                    print("Failed to perform image request: \(error)")
                    
                }
                
                
            }
        }
    }

#Preview {
    ContentView()
}
