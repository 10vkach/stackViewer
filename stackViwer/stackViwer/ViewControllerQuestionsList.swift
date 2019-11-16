/*
 
 */

import Foundation
import UIKit

class ViewControllerQuestionsList: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let tags: [String] = [
        "objective-c",
        "ios",
        "xcode",
        "cocoa-touch",
        "iphone"
    ]
    
    let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))                       //Показывает выбор тэга
    let activityView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))          //Показывать, когда идёт загрузка с сервера
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Добавить кнопку для выбора тэга
        let button = UIBarButtonItem(title: "Tag",
                                     style: .plain,
                                     target: self,
                                     action: #selector(ViewControllerQuestionsList.showTagSelector))
        navigationItem.setLeftBarButton(button, animated: false)
        
        //Настройка pickerView
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.frame = CGRect(x: 0,
                                  y: navigationController!.navigationBar.frame.maxY,
                                  width: UIScreen.main.bounds.width,
                                  height: UIScreen.main.bounds.height - navigationController!.navigationBar.frame.maxY)
        pickerView.backgroundColor = .lightGray
        pickerView.alpha = 0.95
        
        //Настройка activityView
        activityView.frame = CGRect(x: 0,
                                    y: 0,
                                    width: UIScreen.main.bounds.width,
                                    height: UIScreen.main.bounds.height)
        activityView.color = .black
        activityView.backgroundColor = .lightGray
        activityView.alpha = 0.9
        navigationController?.view.addSubview(activityView)
        
        if let tag = navigationItem.title {
            stackLoader.loadFirstPage(WithTag: tag,
                                      completion: {
                                            self.loadedSuccefull()
                                        },
                                      errorCompletion: {
                                            self.loadedFail(WithError: $0)
                                        })
            activityView.startAnimating()
        }
    }
    
    //Показать окно выбора тэга
    @objc func showTagSelector() {
        if pickerView.superview == nil {
            tableView.isScrollEnabled = false              //Чтобы не было прокрутки таблицы во время выбора тега
            navigationController?.view.addSubview(pickerView)
        } else {
            pickerView.removeFromSuperview()
        }
    }
    
//TableView start
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stackLoader.questionsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionListCell", for: indexPath) as? CellQuestionList {
            cell.configure(WithQuestion: stackLoader.questionsList[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "OpenViewControllerQuestion", sender: self)
    }
//TableView end
    
//PickerView start
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tags.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return tags[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        pickerView.removeFromSuperview()
        //Если выбран другой тег, то загрузить новые вопросы
        if navigationItem.title != tags[row] {
            activityView.startAnimating()
            stackLoader.loadFirstPage(WithTag: tags[row],
                                      completion: {
                                            self.loadedSuccefull()
                                        },
                                      errorCompletion: {
                                            self.loadedFail(WithError: $0)
                                        })
        }
        navigationItem.title = tags[row]
        tableView.isScrollEnabled = true                       //Чтобы снова появилась прокрутка таблицы после выбора тэга.
    }
    
//PickerView end
    
//Completions start
    private func loadedSuccefull() {
        tableView.setContentOffset(.zero, animated: false)
        tableView.reloadData()
        activityView.stopAnimating()
    }
    
    private func loadedFail(WithError error: Error) {
        tableView.setContentOffset(.zero, animated: false)
        tableView.reloadData()
        activityView.stopAnimating()
        //Показать сообщение с ошибкой
    }
    
//Completions end
}
