import Foundation
import UIKit

class ViewControllerQuestion: UITableViewController{
    
    var question: QuestionDetailed?
    
    //MARK: TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = question?.answers.count else { return 0 }
        print(count + 1)
        return 1 + count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = tableView.dequeueReusableCell(withIdentifier: "CellQuestion", for: indexPath)
        guard
            let questionSafe = question,
            let cell = reuseCell as? CellQuestion
            else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            cell.configureQuestion(question: questionSafe.question)
        } else {
            cell.configureAnswer(withAnswer: questionSafe.answers[indexPath.row - 1])
        }
        
        return cell
    }
}
