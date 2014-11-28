//
//  MyView.m
//  水波纹
//
//  Created by sen5labs on 14-8-6.
//  Copyright (c) 2014年 sen5labs. All rights reserved.
//

#import "MyView.h"

#define kCenterX 160
#define kCenterY 220

#define kMargin 115
#define kRadius 6

#define kImagePoint CGPointMake(160 , 220)

@interface MyView()
{
    NSInteger _tag;
    UIButton *_plusBtn;
    UIButton *_minusBtn;
    UIButton *_homeBtn;
    UIButton *_backBtn;
    CALayer *_waveLayer;
    UIImageView *_imageView;
}

@end

@implementation MyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {

        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)];
        [self addGestureRecognizer:longTap];
    }
    return self;
}

#pragma mark 长按手势
- (void)longTap:(UIGestureRecognizer *)recognizer
{

    if (UIGestureRecognizerStateBegan == recognizer.state) {
        
        // 设置整个UI布局
        [self setupUI];
        
    }else if (UIGestureRecognizerStateChanged == recognizer.state){
        
        // 根据位置显示按钮
        CGPoint location = [recognizer locationInView:self];
        
        [self controlBtn:location];
        
    }else if(UIGestureRecognizerStateEnded== recognizer.state){
        
        // 触摸结束，UI消失
        if (_plusBtn ==nil) return;
        _tag = 0;
        [_waveLayer removeFromSuperlayer];
        [_plusBtn removeFromSuperview];
        [_minusBtn removeFromSuperview];
        [_homeBtn removeFromSuperview];
        [_backBtn removeFromSuperview];
        [_imageView removeFromSuperview];
    }

   
}

#pragma mark - 创建四个按钮的共同方法
- (UIButton *)createFunctionBtnWithPoint:(CGPoint)point normal:(NSString *)normal highlight:(NSString *)highlight tag:(NSInteger)index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 35, 35);
    button.center = point;
    [button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlight] forState:UIControlStateHighlighted];
    button.tag = index;
    [self addSubview:button];
    
    return button;
}

#pragma mark - 建立UI布局
- (void)setupUI
{
    if (_tag == 1) return;
    
    _tag = 1;
    
    // 中心位置图
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_press"]];
    imageView.userInteractionEnabled = YES;
    imageView.bounds = CGRectMake(0, 0, 48, 48);
    imageView.center = CGPointMake(kImagePoint.x , kImagePoint.y);
    [self addSubview:imageView];
    _imageView = imageView;
    
    // 上 y -
    _plusBtn = [self createFunctionBtnWithPoint:CGPointMake(kCenterX, kCenterY - kMargin) normal:@"volume+_n" highlight:@"volume+_p" tag:1];
    
    // 下  y +
    _minusBtn = [self createFunctionBtnWithPoint:CGPointMake(kCenterX, kCenterY + kMargin + 2) normal:@"volume_n" highlight:@"volume_p" tag:2];
    
    // 左  x -
    _homeBtn = [self createFunctionBtnWithPoint:CGPointMake(kCenterX - kMargin, kCenterY) normal:@"mainmenu_n" highlight:@"mainmenu_p" tag:3];
    
    // 右 x +
    _backBtn = [self createFunctionBtnWithPoint:CGPointMake(kCenterX + kMargin + 2, kCenterY) normal:@"return_n" highlight:@"return_p" tag:4];
    
    _plusBtn.hidden = YES;
    _minusBtn.hidden = YES;
    _homeBtn.hidden = YES;
    _backBtn.hidden = YES;
    
    CALayer *waveLayer=[CALayer layer];
    waveLayer.frame = CGRectMake(_imageView.center.x-kRadius, _imageView.center.y-kRadius, 12, 12);
    waveLayer.borderColor =[UIColor colorWithRed:2/255.0 green:193/255.0 blue:221/255.0 alpha:1.0f].CGColor;
    waveLayer.borderWidth = 0.1;
    waveLayer.cornerRadius = kRadius;
    [self.layer addSublayer:waveLayer];
    [self scaleBegin:waveLayer];
    _waveLayer = waveLayer;
 
}


#pragma mark - 控制四个方位的按钮显示情况
- (void)controlBtn:(CGPoint)location
{
    [_imageView setCenter:location];
    
    CGFloat x = location.x - kImagePoint.x;
    CGFloat y = location.y - kImagePoint.y;
    
    
     // 执行相应的对应的操作
    if (fabs(x) < 20 && fabs(y) < 20) {
        _plusBtn.hidden = NO;
        _minusBtn.hidden = NO;
        _homeBtn.hidden = NO;
        _backBtn.hidden = NO;
        
    }else if ( fabs(y)>fabs(x) && ( ( y<0 && y/x > 0)||(y<0 && y/x < 0))) {  // 上
        
        NSLog(@"上");
        _plusBtn.hidden = NO;
        _minusBtn.hidden = YES;
        _homeBtn.hidden = YES;
        _backBtn.hidden = YES;
        
    }else if ( fabs(y)>fabs(x)  && ((y>0 && y/x > 0)||(y>0 && y/x < 0))){ // 下
        
        NSLog(@"下");
        _plusBtn.hidden = YES;
        _minusBtn.hidden = NO;
        _homeBtn.hidden = YES;
        _backBtn.hidden = YES;
        
    }else if ( fabs(x)>fabs(y)  && ((x<0 && y/x > 0)||(x<0 && y/x < 0))){ // 左
        
        NSLog(@"左");
        _plusBtn.hidden = YES;
        _minusBtn.hidden = YES;
        _homeBtn.hidden = NO;
        _backBtn.hidden = YES;
        
    }else if ( fabs(x)>fabs(y) && ((x>0 && y/x > 0)||(x>0 && y/x < 0))){  // 右
        
        _plusBtn.hidden = YES;
        _minusBtn.hidden = YES;
        _homeBtn.hidden = YES;
        _backBtn.hidden = NO;
        NSLog(@"右");
    }
}


#pragma mark - 产生圆环效果
- (void)scaleBegin:(CALayer *)aLayer
{
    const float maxScale= 15;
    if (aLayer.transform.m11<maxScale) {
        
        if (aLayer.transform.m11 == 1.0) {
            [aLayer setTransform:CATransform3DMakeScale(1.1, 1.1, 1.0)];
            
        }else{
            [aLayer setTransform:CATransform3DScale(aLayer.transform, 1.1, 1.1, 1.0)];
        }
        [self performSelector:_cmd withObject:aLayer afterDelay:0.02];
        
        if (aLayer.transform.m11 > maxScale) {
        
            _plusBtn.hidden = NO;
            _minusBtn.hidden = NO;
            _homeBtn.hidden = NO;
            _backBtn.hidden = NO;

        }
    }
}


@end
