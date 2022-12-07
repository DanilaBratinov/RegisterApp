import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth

class RegViewController: UIViewController {
    
    @IBOutlet var loginButtonOutlet: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var mailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var ageTF: UITextField!
    
    let person = Person.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.isHidden = true
        ageTF.isHidden = true
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "profile", sender: nil)
            } else {
            }
        }

        loginButtonOutlet.layer.cornerRadius = 20
        ApiMeneger.shared.getUsers { users in
            users.forEach { user in
                self.person.names.append(user.name ?? "nil")
                self.person.citys.append(user.address?.city ?? "nil")
                self.person.username.append(user.username ?? "nil")
                self.person.email.append(user.email ?? "nil")
                self.person.street.append(user.address?.street ?? "nil")
            }
        }
    }
    
    @IBAction func helpButton(_ sender: UIButton) {
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let password = passwordTF.text!
        let mail = mailTF.text!
        if !password.isEmpty && !mail.isEmpty {
            Auth.auth().signIn(withEmail: mail, password: password) { (result, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "profile", sender: nil)
                } else {
                    self.showAlert(with: "Ошибка", and: "Введен неверный логин или пароль")
                }
            }
        } else {
            showAlert(with: "Ошибка", and: "Заполните все поля")
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        if nameTF.isHidden == true {
            nameTF.isHidden = false
            ageTF.isHidden = false
        } else {
            let password = passwordTF.text!
            let name = nameTF.text!
            let mail = mailTF.text!
            let age = ageTF.text!
            if !password.isEmpty && !name.isEmpty && !mail.isEmpty {
                Auth.auth().createUser(withEmail: mail, password: password) { (result, error) in
                    if error == nil {
                        print(result?.user.uid ?? "nil")
                        let ref = Database.database().reference().child("users")
                        ref.child(result?.user.uid ?? "nil").updateChildValues(["name" : name, "mail " : mail, "password" : password, "age": age])
                    } else {
                        self.showAlert(with: "Ошибка", and: "Введите действующий e-mail!")
                    }
                }
            } else {
                showAlert(with: "Ошибка", and: "Заполните все поля")
            }
        }
    }
}
//MARK: - UIAlertController
extension RegViewController {
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension RegViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
