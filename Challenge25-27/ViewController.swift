import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var textView: UITextView!
    @IBOutlet var imageView: UIImageView!
    var topText = ""
    var botText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme Generator"
        textView.isUserInteractionEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraTapped))
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        let ac1 = UIAlertController(title: "Enter text for the top part of the meme:", message: nil, preferredStyle: .alert)
        ac1.addTextField()
        ac1.addAction(UIAlertAction(title: "Done", style: .default) { [weak self, weak ac1] _ in
            if let textField = ac1?.textFields?[0].text {
                self?.topText = textField
                let ac2 = UIAlertController(title: "Enter text for the bottom part of the meme:", message: nil, preferredStyle: .alert)
                ac2.addTextField()
                ac2.addAction(UIAlertAction(title: "Done", style: .default) { [weak self, weak ac2] _ in
                    if let textField = ac2?.textFields?[0].text {
                        self?.botText = textField
                        let renderer = UIGraphicsImageRenderer(size: CGSize(width: image.size.width, height: image.size.height))
                        let renderedImage = renderer.image { ctx in
                            image.draw(at: CGPoint(x: 0, y: 0))
                            
                            let paragraphStyle = NSMutableParagraphStyle()
                            paragraphStyle.alignment = .center
                            let attrs: [NSAttributedString.Key: Any] = [
                                .font: UIFont(name: "Impact", size: 100) as Any,
                                .foregroundColor: UIColor.white,
                                .paragraphStyle: paragraphStyle
                            ]
                            let topAttributedString = NSAttributedString(string: self?.topText ?? "", attributes: attrs)
                            let botAttributedString = NSAttributedString(string: self?.botText ?? "", attributes: attrs)
                            
                            var yCoordinate: CGFloat = image.size.height - 140
                            
                            if botAttributedString.size().width > 2 * image.size.width {
                                yCoordinate = image.size.height - 360
                            } else if botAttributedString.size().width > image.size.width {
                                yCoordinate = image.size.height - 240
                            } else {
                                yCoordinate = image.size.height - 140
                            }
                            
                            topAttributedString.draw(with: CGRect(x: 20, y: 20, width: image.size.width - 30, height: image.size.height / 2), options: .usesLineFragmentOrigin, context: nil)
                            
                            botAttributedString.draw(with: CGRect(x: 20, y: yCoordinate, width: image.size.width - 30, height: image.size.height / 2), options: .usesLineFragmentOrigin, context: nil)
                        }
                        self?.textView.isHidden = true
                        self?.imageView.image = renderedImage
                    }
                })
                self?.present(ac2, animated: true)
            }
        })
        present(ac1, animated: true)
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image else { return }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        present(vc, animated: true)
    }
    
    @objc func cameraTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
}

