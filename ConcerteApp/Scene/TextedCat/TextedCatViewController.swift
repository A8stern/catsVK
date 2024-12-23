//
//  TextedCatViewController.swift
//  ConcerteApp
//
//  Created by Kovalev Gleb on 03.11.2024.
//

import UIKit

class TextedCatViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = "Generate your cat"
        activityIndicator.layer.opacity = 0
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(gestureRecognizer)
                
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)
            
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    @objc private func didTapView() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func downloadCat() {
        guard let text = textField.text, !text.isEmpty else {
            return
        }
            
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            
        guard let url = URL(string: "https://cataas.com/cat/says/\(encodedText)") else {
            return
        }
            
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { [weak self] in
                    self?.descriptionLabel.text = "Text cat failed downloading"
                    self?.activityIndicator.layer.opacity = 0
                    self?.button.isEnabled.toggle()
                    self?.textField.text = ""
                    self?.textField.isEnabled.toggle()
                }
                return
            }
                
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = UIImage(data: data)
                self?.descriptionLabel.text = "Text cat was downloaded"
                self?.activityIndicator.layer.opacity = 0
                self?.button.isEnabled.toggle()
                self?.textField.text = ""
                self?.textField.isEnabled.toggle()
            }
        }
            
        task.resume()
    }
    
    private func downloadRandomCat() {
        guard let url = URL(string: "https://cataas.com/cat") else {
            return
        }
            
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { [weak self] in
                    self?.descriptionLabel.text = "Random cat failed downloading"
                    self?.activityIndicator.layer.opacity = 0
                    self?.button.isEnabled.toggle()
                    self?.textField.text = ""
                    self?.textField.isEnabled.toggle()
                }
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = UIImage(data: data)
                self?.descriptionLabel.text = "Random cat was downloaded"
                self?.activityIndicator.layer.opacity = 0
                self?.button.isEnabled.toggle()
                self?.textField.text = ""
                self?.textField.isEnabled.toggle()
            }
        }
        
        task.resume()
    }
    
    
    @IBAction func didTapButton(_ sender: Any) {
        descriptionLabel.text = " "
        activityIndicator.layer.opacity = 1
        button.isEnabled.toggle()
        textField.isEnabled.toggle()
        descriptionLabel.text = "Start downloading cat"
        if (textField.text == "") {
            downloadRandomCat()
        } else {
            downloadCat()
        }
    }
}


