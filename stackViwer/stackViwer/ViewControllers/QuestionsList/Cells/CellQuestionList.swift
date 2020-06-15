import Foundation
import UIKit

class CellQuestionList: UITableViewCell {
    
    @IBOutlet weak var labelAuthorName: UILabel!                //Имя автора вопроса
    @IBOutlet weak var labelAskedTime: UILabel!                 //Время последнего изменения вопроса
    @IBOutlet weak var labelModified: UILabel!
    @IBOutlet weak var labelQuestionShortText: UILabel!         //Короткое описание вопроса (максимум 2 строки)
    @IBOutlet weak var labelAnswersCount: UILabel!              //Количество ответов
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelAuthorName.text?.removeAll()
        labelAskedTime.text?.removeAll()
        labelModified.text?.removeAll()
        labelQuestionShortText.text?.removeAll()
        labelAnswersCount.text?.removeAll()
    }
    
    func configure(WithQuestion question: Question) {
        labelAuthorName.text = "\(question.owner.display_name)"
        labelQuestionShortText.text = question.title
        labelAnswersCount.text = "\(question.answer_count)"
        labelAskedTime.text = getSmartTime(seconds: question.last_edit_date)
        if let empty = labelAskedTime.text?.isEmpty, !empty {
            labelModified.text = "modified"
        }
    }
    
    private func getSmartTime(seconds: Double?) -> String {
        guard let secondsSafe = seconds else { return "" }
        
        return secondsSafe.smartModified()
    }
    
}
