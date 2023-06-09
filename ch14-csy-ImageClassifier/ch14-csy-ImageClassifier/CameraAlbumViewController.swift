//
//  ViewController.swift
//  ch14-csy-ImageClassifier
//
//  Created by hansung on 2023/06/09.
//

import UIKit
import AVKit
import Vision
import CoreML

class CameraAlbumViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var vnCoreMLRequest: VNCoreMLRequest!
    var captureSession: AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        vnCoreMLRequest = createCoreML(modelName: "SqueezeNet", modelExt: "mlmodelc", completionHandler: handleImageClassifier)

        captureSession = AVCaptureSession()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(startStop))
        view.addGestureRecognizer(tapGestureRecognizer)

    }
    @objc func startStop(sender: UITapGestureRecognizer){
        guard let captureSession = captureSession else{ return}
        if captureSession.isRunning{
            captureSession.stopRunning()
        }else{
            captureSession.startRunning()
        }
    }
}

extension CameraAlbumViewController{

    @IBAction func takePicture(_ sender: UIButton) {

        // 컨트로러를 생성한다
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self // 이 딜리게이터를 설정하면 사진을 찍은후 호출된다

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //imagePickerController.sourceType = .camera
            imagePickerController.sourceType = .photoLibrary
        }else{
            imagePickerController.sourceType = .photoLibrary
        }

        // UIImagePickerController이 활성화 된다, 11장을 보라
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension CameraAlbumViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    // 사진을 찍은 경우 호출되는 함수
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
 
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // 여기서 이미지에 대한 추가적인 작업을 한다
            imageView.image = image
            
            let handler = VNImageRequestHandler(ciImage: CIImage(image: image)!)
            try! handler.perform([vnCoreMLRequest])
        }
        picker.dismiss(animated: true, completion: nil)
    }

    // 사진 캡쳐를 취소하는 경우 호출 함수
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // imagePickerController을 죽인다
        picker.dismiss(animated: true, completion: nil)
    }
}

// 이미지 분류
extension CameraAlbumViewController{
    
    func createCoreML(modelName: String, modelExt: String, completionHandler: @escaping (VNRequest, Error?) -> Void) -> VNCoreMLRequest?{
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: modelExt) else {
            return nil
        }
        guard let vnCoreMLModel = try? VNCoreMLModel(for: MLModel(contentsOf: modelURL)) else{
            return nil
        }
        return VNCoreMLRequest(model: vnCoreMLModel, completionHandler: completionHandler)
    }
}

extension CameraAlbumViewController{
    func handleImageClassifier(request: VNRequest, error: Error?){
        guard let results = request.results as? [VNClassificationObservation] else{ return }
        if let topResult = results.first{
            DispatchQueue.main.async {
                self.messageLabel.text = "\(topResult.identifier)입니다."
            }
        }
    }
}

//extension CameraAlbumViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//
//        // 여기서 이미지가 담겨져 온 sampleBuffer에 대한 처리를 하면된다.
//        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//            return
//        }
//        let ciImage = CIImage(cvImageBuffer: imageBuffer)
//        let handler = VNImageRequestHandler(ciImage: ciImage)
//        try! handler.perform([vnCoreMLRequest])
//
//    }
//}
