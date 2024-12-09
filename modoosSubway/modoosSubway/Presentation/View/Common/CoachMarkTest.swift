//
//  CoachMarkTest.swift
//  modoosSubway
//
//  Created by 임재현 on 12/9/24.
//

import UIKit
import Instructions
import SwiftUI

struct DefaultViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var hasLaunchedBefore: Bool
    
    func makeUIViewController(context: Context) -> DefaultViewController {
        let viewController = DefaultViewController()
        viewController.onCoachMarkFinished = {
            hasLaunchedBefore = true
        }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: DefaultViewController, context: Context) {}
}

class DefaultViewController: UIViewController {
    let coachMarksController = CoachMarksController()
    let pointOfInterest = UIView()
    var onCoachMarkFinished: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.coachMarksController.start(in: .window(over: self))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.coachMarksController.stop(immediately: true)
    }
}

extension DefaultViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    func numberOfCoachMarks(for coachMarksController: Instructions.CoachMarksController) -> Int {
        return 1
    }
    
    func coachMarksController(_ coachMarksController: Instructions.CoachMarksController, coachMarkAt index: Int) -> Instructions.CoachMark {
        return coachMarksController.helper.makeCoachMark(for: pointOfInterest)
    }
    
    func coachMarksController(_ coachMarksController: Instructions.CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: Instructions.CoachMark) -> (bodyView: (any UIView & Instructions.CoachMarkBodyView), arrowView: (any UIView & Instructions.CoachMarkArrowView)?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation
        )
        
        coachViews.bodyView.hintLabel.text = "Hello! I'm a Coach Mark!"
        coachViews.bodyView.nextLabel.text = "Ok!"
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, didEndShowingBySkipping skipped: Bool) {
        onCoachMarkFinished?()
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, didEndShowingByComplete completed: Bool) {
        onCoachMarkFinished?()
    }
}
