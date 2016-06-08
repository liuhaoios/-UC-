//
//  ViewController.m
//  生命周期的测试
//
//  Created by cheyipai on 16/6/2.
//  Copyright © 2016年 cheyipai. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Frame.h"

#define   WIN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define   WIN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<UIScrollViewDelegate,UITableViewDataSource>
{
    UIScrollView *mainScrollView;
    
    CGFloat LHoffset;
    
    UIBezierPath *path;
    
    UIView *topView;
    
    CAShapeLayer *layer;
}
@property (nonatomic, strong) CAShapeLayer * circleLayer;
@property (nonatomic, strong) CAShapeLayer * moveCircleLayer;
@property (nonatomic,assign) CGFloat circleY;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.backgroundColor = [UIColor redColor];
    _circleY = 0.0;
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 220)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor  colorWithRed:0.22 green:0.54 blue:0.73 alpha:1];
    
    layer = [CAShapeLayer layer];
    [topView.layer addSublayer:layer];
    
    _circleLayer = [CAShapeLayer layer];
    _circleLayer.fillColor = [UIColor whiteColor].CGColor;
    [topView.layer addSublayer:_circleLayer];
    
    _moveCircleLayer = [CAShapeLayer layer];
    _moveCircleLayer.fillColor = [UIColor colorWithRed:0.22 green:0.54 blue:0.73 alpha:1].CGColor;
    [topView.layer addSublayer:_moveCircleLayer];




    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topView.bottom   , WIN_WIDTH, WIN_HEIGHT - 220)];
    mainScrollView.delegate = self;
    [self.view addSubview:mainScrollView];
    mainScrollView.backgroundColor = [UIColor clearColor];
    
    mainScrollView.contentSize = CGSizeMake(WIN_WIDTH, WIN_HEIGHT);
    
    UIView *inView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 100)];
    inView.backgroundColor = [UIColor yellowColor];
    [mainScrollView addSubview:inView];
    
    
    //table
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, inView.bottom, WIN_WIDTH, WIN_HEIGHT)];
    table.rowHeight = 140;
    table.dataSource = self;
    [mainScrollView addSubview:table];
    

}

- (void)change {
    
    
    path = [UIBezierPath bezierPath];
    //坐下
    [path moveToPoint:CGPointMake(0, topView.height - 80)];
    //左上
    [path addLineToPoint:CGPointMake(0, 0)];
    //右上
    [path addLineToPoint:CGPointMake(WIN_WIDTH, 0)];
    //右下
    [path addLineToPoint:CGPointMake(WIN_WIDTH,topView.height)];
    //左上

    [path addQuadCurveToPoint:CGPointMake(0,topView.height)
                 controlPoint: CGPointMake(WIN_WIDTH / 2, topView.height - LHoffset)];
    layer.path = path.CGPath;
    
    layer.fillColor = [UIColor  colorWithRed:0.22 green:0.54 blue:0.73 alpha:1].CGColor;
    //月牙视图的下层圆，一开始被覆盖掉
    UIBezierPath *pPath = [UIBezierPath bezierPath];
    [pPath addArcWithCenter:CGPointMake(WIN_WIDTH / 2, 220 / 2) radius:10 + _circleY / 4 startAngle:0 endAngle:100 clockwise:1];
    _circleLayer.path = pPath.CGPath;
    
    //月牙视图的上层圆，用来覆盖在上边，随着手势下滑，逐渐移开，呈现出月牙形状
    UIBezierPath * mPath = [UIBezierPath bezierPath];
    [mPath addArcWithCenter:CGPointMake(WIN_WIDTH / 2, 220 / 2 + _circleY) radius:10.2 + _circleY / 4 startAngle:0 endAngle:100 clockwise:1];
    _moveCircleLayer.path = mPath.CGPath;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = mainScrollView.contentOffset.y ;
    
    if (offsetY < 0) {
    
        if (ABS(offsetY) > 150) {
            
            topView.top = offsetY + 150 ;
        } else {
            
            LHoffset = mainScrollView.contentOffset.y;
            topView.top = 0;
            [self change];
            
            _circleY = ABS(LHoffset) *1.7 / 220 * 40;

        }
    }
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    mainScrollView.scrollsToTop  = YES;
    

}

@end
