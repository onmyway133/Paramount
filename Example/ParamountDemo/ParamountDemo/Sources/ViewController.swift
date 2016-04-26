import UIKit
import Paramount

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    Manager.action = {
      print("action touched")
    }

    Manager.show()
  }
}
