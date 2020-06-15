/*
 
 */

import Foundation
import UIKit

class ViewControllerQuestion: UITableViewController/*, StackLoaderDelegate */{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//TableView start
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let answersCount = stackLoader.questionDetailed?.answers.count {
            return 1 + answersCount
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellQuestionID", for: indexPath) as? CellQuestion else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            cell.configureQuestion()
        } else {
            cell.configureAnswer(WithIndex: indexPath.row - 1)
        }
        
        return cell
    }
//TableView end

}
