import Foundation

//MARK: Вопросы начало
struct QuestionsList: Codable {
    let items: [Question]
}

struct Question: Codable {
    let question_id: Int
    let answer_count: Int
    let last_edit_date: Double?
    let title: String
    let owner: Owner
}

struct Owner: Codable {
    let display_name: String
}
//Вопросы конец

//MARK: Вопрос подробно начало
struct QuestionsWithBody: Codable {
    let items: [QuestionWithBody]
}

struct QuestionWithBody: Codable {
    let question_id: Int
    let body: String
    let last_edit_date: Double?
    let score: Int
    let owner: Owner
}
//Вопрос подробно конец

//MARK: Ответы начало
struct Answer: Codable {
    let last_activity_date: Double
    let body: String
    let is_accepted: Bool
    let score: Int
    let owner: Owner
}

struct AnswersList: Codable {
    let items: [Answer]
}
//Ответы конец

//Для хранения в классе
struct QuestionDetailed {
    var question: QuestionWithBody
    var answers: [Answer]
}
