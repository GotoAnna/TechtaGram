//
//  ViewController.swift
//  TechtaGram
//
//  Created by Mac on 2021/02/04.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var cameraImageView: UIImageView!
    
    var originalImage: UIImage! //画像加工するための元となる画像
    var filter: CIFilter! //画像加工するフィルターの宣言
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //撮影するボタンを押した時のメソッド
    @IBAction func takePhoto()
    {
        //カメラが使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            //カメラを起動
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
        else{
            //カメラが使えない時はエラーがコンソールに出る
            print("error")
        }
    }
    
    //カメラ、カメラロールを使った時に選択した画像をアプリ内に表示するためのメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        cameraImageView.image = info[.editedImage] as? UIImage
        originalImage = cameraImageView.image //カメラで撮った後にその画像を加工する前の元画像
        dismiss(animated: true, completion: nil)
    }
    
    //フィルター加工をする
    @IBAction func colorFilter()
    {
        let filterImage: CIImage = CIImage(image: originalImage)!
        
        //フィルターの設定
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        
        //彩度の調整
        filter.setValue(1.0, forKey: "inputSaturation")
        //明度の調整
        filter.setValue(0.5, forKey: "inputBrightness")
        //コントラストの調整
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        
        cameraImageView.image = UIImage(cgImage: cgImage!)
    }
    
    //保存
    @IBAction func savePhoto()
    {
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
    }

    //カメラロールにある画像を読み込む時のメソッド
    @IBAction func openAlbum()
    {
        //カメラロールを使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            //カメラロールお画像を選択して画像を表示するまでの一連の流れ
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    //SNSに編集した画像を投稿したい時のメソッド
    @IBAction func snsPhoto()
    {
        let shareText = "写真加工" //投稿するコメント
        
        let shareImage = cameraImageView.image! //投稿する画像の選択
        
        let activityItems: [Any] = [shareText, shareImage] //投稿するコメントと画像の準備
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let excludeActivityTypes = [UIActivity.ActivityType.postToWeibo, .saveToCameraRoll, .print]
        
        activityViewController.excludedActivityTypes = excludeActivityTypes
        
        present(activityViewController, animated: true, completion: nil)
        
    }
}

