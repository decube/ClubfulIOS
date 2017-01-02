//
//  MyPagePageViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 12. 31..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit


protocol MypagePageViewControllerDelegate: class {
    func mypagePageViewControllerDelegate(_ pageViewController: MypagePageViewController, didUpdatePageCount count: Int)
    func mypagePageViewControllerDelegate(_ pageViewController: MypagePageViewController, didUpdatePageIndex index: Int)
    
}
class MypagePageViewController: UIPageViewController {
    weak var pdelegate: MypagePageViewControllerDelegate?
    
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController("MypageCreateVC"),
                self.newViewController("MypageInsVC")]
    }()
    let storyboardName = "User"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if let initialViewController = orderedViewControllers.first {
            scrollToViewController(initialViewController)
        }
        pdelegate?.mypagePageViewControllerDelegate(self, didUpdatePageCount: orderedViewControllers.count)
    }
    
    
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self, viewControllerAfter: visibleViewController) {
            scrollToViewController(nextViewController)
        }
    }
    
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = orderedViewControllers.index(of: firstViewController) {
            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = orderedViewControllers[newIndex]
            scrollToViewController(nextViewController, direction: direction)
        }
    }
    
    fileprivate func newViewController(_ id: String) -> UIViewController {
        let vc = UIStoryboard(name: self.storyboardName, bundle: nil).instantiateViewController(withIdentifier: "\(id)")
        return vc
    }
    
    fileprivate func scrollToViewController(_ viewController: UIViewController, direction: UIPageViewControllerNavigationDirection = .forward) {
        setViewControllers([viewController],direction: direction,animated: true,completion: { (finished) -> Void in
            self.notifyDelegateOfNewIndex()
        })
    }
    fileprivate func notifyDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.index(of: firstViewController) {
            pdelegate?.mypagePageViewControllerDelegate(self, didUpdatePageIndex: index)
        }
    }
    
}

extension MypagePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        if previousIndex < 0{
            return nil
        }
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        if nextIndex > 1{
            return nil
        }
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
    
}
extension MypagePageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        notifyDelegateOfNewIndex()
    }
}

