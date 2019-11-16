/*
 
 */

import Foundation
import UIKit

class CellQuestionList: UITableViewCell {
    
    @IBOutlet weak var labelAuthorName: UILabel!                //Имя автора вопроса
    @IBOutlet weak var labelAskedTime: UILabel!                 //Время создания вопроса
    @IBOutlet weak var labelQuestionShortText: UILabel!         //Короткое описание вопроса (максимум 2 строки)
    @IBOutlet weak var labelAnswersCount: UILabel!              //Количество ответов
    
    func clear(){
        labelAuthorName.text?.removeAll()
        labelAskedTime.text?.removeAll()
        labelQuestionShortText.text?.removeAll()
        labelAnswersCount.text?.removeAll()
    }
    
    func configure(WithQuestion question: Question) {
        clear()
        labelAuthorName.text = "\(question.owner.display_name)"
        if let seconds = question.last_edit_date{
            let askedtime = Date(timeIntervalSince1970: seconds)
            labelAskedTime.text =  "\(askedtime)"
        }
        labelQuestionShortText.text = question.title
        labelAnswersCount.text = "\(question.answer_count)"
    }
}
