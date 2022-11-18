//
//  View+Extension.swift
//  Saveloper
//
//  Created by Denis Svetlakov on 17.11.2022.
//

import SwiftUI

extension View {
    
    func deleteObject(persistenceController: PersistenceController,
                      object: NSObject) {
        persistenceController.deleteAll()
    }
}

extension View {
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>,
                                    @ViewBuilder sheetView: @escaping () -> SheetView)  -> some View {
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(), showSheet: showSheet)
            )
    }
    
    func inject(_ persistenceController: PersistenceController) -> some View {
      return self
        .environmentObject(persistenceController)
    }
}

struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    
    var sheetView: SheetView
    @Binding var showSheet: Bool
    
    let controller = UIViewController()
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        controller.view.backgroundColor = .clear
        controller.view.frame(forAlignmentRect: CGRect(x: 0, y: 0,
                                                       width: UIScreen.screenWidth,
                                                       height: UIScreen.screenHeight / 2))
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if showSheet {
            
            let sheetController: CustomHostingController = .init(rootView: sheetView)
            sheetController.loadViewIfNeeded()
            sheetController.isModalInPresentation = false
            uiViewController.present(sheetController, animated: true) {
                sheetController.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = true
                DispatchQueue.main.async {
                    self.showSheet.toggle()
                }
            }
        }
    }
}

class CustomHostingController<Content: View>: UIHostingController<Content>,
                                              UIViewControllerTransitioningDelegate {
    var detentIndex: Int = 1
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        
        let controller: UISheetPresentationController = .init(presentedViewController: presented,
                                                              presenting: presenting)
        
        let detent0: UISheetPresentationController.Detent = ._detent(withIdentifier: "Test2", constant: 400.0)
        let detent1: UISheetPresentationController.Detent = ._detent(withIdentifier: "Test3", constant: 500.0)
        let detent2: UISheetPresentationController.Detent = ._detent(withIdentifier: "Test2", constant: 650.0)
        let detent3: UISheetPresentationController.Detent = ._detent(withIdentifier: "Test3", constant: 700.0)
        let detsents = [detent0, detent1, detent2, detent3]
        controller.detents = [detsents[detentIndex]]
        controller.prefersGrabberVisible = false
        
        return controller
    }
}
