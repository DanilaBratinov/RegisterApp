import UIKit

class PostViewController: UIViewController {

    @IBOutlet var jokeLabel: UILabel!
    
    var usersArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiMeneger.shared.getUsers { users in
            users.forEach { user in
                self.usersArray.append(user.name ?? "nil")
            }
        }
    }
    
    @IBAction func jokeButton() {
        print(usersArray)
    }
}

//MARK: - TouchesBegan

extension PostViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
