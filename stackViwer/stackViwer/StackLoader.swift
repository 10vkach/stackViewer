/*
 Набор методов для получения данных с сервера
 + сами данные загруженные с сервера
 */

import Foundation

public let stackLoader = StackLoader()

public class StackLoader {
    
    private let loadingQueue = DispatchQueue.global(qos: .utility)                              //Поток в котором будет происходить загрузка и парс данных
    
    private var loadingCompletion: ()->() = { }                                                 //Код, который надо выполнить после успешной загрузки данных
    private var loadingErrorCompletion: (Error)->() = {_ in }                                   //Выполнится при неуспешной загрузке данных
    
    var questionsList: [Question] = []
    
    //Загрузить первую страницу вопросов (использовать при смене тэга и запуске программы)
    func loadFirstPage(WithTag tag: String,                         //тэг, который отправится на сервер
                       completion: @escaping ()->(),                //Выполнится при успешном завершении загрузки
                       errorCompletion: @escaping (Error)->()) {    //Выполнится при неуспешном завершении загрузки
        
        loadingCompletion = {
            DispatchQueue.main.async {
                completion()
            }
        }
        loadingErrorCompletion = {
            error in
                DispatchQueue.main.async {
                    errorCompletion(error)
                }
            }
        //Загрузить данные в отдельном потоке
        if let url = getURL(ForPage: 1, WithTag: tag) {
            
            let task = URLSession.shared.dataTask(with: url,
                                                  completionHandler: { self.parseResponse(data: $0,
                                                                                          response: $1,
                                                                                          error: $2) })
            loadingQueue.async {
                task.resume()
            }
        }
    }
    
    //Загрузить ещё одну страницу вопросов (не использовать для первой пачки вопросов)
    
    //Обработать ответ от сервера
    private func parseResponse(data: Data?, response: URLResponse?, error: Error?) {
        
        //Если получили ошибку, то обработать её и прерваться
        if let errorSafe = error {
            loadingErrorCompletion(errorSafe)
            return
        }
        
        if let dataSafe = data {
            //распарсить данные и запихать их в массив
            let questionsListResponse: QuestionsList = try! JSONDecoder().decode(QuestionsList.self, from: dataSafe)
            questionsList = questionsListResponse.items
            
//            print(questionsList)
            
            loadingCompletion()
        }
    }
    
    //Создать запрос с указанной страницей и тэгом
    private func getURL(ForPage page: Int,
                        WithTag tag: String) -> URL? {
        var request = URLComponents()
        request.scheme = "https"
        request.host = "api.stackexchange.com"
        request.path = "/2.2/questions"
        request.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "tagged", value: tag),
            URLQueryItem(name: "pagesize", value: "20"),
            URLQueryItem(name: "sort", value: "creation"),
            URLQueryItem(name: "site", value: "stackoverflow"),
            URLQueryItem(name: "order", value: "desc")
        ]
        return request.url
    }
}


//Вопросы начало
struct QuestionsList: Codable {
    let items: [Question]
}

struct Question: Codable {
    let answer_count: Int
    let last_edit_date: Double?
    let title: String
    let owner: Owner
}

struct Owner: Codable {
    let display_name: String
}
//Вопросы конец
