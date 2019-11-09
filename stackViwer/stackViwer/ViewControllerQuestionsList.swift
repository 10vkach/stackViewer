/*
 
 */

import Foundation
import UIKit

class ViewControllerQuestionsList: UITableViewController {
    var z = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIBarButtonItem(title: "tag",
                                     style: .plain,
                                     target: self,
                                     action: #selector(ViewControllerQuestionsList.showTagSelector))
        navigationItem.setLeftBarButton(button, animated: false)
    }
    
    @objc func showTagSelector() {
        print("тада")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "OpenViewControllerQuestion", sender: self)
    }
}
