import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase

class ProfileViewController: UIViewController {
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var ageLabel: UILabel!
    
    let ref = Storage.storage().reference().child("avatars")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getName()
        getRandom()
    }
    
    override func viewWillLayoutSubviews() {
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
    
    private func getImage(picName: String, completion: @escaping (UIImage) -> Void) {
        let storage = Storage.storage()
        let reference = storage.reference()
        let pathRef = reference.child("avatars")
        
        guard var image: UIImage = UIImage(named: "burning-rose-4k-1k.jpg") else { return }
        let fileRef = pathRef.child(picName)
        fileRef.getData(maxSize: 1024 * 1024) { data, error in
            guard error == nil else { completion(image); return }
            image = UIImage(data: data!)!
            completion(image)
        }
    }
    
    private func getRandom() {
        var list: [String] = []
        var image = ""
        ref.listAll { result, error in
            if error == nil {
                for item in result!.items {
                    let url = item.name
                    list.append(url)
                }
                image = list.randomElement()!
                self.getImage(picName: image) { image in
                    self.imageView.image = image
                }
            }
        }
    }
    
    private func getName() {
        let ref = Database.database().reference()
        let id = Auth.auth().currentUser?.uid
        ref.child("users/\(id ?? "nil")/name").getData { error, snapshot in
            if error == nil {
                let name = snapshot?.value as? String ?? "Unknown"
                self.userNameLabel.text = name
            }
        }
        ref.child("users/\(id ?? "nil")/age").getData { error, snapshot in
            if error == nil {
                let age = snapshot?.value as? String ?? "0"
                self.ageLabel.text = "Возраст: \(age)"
            }
        }
    }
    
    @IBAction func ext(_ sender: Any) {
        showAlert(with: "Предупреждение", and: "Вы уверены, что хотите выйти ?")
    }
    
    @IBAction func updateButton(_ sender: UIBarButtonItem) {
        getRandom()
        getName()
    }
    
}

extension ProfileViewController {
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Да", style: .default) { action in
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true)
            } catch _ {
            }
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .default)
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
}
