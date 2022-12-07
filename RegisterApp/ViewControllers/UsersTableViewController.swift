import UIKit
import FirebaseStorage
import Firebase
import FirebaseCore

class UsersTableViewController: UITableViewController {
    
    // MARK: - Table view data source
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        tableView.rowHeight = 80
        self.searchBar.delegate = self
        refreshImages()
        print(person.names)
    }
    
    let person = Person.shared
    let ref = Storage.storage().reference().child("avatars")
    var image = UIImage()
    var filteredNames = [String]()
    var imageArray = [UIImage]()
    var isSearching = false
    var index = 0
    
    private func refreshImages() {
        for _ in 0...person.names.count {
            getRandom()
        }
    }
    
    private func getImage(picName: String, completion: @escaping (UIImage) -> Void) {
        let storage = Storage.storage()
        let reference = storage.reference()
        let pathRef = reference.child("avatars")
        
        guard var image: UIImage = UIImage(named: "burning-rose-4k-1k.jpg") else { return }
        let fileRef = pathRef.child(picName)
        fileRef.getData(maxSize: 1024 * 1024) { data, error in
            guard error == nil else {
                completion(image); return }
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
                    self.imageArray.append(image)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredNames.count
        } else {
            return person.names.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Users", for: indexPath)
        let person = person
        var content = cell.defaultContentConfiguration()
        if isSearching {
            content.text = filteredNames[indexPath.row]
        } else {
            content.text = person.names[indexPath.row]
        }
        content.text = person.names[indexPath.row]
        content.secondaryText = "Город: \(person.citys[indexPath.row])"
        //        if imageArray.count == person.names.count {
        //            content.image = imageArray[indexPath.row]
        //        } else {
        //            content.image = UIImage(named: "burning-rose-4k-1k.jpg")
        //            refreshImages()
        //            tableView.reloadData()
        //        }
        //
        //        content.imageProperties.cornerRadius = tableView.rowHeight / 2
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        let userName = person.names[indexPath.row]
        performSegue(withIdentifier: "next", sender: userName)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsVC = segue.destination as? CurrentUsersVC else { return }
        detailsVC.name = person.names[index]
        detailsVC.nikNameStr = person.username[index]
        detailsVC.emailStr = person.email[index]
        detailsVC.adressStr = person.street[index]
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        if imageArray.isEmpty {
            refreshImages()
        } else {
            tableView.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension UsersTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredNames.removeAll()
        guard searchText != "" || searchText != " " else {
            print("empty search")
            return
        }
        
        for item in person.names {
            let text = searchText.lowercased()
            let isArrayContain = item.lowercased().ranges(of: text)
            
            filteredNames.append(item)
        }
        
        if searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredNames = person.names.filter({$0.contains(searchBar.text ?? "")})
            tableView.reloadData()
        }
        
    }
}
