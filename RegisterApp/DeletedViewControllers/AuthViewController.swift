import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth

class AuthViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var mailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var uid: String?
    
    var signUP = true {
        willSet {
            if newValue {
                titleLabel.text = "Регистрация"
                nameTextField.isHidden = false
            } else {
                titleLabel.text = " Вход"
                nameTextField.isHidden = true
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        mailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func switchLoginButton(_ sender: UIButton) {
        signUP = !signUP
    }
    
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let password = passwordTextField.text!
        let name = nameTextField.text!
        let mail = mailTextField.text!
        if (signUP) {
            if (!name.isEmpty && !mail.isEmpty && !password.isEmpty) {
                Auth.auth().createUser(withEmail: mail, password: password) { (result, error) in
                    if error == nil {
                        print(result?.user.uid ?? "nil")
                        let ref = Database.database().reference().child("users")
                        ref.child(result?.user.uid ?? "nil").updateChildValues(["name" : name, "mail" : mail])
                        self.performSegue(withIdentifier: "account", sender: nil)
                    }
                }
            } else {
                showAlert(with: "Ошибка!", and: "Заполните все поля!")
            }
        } else {
            if(!mail.isEmpty && !password.isEmpty) {
                Auth.auth().signIn(withEmail: mail, password: password) { [self] (result, error) in
                    if error == nil {
                        self.performSegue(withIdentifier: "account", sender: nil)
                        self.dismiss(animated: true)
                    } else {
                        showAlert(with: "Неверный логин или пароль", and: "Проверьте корректность введеных вами данных!")
                        print("Bad")
                    }
                }
            } else {
                showAlert(with: "Ошибка!", and: "Заполните все поля!")
            }
        }
        return true
    }
}
