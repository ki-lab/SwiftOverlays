//
//  SwiftOverlays.swift
//  SwiftTest
//
//  Created by Peter Prokop on 15/10/14.
//  Copyright (c) 2014 Peter Prokop. All rights reserved.
//

import Foundation
import UIKit


// For convenience methods
@objc public extension UIViewController {

    // MARK: Blocking
    
    /**
        Shows *blocking* wait overlay with activity indicator, centered in the view controller's main view
     
        Do not use this method for **UITableViewController** or **UICollectionViewController**
     
        - returns: Created overlay
     */
    @objc @discardableResult
    func showBlockingWaitOverlay() -> UIView {
        return SwiftOverlays.showBlockingWaitOverlay(self.view.window)
    }
    
    /**
        Shows *blocking* wait overlay with activity indicator *and text*, centered in the view controller's main view
     
        Do not use this method for **UITableViewController** or **UICollectionViewController**
     
        - parameter text: Text to be shown on overlay
     
        - returns: Created overlay
     */
    @objc @discardableResult
    func showBlockingWaitOverlayWithText(_ text: String) -> UIView  {
        return SwiftOverlays.showBlockingWaitOverlayWithText(text, window: self.view.window)
    }
    
    /**
        Shows *blocking text-only* overlay, centered in the view controller's main view
     
        Do not use this method for **UITableViewController** or **UICollectionViewController**
     
        - parameter text: Text to be shown on overlay
     
        - returns: Created overlay
     */
    @objc @discardableResult
    func showBlockingTextOverlay(_ text: String) -> UIView  {
        return SwiftOverlays.showBlockingTextOverlay(text, window: self.view.window)
    }
    
    /**
        Shows *blocking* overlay *with image and text*, centered in the view controller's main view
     
        Do not use this method for **UITableViewController** or **UICollectionViewController**
     
        - parameter image: Image to be added to overlay
        - parameter text: Text to be shown on overlay
     
        - returns: Created overlay
     */
    @objc @discardableResult
    func showBlockingImageAndTextOverlay(_ image: UIImage, text: String) -> UIView  {
        return SwiftOverlays.showBlockingImageAndTextOverlay(image, text: text, window: self.view.window)
    }
    
    /**
        Removes all *blocking* overlays from view controller's main view
     */
    @objc func removeAllBlockingOverlays() {
        SwiftOverlays.removeAllBlockingOverlays(self.view.window)
    }
    
    
    // MARK: Non-blocking
    
    /**
        Shows wait overlay with activity indicator, centered in the view controller's main view
    
        Do not use this method for **UITableViewController** or **UICollectionViewController**
    
        - returns: Created overlay
    */
    @objc @discardableResult
    func showWaitOverlay() -> UIView {
        return SwiftOverlays.showCenteredWaitOverlay(self.view)
    }
    
    /**
        Shows wait overlay with activity indicator *and text*, centered in the view controller's main view
        
        Do not use this method for **UITableViewController** or **UICollectionViewController**
        
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    @objc @discardableResult
    func showWaitOverlayWithText(_ text: String) -> UIView  {
        return SwiftOverlays.showCenteredWaitOverlayWithText(self.view, text: text)
    }
    
    /**
        Shows *text-only* overlay, centered in the view controller's main view
        
        Do not use this method for **UITableViewController** or **UICollectionViewController**
        
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    @objc @discardableResult
    func showTextOverlay(_ text: String) -> UIView  {
        return SwiftOverlays.showTextOverlay(self.view, text: text)
    }
    
    /**
        Shows overlay with text and progress bar, centered in the view controller's main view
        
        Do not use this method for **UITableViewController** or **UICollectionViewController**
        
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    @objc @discardableResult
    func showProgressOverlay(_ text: String) -> UIView  {
        return SwiftOverlays.showProgressOverlay(self.view, text: text)
    }
    
    /**
        Shows overlay *with image and text*, centered in the view controller's main view
        
        Do not use this method for **UITableViewController** or **UICollectionViewController**
        
        - parameter image: Image to be added to overlay
        - parameter text: Text to be shown on overlay
    
        - returns: Created overlay
    */
    @objc @discardableResult
    func showImageAndTextOverlay(_ image: UIImage, text: String) -> UIView  {
        return SwiftOverlays.showImageAndTextOverlay(self.view, image: image, text: text)
    }
    
