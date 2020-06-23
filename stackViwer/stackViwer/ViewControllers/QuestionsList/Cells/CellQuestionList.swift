import Foundation
import UIKit

class CellQuestionList: UITableViewCell {
    
    @IBOutlet weak var labelAuthorName: UILabel!                //Имя автора вопроса
    @IBOutlet weak var labelAskedTime: UILabel!                 //Время последнего изменения вопроса
    @IBOutlet weak var labelModified: UILabel!
    @IBOutlet weak var labelQuestionShortText: UILabel!         //Короткое описание вопроса (максимум 2 строки)
    @IBOutlet weak var labelAnswersCount: UILabel!              //Количество ответов
    
    func configure(WithQuestion question: Question) {
        labelAuthorName.text = "\(question.owner.display_name)"
        labelQuestionShortText.text = question.title
        labelAnswersCount.text = "\(question.answer_count)"
        labelAskedTime.text = getSmartTime(seconds: question.last_edit_date)
        if let empty = labelAskedTime.text?.isEmpty, !empty {
            labelModified.text = "modified"
        } else {
            labelModified.text?.removeAll()
        }
        labelQuestionShortText.backgroundColor = nil
    }
    
    func configureForLoading() {
        labelAuthorName.text = "Loading"
        labelQuestionShortText.text = "Loading"
        labelAnswersCount.text = "Loading"
        labelAskedTime.text = "Loading"
        labelModified.text = "Loading"
        labelQuestionShortText.backgroundColor = .red
    }
    
    private func getSmartTime(seconds: Double?) -> String {
        guard let secondsSafe = seconds else { return "" }
        
        return secondsSafe.smartModified()
    }
    
}
