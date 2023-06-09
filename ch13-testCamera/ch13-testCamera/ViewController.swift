//
//  ViewController.swift
//  ch13-testCamera
//
//  Created by hansung on 2023/06/08.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    var captureSession: AVCaptureSession?
    var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(takePicture1))
        imageView1.addGestureRecognizer(tap1)
        imageView1.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(takePicture2))
        imageView2.addGestureRecognizer(tap2)
    }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
    @objc func takePicture2(sender: UITapGestureRecognizer){
        if let captureSession = captureSession{
            if captureSession.isRunning{
                captureSession.stopRunning()
            }else{
                captureSession.startRunning()
            }
            return
        }
        captureSession = AVCaptureSession()
        captureSession!.beginConfiguration()
        captureSession!.sessionPreset = .medium
        guard let videoInput = createVideoInput() else{ return }
        captureSession!.addInput(videoInput)
        guard let videoOutput = createVideoOutput() else{ return }
        captureSession!.addOutput(videoOutput)
        
        attachPreviewer(captureSession: captureSession!)
        captureSession!.commitConfiguration()
        captureSession!.startRunning()
    }
    
    func createVideoInput() -> AVCaptureDeviceInput? {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back){
            return try? AVCaptureDeviceInput(device: device)
        }
        return nil
    }
    
    func createVideoOutput() -> AVCaptureVideoDataOutput? {
        let videoOutput = AVCaptureVideoDataOutput()
        let settings: [String: Any] = [kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA)]
        
        videoOutput.videoSettings = settings
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global())
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
        return videoOutput
    }
    
    func attachPreviewer(captureSession: AVCaptureSession){
        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        avCaptureVideoPreviewLayer.frame = imageView2.layer.bounds
        avCaptureVideoPreviewLayer.videoGravity = .resize
        imageView2.layer.addSublayer(avCaptureVideoPreviewLayer)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){
        
        // 여기서 이미지가 담겨져 온 sampleBuffer에 대한 처리를 하면 된다.
        count += 1
        print("count=\(count)")
        
    }
}

extension ViewController{
    @objc func takePicture1(sender: UITapGestureRecognizer){

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

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    // 사진을 찍은 경우 호출되는 함수
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // 여기서 이미지에 대한 추가적인 작업을 한다
        imageView1.image = image
        picker.dismiss(animated: true, completion: nil)
    }

    // 사진 캡쳐를 취소하는 경우 호출 함수
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // imagePickerController을 죽인다
        picker.dismiss(animated: true, completion: nil)
    }
}
