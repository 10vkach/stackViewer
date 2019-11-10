/*
 
 */

import Foundation
import UIKit

class CellQuestionList: UITableViewCell {
    
    @IBOutlet weak var labelAuthorName: UILabel!                //Имя автора вопроса
    @IBOutlet weak var labelAskedTime: UILabel!                 //Время создания вопроса
    @IBOutlet weak var labelQuestionShortText: UILabel!         //Короткое описание вопроса (максимум 2 строки)
    @IBOutlet weak var labelAnswersCount: UILabel!              //Количество ответов
    
    func configure() {
        
    }
}
