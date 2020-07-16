
import Foundation
import UIKit

class ViewControllerStart: UIViewController {
    
    @IBAction func firstAction(_ sender: UIButton) {
        guard let vc: ViewControllerQuestionsList = storyboard?.instantiateViewController(identifier: "QuestionsListID")
            else { return }
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true)
    }
}