    /**
        Shows notification on top of the status bar, similar to native local or remote notifications

        - parameter notificationView: View that will be shown as notification
        - parameter duration: Amount of time until notification disappears
        - parameter animated: Should appearing be animated
    */
    class func showOnTopOfStatusBar(_ notificationView: UIView, duration: TimeInterval, animated: Bool = true) {
        SwiftOverlays.showOnTopOfStatusBar(notificationView, duration: duration, animated: animated)
    }
    
    /**
        Removes all overlays from view controller's main view
    */
    @objc func removeAllOverlays() {
        SwiftOverlays.removeAllOverlaysFromView(self.view)
    }
    
    /**
        Updates text on the current overlay.
        Does nothing if no overlay is present.
    
        - parameter text: Text to set
    */
    @objc func updateOverlayText(_ text: String) {
        SwiftOverlays.updateOverlayText(self.view, text: text)
    }
    
    /**
        Updates progress on the current overlay.
        Does nothing if no overlay is present.
    
        - parameter progress: Progress to set 0.0 .. 1.0
    */
    @objc func updateOverlayProgress(_ progress: Float) {
        SwiftOverlays.updateOverlayProgress(self.view, progress: progress)
    }
}


@objc open class SwiftOverlaysConfiguration: NSObject {
    
    open static var defaultConfiguration: SwiftOverlaysConfiguration = SwiftOverlaysConfiguration()
    
    open var cornerRadius = CGFloat(10)
    open var padding = CGFloat(20)
    
    open var backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    open var blockerBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    open var textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    open var font = UIFont.systemFont(ofSize: 14)
    open var textAlignment = NSTextAlignment.natural
    open var lineBreakMode = NSLineBreakMode.byWordWrapping
    open var activityIndicatorViewStyle = UIActivityIndicatorView.Style.whiteLarge
    
    // Annoying notifications on top of status bar
    open var bannerDissapearAnimationDuration = 0.5
    
    private override init() {
        // Private initialization to ensure only one instance is created.
    }
}


open class SwiftOverlays: NSObject {
    
    // Some random number
    static let containerViewTag = 456987123
    
    static var bannerWindow : UIWindow?
    
    open class Utils {
        
        /**
            Adds autolayout constraints to innerView to center it in its superview and fix its size.
            `innerView` should have a superview.
        
            - parameter innerView: View to set constraints on
        */
        open static func centerViewInSuperview(_ view: UIView) {
            assert(view.superview != nil, "`view` should have a superview")
            
            guard let superview = view.superview else {
                return
            }
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            // Center X
            superview.addConstraint(NSLayoutConstraint(item: view,
                                                       attribute: NSLayoutConstraint.Attribute.centerX,
                                                       relatedBy: NSLayoutConstraint.Relation.equal,
                                                       toItem: superview,
                                                       attribute: NSLayoutConstraint.Attribute.centerX,
                                                       multiplier: 1,
                                                       constant: 0))
            
            // Center Y
            superview.addConstraint(NSLayoutConstraint(item: view,
                                                       attribute: NSLayoutConstraint.Attribute.centerY,
                                                       relatedBy: NSLayoutConstraint.Relation.equal,
                                                       toItem: superview,
                                                       attribute: NSLayoutConstraint.Attribute.centerY,
                                                       multiplier: 1,
                                                       constant: 0))
            
            // Leading
            superview.addConstraint(NSLayoutConstraint(item: view,
                                                       attribute: NSLayoutConstraint.Attribute.leading,
                                                       relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual,
                                                       toItem: superview,
                                                       attribute: NSLayoutConstraint.Attribute.leadingMargin,
                                                       multiplier: 1,
                                                       constant: 20))
            
            // Trailing
            superview.addConstraint(NSLayoutConstraint(item: view,
                                                       attribute: NSLayoutConstraint.Attribute.trailing,
                                                       relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
                                                       toItem: superview,
                                                       attribute: NSLayoutConstraint.Attribute.trailingMargin,
                                                       multiplier: 1,
                                                       constant: 20))
            
            // Top
            superview.addConstraint(NSLayoutConstraint(item: view,
                                                       attribute: NSLayoutConstraint.Attribute.top,
                                                       relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual,
                                                       toItem: superview,
                                                       attribute: NSLayoutConstraint.Attribute.topMargin,
                                                       multiplier: 1,
                                                       constant: 100))
            
            // Bottom
            superview.addConstraint(NSLayoutConstraint(item: view,
                                                       attribute: NSLayoutConstraint.Attribute.bottom,
                                                       relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
                                                       toItem: superview,
                                                       attribute: NSLayoutConstraint.Attribute.bottomMargin,
                                                       multiplier: 1,
                                                       constant: 100))
            
        }
    }
    
