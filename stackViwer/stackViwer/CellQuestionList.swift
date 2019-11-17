/*
 
 */

import Foundation
import UIKit

class CellQuestionList: UITableViewCell {
    
    @IBOutlet weak var labelAuthorName: UILabel!                //Имя автора вопроса
    @IBOutlet weak var labelAskedTime: UILabel!                 //Время последнего изменения вопроса
    @IBOutlet weak var labelModified: UILabel!
    @IBOutlet weak var labelQuestionShortText: UILabel!         //Короткое описание вопроса (максимум 2 строки)
    @IBOutlet weak var labelAnswersCount: UILabel!              //Количество ответов
    
    func clear(){
        labelAuthorName.text?.removeAll()
        labelAskedTime.text?.removeAll()
        labelModified.text?.removeAll()
        labelQuestionShortText.text?.removeAll()
        labelAnswersCount.text?.removeAll()
    }
    
    func configure(WithQuestion question: Question) {
        clear()
        labelAuthorName.text = "\(question.owner.display_name)"
        labelQuestionShortText.text = question.title
        labelAnswersCount.text = "\(question.answer_count)"
        labelAskedTime.text = getSmartTime(seconds: question.last_edit_date)
        if let empty = labelAskedTime.text?.isEmpty, !empty {
            labelModified.text = "modified"
        }
    }
    
    private func getSmartTime(seconds: Double?) -> String {
        guard
            let secondsSafe = seconds
        else {
                return ""
        }
        
        let ago = "ago"
        let calendar = Calendar(identifier: .gregorian)
        let askedtime = Date(timeIntervalSince1970: secondsSafe)
        let components = calendar.dateComponents([.day, .hour, .minute, .second],
                                                 from: askedtime,
                                                 to: Date())
        
        if let day = components.day {
            if day == 1 {
                return "\(day) day \(ago)"
            } else if day > 1 {
                return "\(day) days \(ago)"
            }
        }
        if let hour = components.hour {
            if hour == 1 {
                return "\(hour) hour \(ago)"
            } else if hour > 1 {
                return "\(hour) hours \(ago)"
            }
        }
        if let minute = components.minute {
            if minute == 1 {
                return "\(minute) minute \(ago)"
            } else if minute > 1 {
                return "\(minute) minutes \(ago)"
            }
        }
        if let second = components.second {
            if second == 1 {
                return "\(second) second \(ago)"
            } else if second > 1 {
                return "\(second) seconds \(ago)"
            }
        }
        return ""
    }
    
}
