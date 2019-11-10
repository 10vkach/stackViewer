/*
 
 */

import Foundation
import UIKit

class CellQuestion: UITableViewCell {
    
    @IBOutlet weak var imageIsAnswer: UIImageView!              //Картинка с галочкой (для помеченного как "ответ")
    @IBOutlet weak var labelRating: UILabel!                    //Рейтинг ответа
    @IBOutlet weak var labelAuthor: UILabel!                    //Имя автора
    @IBOutlet weak var labelDate: UILabel!                      //Дата публикации/обновления
    @IBOutlet weak var labelAnswer: UILabel!                    //Текст ответа
    
    
    //вернуть ячейку в начальное состояние
    func clear() {
        imageIsAnswer.isHidden = true
        labelRating.text?.removeAll()
        labelAuthor.text?.removeAll()
        labelDate.text?.removeAll()
        labelAnswer.text?.removeAll()
    }
    
}
