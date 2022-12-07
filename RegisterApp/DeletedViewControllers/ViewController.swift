import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                self.performSegue(withIdentifier: "next", sender: nil)
            } else {
            }
        }
    }
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "next", sender: nil)
    }
}

