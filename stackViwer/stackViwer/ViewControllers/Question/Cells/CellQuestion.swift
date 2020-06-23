import Foundation
import UIKit

class CellQuestion: UITableViewCell {
    
    @IBOutlet weak var imageIsAnswer: UIImageView!              //Картинка с галочкой (для помеченного как "ответ")
    @IBOutlet weak var imageIsAnswerWidth: NSLayoutConstraint!  //Ширина картинки imageIsAnswer
    @IBOutlet weak var labelRating: UILabel!                    //Рейтинг ответа
    @IBOutlet weak var labelAuthor: UILabel!                    //Имя автора
    @IBOutlet weak var labelDate: UILabel!                      //Дата публикации/обновления
    @IBOutlet weak var labelAnswer: UILabel!                    //Текст ответа
    
    //Шрифт для выделения текста в тэге <code>
    private let codeFont = UIFont.monospacedSystemFont(ofSize: 17.0, weight: UIFont.Weight.light)
    
    //вернуть ячейку в начальное состояние
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageIsAnswer.isHidden = true
        imageIsAnswerWidth.constant = 50
        labelRating.text?.removeAll()
        labelAuthor.text?.removeAll()
        labelDate.text?.removeAll()
        labelAnswer.text?.removeAll()
        backgroundColor = .clear
    }
    
    func configureQuestion(question: QuestionWithBody) {
        backgroundColor = .yellow
        imageIsAnswerWidth.constant = 0
        labelAuthor.text = question.owner.display_name
        labelRating.text = "\(question.score)"
        labelDate.text = question.last_edit_date?.smartModified() ?? " "
        labelAnswer.attributedText = formatString(question.body)
    }
    
    func configureAnswer(withAnswer answer: Answer) {
        if answer.is_accepted {
            imageIsAnswer.isHidden = false
            imageIsAnswerWidth.constant = 50
        }
        labelRating.text = "\(answer.score)"
        labelAuthor.text = answer.owner.display_name
        labelDate.text = answer.last_activity_date.smartModified()
        labelAnswer.attributedText = formatString(answer.body)
    }
    
    //Работа с html-тэгами
    private func tagRemoved(From str: String) -> String {
        //Меняем <br> на конец строки
        let stringWithEOL = str.replacingOccurrences(of: "<br>",
                                                   with: "\n",
                                                   options: .caseInsensitive,
                                                   range: nil)
        //Меняем тэг <code> на ΩcodeΩ, чтобы его не удалить
        let stringWithReplacedStartCode = stringWithEOL.replacingOccurrences(of: "<code>",
                                                                             with: "ΩcodeΩ",
                                                                             options: .caseInsensitive,
                                                                             range: nil)
        let stringWithReplacedCode = stringWithReplacedStartCode.replacingOccurrences(of: "</code>",
                                                                                      with: "Ω/codeΩ",
                                                                                      options: .caseInsensitive,
                                                                                      range: nil)
        //Удаляем все html-тэги
        let bodyWithoutTags = stringWithReplacedCode.replacingOccurrences(of: "<[^>]+>",
                                                                          with: "",
                                                                          options: .regularExpression,
                                                                          range: nil)
        return bodyWithoutTags
    }
    
    //Работа с тэгом ΩcodeΩ
    private func formatString(_ stringWithTags: String) -> NSMutableAttributedString {
        var string = tagRemoved(From: stringWithTags)
        let mutable = NSMutableAttributedString(string: string)
        var startIndex = string.startIndex
        //Покрасить фон и изменить шрифт внутри тэга ΩcodeΩ
        while let range = string.range(of: "ΩcodeΩ[^Ω]+Ω/codeΩ",
                                       options: .regularExpression,
                                       range: startIndex..<string.endIndex) {
            mutable.addAttribute(.backgroundColor,
                                 value: UIColor.cyan,
                                 range: NSRange(range, in: string))
            mutable.addAttribute(.font, value: codeFont, range: NSRange(range, in: string))
                                        
            startIndex = range.upperBound
        }
        //Удалить тэг ΩcodeΩ
        startIndex = string.startIndex
        while let range = string.range(of: "Ω[^Ω]+Ω",
                                       options: .regularExpression,
                                       range: startIndex..<string.endIndex) {
            mutable.replaceCharacters(in: NSRange(range, in: string), with: "")
            string.replaceSubrange(range, with: "")
        }
        return mutable
    }
}
