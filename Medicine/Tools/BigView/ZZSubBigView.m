//
//  ZZSubBigView.m
//  uliaobao
//
//  Created by wisdom on 16/6/21.
//  Copyright © 2016年 CGC. All rights reserved.
//

#import "ZZSubBigView.h"

@interface ZZSubBigView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong)UIImageView *urlImageView;
@property (nonatomic, strong)UIImageView *subViewImage;
@property (nonatomic, copy) NSString* imgUrl;
@end

@implementation ZZSubBigView

- (instancetype)initWithdelegate:(id<ZZSubBigViewDelegate>)delegate withframe:(CGRect)frame withURL:(NSString *)url{
    if (self=[super initWithFrame:frame]) {
        self.delegate=delegate;
        self.imgUrl=url;
        self.backgroundColor=[UIColor blackColor];
        [self createView];
    }
    return self;
}


- (void)createView {
    self.myScroll =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT+80)];
    self.myScroll.backgroundColor=[UIColor blackColor];
    self.myScroll.delegate=self;
    self.myScroll.minimumZoomScale=1.0;
    self.myScroll.maximumZoomScale=2.0;
    self.myScroll.bouncesZoom=NO;
    [self centerScrollViewContents];
    [self addSubview:self.myScroll];
    self.urlImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, NSTATUS_H, WIDE, HIGHT - NSTATUS_H - TAB_H)];
    self.urlImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.urlImageView.layer.masksToBounds = YES;
    self.urlImageView.userInteractionEnabled=YES;
    [self.myScroll addSubview:self.urlImageView];
    self.myScroll.contentSize=CGSizeMake(self.urlImageView.bounds.size.width, self.urlImageView.bounds.size.height);
     [self.urlImageView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:[UIImage imageNamed:@"accountPlace"]];
    UITapGestureRecognizer *bacTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bacTap:)];
    bacTap.numberOfTapsRequired = 2;
    bacTap.delegate=self;
    
    [self.myScroll addGestureRecognizer:bacTap];
}

- (void)bacTap:(UITapGestureRecognizer*)tap{
    CGFloat newZoomScale = 1.0f;
    newZoomScale = MAX(newZoomScale, 1.0);
    [self.myScroll setZoomScale:newZoomScale animated:YES];
}


- (void)centerScrollViewContents {
    CGSize boundsSize = self.myScroll.bounds.size;
    CGRect contentsFrame = self.urlImageView.frame;
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f-40;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    self.urlImageView.frame = contentsFrame;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    /**
     *  在中间缩放
     */
    [self centerScrollViewContents];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    [self.delegate stopCollection:self];
    return scrollView.subviews[0];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width*scale, scrollView.frame.size.height*scale-200*scale);
    [self.delegate getScale:self goWith:scale];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
