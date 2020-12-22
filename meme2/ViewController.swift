//
//  ViewController.swift
//  meme1.0
//
//  Created by Nitesh sharma on 21/12/20.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate, UITextFieldDelegate{
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var cemaraButton: UIBarButtonItem!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var selectedTextField:UITextField!;
    struct Meme{
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
        
    }
    

        
    override func viewDidLoad() {
        super.viewDidLoad()
        cemaraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // Do any additional setup after loading the view.
        shareButton.isEnabled = false
        
        
        topText.delegate = self
        topText.defaultTextAttributes = self.getTextSettings()
        topText.textAlignment = .center
        topText.tag = 0
        
        
        bottomText.delegate = self
        bottomText.defaultTextAttributes = self.getTextSettings()
        bottomText.textAlignment = .center
        bottomText.tag = 1
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //**********Image Picking Logic starts
    @IBAction func pickImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            myImageView.contentMode = .scaleAspectFit
            
            print(image)
            myImageView.image = image
            shareButton.isEnabled = true

        }else{
            shareButton.isEnabled = false
            print("image is nil")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //**********Image Picking Logic ends
    
    //**********MEME Text handling
    func getTextSettings() -> [NSAttributedString.Key: Any]{
        return[NSAttributedString.Key.strokeColor: UIColor.black/* TODO: fill in appropriate UIColor */,
               NSAttributedString.Key.foregroundColor: UIColor.white/* TODO: fill in appropriate UIColor */,
               NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
               NSAttributedString.Key.strokeWidth: -1 /* TODO: fill in appropriate Float */
               ]
    }
    
    func isPlaceHolderText(textField: UITextField)  -> Bool{
        return textField.text == "TOP" || textField.text == "BOTTOM"
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField;
        if (isPlaceHolderText(textField: textField)){
            textField.text = "";
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        selectedTextField = nil
    }
    //**********MEME Text handling end
    
    //**********Keyboard handling logic
    
    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification:Notification) {
        //Tag 1 refers bottom text
        if (selectedTextField.tag == 1){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    @objc func keyboardWillHide(_ notification:Notification) {
        //Tag 1 refers bottom text
        if (selectedTextField.tag == 1){
            view.frame.origin.y = 0
        }
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //**********Keyboard handling logic ends
    //**********Generating ans saving MeMe image
    func generateMemedImage() -> UIImage {

        
        topBar.isHidden = true
        bottomBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        topBar.isHidden = false
        bottomBar.isHidden = false
        
        return memedImage
    }
    
//    func save(memedImage: UIImage) {
//            // Create the meme
//        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: myImageView.image!, memedImage: memedImage)
//    }
//
    
    @IBAction func share(_ sender: Any) {
   
        let image = generateMemedImage()

//        let image = UIImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(controller, animated: true, completion: {
            //self.save(memedImage: image)
        })
        
    }
}
    
    
    
    //**********Generating ans saving MeMe image ends
    


