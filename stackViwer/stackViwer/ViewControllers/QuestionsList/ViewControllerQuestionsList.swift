import Foundation
import UIKit

class ViewControllerQuestionsList: UITableViewController, UIPickerViewDelegate, QuestionsLoaderDelegate, QuestionLoaderDelegate {
    
    //MARK: Свойства
    //Показывает выбор тэга
    private var pickerView = TagPickerView()
    //Показывает крутилку, когда идёт загрузка с сервера
    private let activityView = ActivityIndicatorViewFullScreen(frame: CGRect.zero)
    private let stackLoader = StackLoader()
    
    //MARK: Методы
    
    
    
    //MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        activityView.set(inView: navigationController!.view)
        
        stackLoader.questionsLoaderDelegate = self
        stackLoader.questionLoaderDelegate = self
        if let tag = navigationItem.title {
            stackLoader.loadFirstPage(withTag: tag)
            activityView.startAnimating()
        }
    }
    
    //MARK: Actions
    //Показать окно выбора тэга
    @IBAction func showTagSelector(_ sender: UIBarButtonItem) {
        guard pickerView.superview == nil else {
            pickerView.removeFromSuperview()
            return
        }
        tableView.isScrollEnabled = false              //Чтобы не было прокрутки таблицы во время выбора тега
        pickerView.show(inView: tableView)
    }
    
    //MARK: TableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stackLoader.questionsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionListCell", for: indexPath) as? CellQuestionList
            else {
                return UITableViewCell()
        }
        cell.configure(WithQuestion: stackLoader.questionsList[indexPath.row])
        return cell
    }
    
    //MARK: TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activityView.startAnimating()
        stackLoader.loadQuestionAndAnswers(questionID: stackLoader.questionsList[indexPath.row].question_id)
    }
    
    //MARK: PickerViewDelegate
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        pickerView.removeFromSuperview()
        //Если выбран другой тег, то загрузить новые вопросы
        if navigationItem.title != self.pickerView.tags[row] {
            activityView.startAnimating()
            stackLoader.loadFirstPage(withTag: self.pickerView.tags[row])
        }
        navigationItem.title = self.pickerView.tags[row]
        tableView.isScrollEnabled = true                       //Чтобы снова появилась прокрутка таблицы после выбора тэга.
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return self.pickerView.tags[row]
    }
    
    
    //MARK: Completions
    private func loadedSuccefull() {
        tableView.reloadData()
        //Прокрутить наверх, если он есть.
        if !stackLoader.questionsList.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                  at: .top,
                                  animated: false)
        }
        activityView.stopAnimating()
    }
    
    private func loadedFail(WithError error: Error, Title title: String) {
        tableView.reloadData()
        activityView.stopAnimating()
        //Показать сообщение с ошибкой
        let alert = UIAlertController(title: title,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                              style: .default,
                              handler: {
                                _ in
                                    self.dismiss(animated: true,
                                                 completion: nil)
                                } ))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: QuestionsLoaderDelegate
    func questionsLoaded() {
        DispatchQueue.main.async {
            self.loadedSuccefull()
        }
    }
    
    func questionsLoadingFail(error: Error) {
        loadedFail(WithError: error, Title: Constants.errorLoadingQuestionBody.rawValue)
    }
    
    //MARK: QuestionLoaderDelegate
    func questionLoaded() {
        activityView.stopAnimating()
        guard let questionDetailed = stackLoader.questionDetailed else { return }
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewControllerQuestion = storyBoard.instantiateViewController(withIdentifier: "ViewControllerQuestion") as? ViewControllerQuestion else { return }
        viewControllerQuestion.question = questionDetailed
        navigationController?.pushViewController(viewControllerQuestion, animated: true)
        
    }
    
    func questionLoadingFail(error: Error) {
        loadedFail(WithError: error, Title: Constants.errorLoadingQuestionBody.rawValue)
    }
}

//MARK: Constants
fileprivate enum Constants: String {
    case errorLoadingQuestionBody = "Loading Body Error"        //Текст сообщения об ошибке, при загрузке тела вопроса
    
    case openQuestionViewcontroller = "OpenViewControllerQuestion"
}
