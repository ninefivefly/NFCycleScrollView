//
//  NFCycleScrollView.swift
//  ymyk
//
//  Created by JIANG PENG CHENG on 2016/11/7.
//  Copyright © 2016年 jiangpengcheng. All rights reserved.
//

import UIKit

open class NFCycleScrollView: UIView, UIScrollViewDelegate {
    
    // 修改pageCtrl样式
    open var mPageCtrl: UIPageControl!
    // pageCtrl是水平居中的，可以修改底部的距离
    open var mPageCtrlBottomOffset: CGFloat = 20 {
        didSet {
            self.mPageCtrlBottomConstraint?.constant = -self.mPageCtrlBottomOffset
        }
    }
    
    private var mTimer: Timer?
    private var mScrollView: UIScrollView!
    private var mPageCtrlBottomConstraint: NSLayoutConstraint?
    
    // 总共多少张图片
    private var mTotalCount: Int = 0
    private var mWidth: CGFloat = 0
    private var mHeight: CGFloat = 0
    private var mTimerInterval: TimeInterval = 4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configView()
    }

    //MARK: - Public Methods
    // 要显示的view，内容可以是，UIView, UIImage, ImageUrl, ImageName
    // D ABCD A
    open func config(views: [Any]?, width: CGFloat, height: CGFloat)  {
        guard let contentViews = views, !(contentViews.isEmpty) else {
            return
        }
        
        //1. 添加view
        //1.1 不支持一个循环对象
        if contentViews.count <= 1 {
            return
        }
        
        //1.2 遍历加载view。构造成D ABCD A
        for (index, obj) in contentViews.enumerated() {
            if index == 0 {
                let firstView = self.viewForObj(obj: contentViews.last!)
                firstView.frame = CGRect(x:0, y: 0, width: width, height: height)
                self.mScrollView.addSubview(firstView)
            } else if (index + 1) == contentViews.count {
                let lastView = self.viewForObj(obj: contentViews.first!)
                lastView.frame = CGRect(x:CGFloat(index+2)*width, y: 0, width: width, height: height)
                self.mScrollView.addSubview(lastView)
            }
            
            let item = self.viewForObj(obj: obj)
            item.frame = CGRect(x: CGFloat(index+1)*width, y: 0, width: width, height: height)
            self.mScrollView.addSubview(item)
        }
        
        //2. 设置基本数据
        self.mTotalCount = contentViews.count
        self.mWidth = width
        self.mHeight = height
        
        self.mScrollView.contentSize = CGSize(width: width * CGFloat(contentViews.count+2), height: height)
        self.mPageCtrl.numberOfPages = self.mTotalCount
        self.scrollToPage(page: 1, animated: false)
        
        //3. 开启定时器
        self.mTimer?.nf_resumeTimerAfterInterval(mTimerInterval)
        return
    }
    
    // 注意：将计数器的repeats设置为YES的时候，self的引用计数会加1。
    // 因此可能会导致self（即viewController）不能release，所以，
    // 必须在viewWillAppear的时候，将计数器timer停止，否则可能会导致内存泄露。
    // 停止计算器
    open func stopTimer() {
        self.mTimer?.invalidate()
        self.mTimer = nil
    }
    
    // 启动定时器
    open func resumeTimer(_ isPause: Bool = false) {
        if !(self.mTimer?.isValid ?? false) {
            self.mTimer = Timer.scheduledTimer(timeInterval: mTimerInterval, target: self, selector: #selector(NFCycleScrollView.animationTimerDidFire), userInfo: nil, repeats: true)
            if isPause {
                self.mTimer?.nf_pauseTimer()
            }
        }
    }
    
    //MARK: - UIScrollView Delegate Methods
    // 当手指滑动时，停止计时器
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.mTimer?.nf_pauseTimer()
    }
    
    // 当手指结束滑动时，启动计算器
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.mTimer?.nf_resumeTimerAfterInterval(mTimerInterval)
    }
    
    /*
     Tells the delegate when a scrolling animation in the scroll view concludes.
     The scroll view calls this method at the end of its implementations of the setContentOffset(_:animated:) and scrollRectToVisible(_:animated:) methods, but only if animations are requested.
     */
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.process(scrollView)
    }
    
    /*
     Tells the delegate that the scroll view has ended decelerating the scrolling movement.
     The scroll view calls this method when the scrolling movement comes to a halt. The isDecelerating property of UIScrollView controls deceleration.
     */
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.process(scrollView)
    }
    
    //MARK: - Private Methods
    internal func viewForObj(obj: Any) -> UIView {
        if let item = obj as? UIImage {
            let imageView = UIImageView(image: item)
            imageView.contentMode = .scaleAspectFill
            return imageView
        } else if let imageName = obj as? String {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFill
            return imageView
        }
        
        return UIView()
    }
    
    internal func scrollToPage(page: Int, animated: Bool) {
        self.mScrollView.setContentOffset(CGPoint(x: mWidth * CGFloat(page), y: 0), animated: animated)
    }
    
    internal func process(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < mWidth {
            // 滚动到了第一张图片
            self.scrollToPage(page: mTotalCount, animated: false)
        }
        
        if (scrollView.contentOffset.x > mWidth * CGFloat(mTotalCount)) {
            // 滚动到了最后一张图片
            self.scrollToPage(page: 1, animated: false)
        }
        
        var pageCount = Int(scrollView.contentOffset.x / mWidth)
        if (pageCount > mTotalCount) {
            pageCount = 0;
        }else if (pageCount == 0){
            pageCount = mTotalCount - 1;
        }else{
            pageCount -= 1
        }
        self.mPageCtrl.currentPage = pageCount
    }
    
    internal func animationTimerDidFire() {
        let pageCount = Int(self.mScrollView.contentOffset.x / mWidth)
        self.scrollToPage(page: pageCount+1, animated: true)
    }
    
    internal func configView() {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
        self.mScrollView = scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        
        let pageCtrl = UIPageControl()
        pageCtrl.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.5)
        pageCtrl.currentPageIndicatorTintColor = UIColor.white
        self.addSubview(pageCtrl)
        self.mPageCtrl = pageCtrl
        pageCtrl.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: pageCtrl, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        let pageCtrlBottomConstraint = NSLayoutConstraint(item: pageCtrl, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -mPageCtrlBottomOffset)
        self.addConstraint(pageCtrlBottomConstraint)
        self.mPageCtrlBottomConstraint = pageCtrlBottomConstraint
      
        self.resumeTimer(true)
    }
}

fileprivate extension Timer {
    
    //暂停
    func nf_pauseTimer() {
        if !self.isValid {
            return
        }
        self.fireDate = Date.distantFuture
    }
    
    //开始
    func nf_resumeTimer() {
        if !self.isValid {
            return
        }
        self.fireDate = Date()
    }
    
    //几秒钟后开始
    func nf_resumeTimerAfterInterval(_ interval:TimeInterval) {
        if !self.isValid {
            return
        }
        self.fireDate = Date.init(timeIntervalSinceNow: interval)
    }
}

