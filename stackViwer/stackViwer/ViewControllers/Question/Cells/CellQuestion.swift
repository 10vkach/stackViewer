/*
 
 */

import Foundation
import UIKit

class CellQuestion: UITableViewCell {
    
    @IBOutlet weak var imageIsAnswer: UIImageView!              //Картинка с галочкой (для помеченного как "ответ")
    @IBOutlet weak var imageIsAnswerWidth: NSLayoutConstraint!  //Ширина картинки imageIsAnswer
    @IBOutlet weak var labelRating: UILabel!                    //Рейтинг ответа
    @IBOutlet weak var labelAuthor: UILabel!                    //Имя автора
    @IBOutlet weak var labelDate: UILabel!                      //Дата публикации/обновления
    @IBOutlet weak var labelAnswer: UILabel!                    //Текст ответа
    
    
    //вернуть ячейку в начальное состояние
    func clear() {
        imageIsAnswer.isHidden = true
        imageIsAnswerWidth.constant = 50
        labelRating.text?.removeAll()
        labelAuthor.text?.removeAll()
        labelDate.text?.removeAll()
        labelAnswer.text?.removeAll()
        backgroundColor = .clear
    }
    
    func configureQuestion() {
        clear()
        backgroundColor = .yellow
        imageIsAnswerWidth.constant = 0
        if let que = stackLoader.questionDetailed?.question {
            labelAuthor.text = que.owner.display_name
            labelRating.text = "\(que.score)"
            labelDate.text = que.last_edit_date?.smartModified() ?? " "
            labelAnswer.text = tagRemoved(From: que.body)
        }
    }
    
    func configureAnswer(WithIndex index: Int) {
        clear()
        if let answer = stackLoader.questionDetailed?.answers[index] {
            if answer.is_accepted {
                imageIsAnswer.isHidden = false
                imageIsAnswerWidth.constant = 50
            }
            labelRating.text = "\(answer.score)"
            labelAuthor.text = answer.owner.display_name
            labelDate.text = answer.last_activity_date.smartModified()
            labelAnswer.text = tagRemoved(From: answer.body)
        }
    }
    
    private func tagRemoved(From str: String) -> String {
        
        let bodyWithEOL = str.replacingOccurrences(of: "<br>",
                                                   with: "\n",
                                                   options: .caseInsensitive,
                                                   range: nil)
        let bodyWithoutTags = bodyWithEOL.replacingOccurrences(of: "<[^>]+>",
                                                               with: "",
                                                               options: .regularExpression,
                                                               range: nil)
        return bodyWithoutTags
    }
}
