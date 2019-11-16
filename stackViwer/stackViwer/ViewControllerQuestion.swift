/*
 
 */

import Foundation
import UIKit

class ViewControllerQuestion: UITableViewController/*, StackLoaderDelegate */{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//TAbleView start
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellQuestionID", for: indexPath) as? CellQuestion else {
            return UITableViewCell()
        }
        
        cell.clear()
        if indexPath.row == 0 {
            cell.backgroundColor = .yellow
            cell.imageIsAnswerWidth.constant = 0
        }
        
        return cell
    }
//TableView end

}