    // MARK: - Public class methods -
    
    // MARK: Blocking
    
    /**
     Shows *blocking* wait overlay with activity indicator, centered in the given window
     
     - parameter window: Window on top of which the wait overlay should be shown, if nil the wait overlay is shown on top of the key window
     
     - returns: Created overlay
     */
    @objc @discardableResult
    open class func showBlockingWaitOverlay(_ window: UIWindow? = nil) -> UIView {
        let visibleWindow = window != nil ? window! : UIWindow.visibleWindow()
        let blocker = addWindowBlocker(visibleWindow)
        showCenteredWaitOverlay(blocker)
        
        return blocker
    }
    
    /**
     Shows wait overlay with activity indicator *and text*, centered in the given window
     
     - parameter text: Text to be shown on overlay
     - parameter window: Window on top of which the wait overlay should be shown, if nil the wait overlay is shown on top of the key window
     
     - returns: Created overlay
     */
    @objc @discardableResult
    open class func showBlockingWaitOverlayWithText(_ text: String, window: UIWindow? = nil) -> UIView {
        let visibleWindow = window != nil ? window! : UIWindow.visibleWindow()
        let blocker = addWindowBlocker(visibleWindow)
        showCenteredWaitOverlayWithText(blocker, text: text)
        
        return blocker
    }
    
    /**
     Shows *blocking* overlay *with image and text*,, centered in the given window
     
     - parameter image: Image to be added to overlay
     - parameter text: Text to be shown on overlay
     - parameter window: Window on top of which the wait overlay should be shown, if nil the wait overlay is shown on top of the key window
     
     - returns: Created overlay
     */
    @objc @discardableResult
    open class func showBlockingImageAndTextOverlay(_ image: UIImage, text: String, window: UIWindow? = nil) -> UIView  {
        let visibleWindow = window != nil ? window! : UIWindow.visibleWindow()
        let blocker = addWindowBlocker(visibleWindow)
        showImageAndTextOverlay(blocker, image: image, text: text)
        
        return blocker
    }
    
    /**
     Shows *text-only* overlay, centered in the given window
     
     - parameter text: Text to be shown on overlay
     - parameter window: Window on top of which the wait overlay should be shown, if nil the wait overlay is shown on top of the key window
     
     - returns: Created overlay
     */
    @objc @discardableResult
    open class func showBlockingTextOverlay(_ text: String, window: UIWindow? = nil) -> UIView  {
        let visibleWindow = window != nil ? window! : UIWindow.visibleWindow()
        let blocker = addWindowBlocker(visibleWindow)
        showTextOverlay(blocker, text: text)
        
        return blocker
    }
    
    /**
     Removes all *blocking* overlays from the given window
     
     - parameter window: Window from which all *blocking* overlays should be removed, if nil all *blocking* overlays are removed from the key window
     */
    @objc open class func removeAllBlockingOverlays(_ window: UIWindow? = nil) {
        let visibleWindow = window != nil ? window! : UIWindow.visibleWindow()
        removeAllOverlaysFromView(visibleWindow)
    }
    
    
    // MARK: Non-blocking
    @discardableResult
    open class func showCenteredWaitOverlay(_ parentView: UIView) -> UIView {
        
