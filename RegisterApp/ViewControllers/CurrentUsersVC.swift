import UIKit

class CurrentUsersVC: UIViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nikName: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var adress: UILabel!
    
    var name: String!
    var nikNameStr: String!
    var emailStr: String!
    var adressStr: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "Имя: \(name ?? "nil")"
        nikName.text = "Никнейм: \(nikNameStr ?? "nil")"
        email.text = "Почта: \(emailStr ?? "nil")"
        adress.text = "Адресс: \(adressStr ?? "nil")"
    }

}
