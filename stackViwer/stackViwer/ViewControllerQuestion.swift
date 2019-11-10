/*
 
 */

import Foundation
import UIKit

class ViewControllerQuestion: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//TAbleView start
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellQuestionID", for: indexPath) as? CellQuestion else {
            return UITableViewCell()
        }
        
        return cell
    }
//TableView end
    
}