        let padding = SwiftOverlaysConfiguration.defaultConfiguration.padding
        let containerView = self.containerView()
        let activityIndicator = self.activityIndicator()
        
        let viewsDictionary = ["activityIndicator": activityIndicator]
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(padding)-[activityIndicator]-\(padding)-|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: viewsDictionary))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-\(padding)-[activityIndicator]-\(padding)-|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: viewsDictionary))
        
        parentView.addSubview(containerView)
        Utils.centerViewInSuperview(containerView)
        
        return containerView
    }
    
    @discardableResult
    open class func showCenteredWaitOverlayWithText(_ parentView: UIView, text: String) -> UIView  {
        return showGenericOverlay(parentView, text: text, accessoryView: self.activityIndicator())
    }
    
    @discardableResult
    open class func showImageAndTextOverlay(_ parentView: UIView, image: UIImage, text: String) -> UIView  {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return showGenericOverlay(parentView, text: text, accessoryView: imageView)
    }

    open class func showGenericOverlay(_ parentView: UIView, text: String, accessoryView: UIView, horizontalLayout: Bool = true) -> UIView {
        
        let padding = SwiftOverlaysConfiguration.defaultConfiguration.padding
        let containerView = self.containerView()
        let label = labelForText(text)
        containerView.addSubview(accessoryView)
        containerView.addSubview(label)
        
        let viewsDictionary = ["accessoryView": accessoryView, "label": label]
        
        if horizontalLayout {
            
            containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-\(padding)-[accessoryView]-\(padding)-[label]-\(padding)-|",
                options: [],
                metrics: nil,
                views: viewsDictionary))
            
            // Align accessoryView center with label center on the Y axis
            containerView.addConstraint(NSLayoutConstraint(item: accessoryView,
                                                           attribute: NSLayoutConstraint.Attribute.centerY,
                                                           relatedBy: NSLayoutConstraint.Relation.equal,
                                                           toItem: label,
                                                           attribute: NSLayoutConstraint.Attribute.centerY,
                                                           multiplier: 1,
                                                           constant: 0))
            
            // Top
            containerView.addConstraint(NSLayoutConstraint(item: label,
                                                           attribute: NSLayoutConstraint.Attribute.top,
                                                           relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual,
                                                           toItem: containerView,
                                                           attribute: NSLayoutConstraint.Attribute.top,
                                                           multiplier: 1,
                                                           constant: padding))
            
            containerView.addConstraint(NSLayoutConstraint(item: accessoryView,
                                                           attribute: NSLayoutConstraint.Attribute.top,
                                                           relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual,
                                                           toItem: containerView,
                                                           attribute: NSLayoutConstraint.Attribute.top,
                                                           multiplier: 1,
                                                           constant: padding))
            
            // Bottom
            containerView.addConstraint(NSLayoutConstraint(item: label,
                                                           attribute: NSLayoutConstraint.Attribute.bottom,
                                                           relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
                                                           toItem: containerView,
                                                           attribute: NSLayoutConstraint.Attribute.bottom,
                                                           multiplier: 1,
                                                           constant: -padding))
            
            containerView.addConstraint(NSLayoutConstraint(item: accessoryView,
                                                           attribute: NSLayoutConstraint.Attribute.bottom,
                                                           relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
                                                           toItem: containerView,
                                                           attribute: NSLayoutConstraint.Attribute.bottom,
                                                           multiplier: 1,
                                                           constant: -padding))

        }
        else {
            
            containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(padding)-[accessoryView]-\(padding)-[label]-\(padding)-|",
                options: [],
                metrics: nil,
                views: viewsDictionary))
            
            // Align accessoryView center with label center on the X axis
            containerView.addConstraint(NSLayoutConstraint(item: accessoryView,
                                                           attribute: NSLayoutConstraint.Attribute.centerX,
                                                           relatedBy: NSLayoutConstraint.Relation.equal,
                                                           toItem: label,
                                                           attribute: NSLayoutConstraint.Attribute.centerX,
                                                           multiplier: 1,
                                                           constant: 0))
            
            // Leading
            containerView.addConstraint(NSLayoutConstraint(item: label,
                                                           attribute: NSLayoutConstraint.Attribute.leading,
                                                           relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual,
                                                           toItem: containerView,
                                                           attribute: NSLayoutConstraint.Attribute.leading,
                                                           multiplier: 1,
                                                           constant: padding))
            
            containerView.addConstraint(NSLayoutConstraint(item: accessoryView,
                                                           attribute: NSLayoutConstraint.Attribute.leading,
                                                           relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual,
                                                           toItem: containerView,
                                                           attribute: NSLayoutConstraint.Attribute.leading,
                                                           multiplier: 1,
                                                           constant: padding))
            
            // Trailing
            containerView.addConstraint(NSLayoutConstraint(item: label,
                                                           attribute: NSLayoutConstraint.Attribute.trailing,
                                                           relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
                                                           toItem: containerView,
                                                           attribute: NSLayoutConstraint.Attribute.trailing,
                                                           multiplier: 1,
                                                           constant: -padding))
            
            containerView.addConstraint(NSLayoutConstraint(item: accessoryView,
                                                           attribute: NSLayoutConstraint.Attribute.trailing,
                                                           relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
                                                           toItem: containerView,
                                                           attribute: NSLayoutConstraint.Attribute.trailing,
                                                           multiplier: 1,
                                                           constant: -padding))
        }
        
        
        parentView.addSubview(containerView)
        Utils.centerViewInSuperview(containerView)

        return containerView
    }
    
    @discardableResult
    open class func showTextOverlay(_ parentView: UIView, text: String) -> UIView  {

        let padding = SwiftOverlaysConfiguration.defaultConfiguration.padding
        let containerView = self.containerView()
        
        let label = self.labelForText(text)
        containerView.addSubview(label)
        
        let viewsDictionary = ["label": label]
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(padding)-[label]-\(padding)-|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: viewsDictionary))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-\(padding)-[label]-\(padding)-|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: viewsDictionary))
        
        parentView.addSubview(containerView)
        Utils.centerViewInSuperview(containerView)

        return containerView
    }
    
    open class func showProgressOverlay(_ parentView: UIView, text: String) -> UIView  {
        let pv = UIProgressView(progressViewStyle: .default)
        
        return showGenericOverlay(parentView, text: text, accessoryView: pv, horizontalLayout: false)
    }
    
    open class func removeAllOverlaysFromView(_ parentView: UIView) {
        parentView.subviews
            .filter { $0.tag == containerViewTag }
            .forEach { $0.removeFromSuperview() }
    }
    
    open class func updateOverlayText(_ parentView: UIView, text: String) {
        if let overlay = parentView.viewWithTag(containerViewTag) {
            overlay.subviews.compactMap { $0 as? UILabel }.first?.text = text
        }
    }
    
    open class func updateOverlayProgress(_ parentView: UIView, progress: Float) {
        if let overlay = parentView.viewWithTag(containerViewTag) {
            overlay.subviews.compactMap { $0 as? UIProgressView }.first?.progress = progress
        }
    }
    
    // MARK: Status bar notification
    
    open class func showOnTopOfStatusBar(_ notificationView: UIView, duration: TimeInterval, animated: Bool = true) {
        if bannerWindow == nil {
            bannerWindow = UIWindow()
            bannerWindow!.windowLevel = UIWindow.Level.statusBar + 1
            bannerWindow!.backgroundColor = UIColor.clear
        }

        // TODO: use autolayout instead
        // Ugly, but works
        let topHeight = UIApplication.shared.statusBarFrame.size.height
            + UINavigationController().navigationBar.frame.height

        let height = max(topHeight, 64)
        let width = UIScreen.main.bounds.width

        let frame = CGRect(x: 0, y: 0, width: width, height: height)

        bannerWindow!.frame = frame
        bannerWindow!.isHidden = false
        
        let selector = #selector(closeNotificationOnTopOfStatusBar)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        notificationView.addGestureRecognizer(gestureRecognizer)
        
        bannerWindow!.addSubview(notificationView)

        if animated {
            notificationView.frame = frame.offsetBy(dx: 0, dy: -frame.height)
            bannerWindow!.layoutIfNeeded()

            // Show appearing animation, schedule calling closing selector after completed
            UIView.animate(withDuration: SwiftOverlaysConfiguration.defaultConfiguration.bannerDissapearAnimationDuration, animations: {
                let frame = notificationView.frame
                notificationView.frame = frame.offsetBy(dx: 0, dy: frame.height)
            }, completion: { (finished) in
                self.perform(selector, with: notificationView, afterDelay: duration)
            })
        } else {
            notificationView.frame = frame
            // Schedule calling closing selector right away
            self.perform(selector, with: notificationView, afterDelay: duration)
        }
    }
    
    @objc open class func closeNotificationOnTopOfStatusBar(_ sender: AnyObject) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    
        let notificationView: UIView
        
        if let recognizer = sender as? UITapGestureRecognizer {
            notificationView = recognizer.view!
        }
        else if let view = sender as? UIView {
            notificationView = view
        }
        else {
            return
        }
        
        UIView.animate(withDuration: SwiftOverlaysConfiguration.defaultConfiguration.bannerDissapearAnimationDuration,
                       animations: {
                          let frame = notificationView.frame
                          notificationView.frame = frame.offsetBy(dx: 0, dy: -frame.height)
                       },
                       completion: { finished in
                          notificationView.removeFromSuperview()
                          bannerWindow?.isHidden = true
                       })
    }
    
    // MARK: - Private class methods -
    
    fileprivate class func containerView() -> UIView {
        let containerView = UIView()
        containerView.tag = containerViewTag
        containerView.layer.cornerRadius = SwiftOverlaysConfiguration.defaultConfiguration.cornerRadius
        containerView.backgroundColor = SwiftOverlaysConfiguration.defaultConfiguration.backgroundColor
        return containerView
    }
    
    fileprivate class func activityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: SwiftOverlaysConfiguration.defaultConfiguration.activityIndicatorViewStyle)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }
    
    fileprivate class func labelForText(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = SwiftOverlaysConfiguration.defaultConfiguration.font
        label.textColor = SwiftOverlaysConfiguration.defaultConfiguration.textColor
        label.textAlignment = SwiftOverlaysConfiguration.defaultConfiguration.textAlignment
        label.lineBreakMode = SwiftOverlaysConfiguration.defaultConfiguration.lineBreakMode
        
        label.sizeToFit()
        
        return label
    }
    
    fileprivate class func addWindowBlocker(_ window: UIWindow) -> UIView {
        let blocker = UIView(frame: window.bounds)
        blocker.backgroundColor = SwiftOverlaysConfiguration.defaultConfiguration.blockerBackgroundColor
        blocker.tag = containerViewTag
        
        blocker.translatesAutoresizingMaskIntoConstraints = false
        
        window.addSubview(blocker)
        
        let viewsDictionary = ["blocker": blocker]
        
        // Add constraints to handle orientation change
        let constraintsV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[blocker]-0-|",
                                                          options: [],
                                                          metrics: nil,
                                                          views: viewsDictionary)
        
        let constraintsH = NSLayoutConstraint.constraints(withVisualFormat: "|-0-[blocker]-0-|",
                                                          options: [],
                                                          metrics: nil,
                                                          views: viewsDictionary)
        
        window.addConstraints(constraintsV + constraintsH)
        
        return blocker
    }
}

internal extension UIWindow {
    
    static func visibleWindow() -> UIWindow {
        var visibleWindow = UIApplication.shared.keyWindow
        
        if visibleWindow == nil {
            visibleWindow = UIApplication.shared.delegate!.window!!
        }
        
        return visibleWindow!
    }
    
}
