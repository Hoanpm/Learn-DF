
import UIKit

public protocol QuestionViewControllerDelegate: AnyObject {
  func questionViewController(
    _ viewController: QuestionViewController,
    didCancel questionGroup: QuestionStrategy)
  func questionViewController(
    _ viewController: QuestionViewController,
    didComplete questionStrategy: QuestionStrategy)
}



public class QuestionViewController: UIViewController {
    
    private lazy var questionIndexItem: UIBarButtonItem = {
      let item = UIBarButtonItem(title: "",
                                 style: .plain,
                                 target: nil,
                                 action: nil)
      item.tintColor = .black
      navigationItem.rightBarButtonItem = item
      return item
    }()
    
    public weak var delegate: QuestionViewControllerDelegate?
    
    public var questionStrategy: QuestionStrategy! {
      didSet {
        navigationItem.title = questionStrategy.title
      }
    }
    public var questionGroup: QuestionGroup! {
      didSet {
        navigationItem.title = questionGroup.title
      }
    }
    public var questionIndex = 0
    public var correctCount = 0
    public var incorrectCount = 0
    public var questionView: QuestionView! {
        guard isViewLoaded else { return nil }
        return (view as! QuestionView)
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCancelButton()
        showQuestion()
    }
    
    private func setupCancelButton() {
        let action = #selector(handleCancelPressed(sender:))
        let image = UIImage(named: "ic_menu")
        navigationItem.leftBarButtonItem =
        UIBarButtonItem(image: image,
                        landscapeImagePhone: nil,
                        style: .plain,
                        target: self,
                        action: action)
    }
    @objc private func handleCancelPressed(
      sender: UIBarButtonItem) {
      delegate?.questionViewController(self,
        didCancel: questionStrategy)
    }
                                  
    private func showQuestion() {
      // 1
      let question = questionStrategy.currentQuestion()
      questionView.answerLabel.text = question.answer
      questionView.promptLabel.text = question.prompt
      questionView.hintLabel.text = question.hint
      questionView.answerLabel.isHidden = true
      questionView.hintLabel.isHidden = true
    // 2
      questionIndexItem.title =
        questionStrategy.questionIndexTitle()
    }
    
    @IBAction func toggleAnswerLabels(_ sender: Any) {
        questionView.answerLabel.isHidden = !questionView.answerLabel.isHidden
        questionView.hintLabel.isHidden = !questionView.hintLabel.isHidden
        
    }
    
    @IBAction func handleCorrect(_ sender: Any) {
        let question = questionStrategy.currentQuestion()	
        questionStrategy.markQuestionCorrect(question)
        questionView.correctCountLabel.text =
        String(questionStrategy.correctCount)
        showNextQuestion()
    }
    @IBAction func handleIncorrect(_ sender: Any) {
        let question = questionStrategy.currentQuestion()
        questionStrategy.markQuestionIncorrect(question)
        questionView.incorrectCountLabel.text =
        String(questionStrategy.incorrectCount)
        showNextQuestion()
    }
    private func showNextQuestion() {
      guard questionStrategy.advanceToNextQuestion() else {
        delegate?.questionViewController(self,
          didComplete: questionStrategy)
    return
    }
      showQuestion()
    }
}
