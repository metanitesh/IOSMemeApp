//
//  ViewController.swift
//  MeMe1.0
//
//  Created by Nitesh sharma on 15/12/20.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var myImageView: UIImageView!
    //    let imagePickerDelegate: ImagePickerDelegate = ImagePickerDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello world")
//        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func pickImage(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
//        print(info)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            myImageView.contentMode = .scaleAspectFit
            print(image)
            myImageView.image = image

        }else{
            print("image is nil")
        }
    }

}


//class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//
//    }
//}
