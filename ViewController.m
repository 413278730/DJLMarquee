//
//  ViewController.m
//  DJLMarquee
//
//  Created by EDZ on 2017/3/13.
//  Copyright © 2017年 EDZ. All rights reserved.
//

#import "ViewController.h"
#import "DJLMarqueeView.h"

@interface ViewController ()<DJLMarqueeViewDelegate>

@end

@implementation ViewController
{
    DJLMarqueeView* _marqueeView;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_marqueeView addNewItemWithStr:@"跑马灯4"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _marqueeView = [[DJLMarqueeView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 30)];
    _marqueeView.dataSource = @[@"跑马灯1",@"跑马灯2",@"跑马灯3"];
    _marqueeView.replace = DJLMarqueeReplaceTypeReplaceWord;
    _marqueeView.delegate = self;
    [self.view addSubview:_marqueeView];
    [_marqueeView starMarQuee];
}
#pragma mark DJLMarqueeViewDelegate
-(NSMutableAttributedString *)marqueeLabelAttrWithStr:(NSString *)str index:(NSInteger)index
{
     NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    if (index == 0) {
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,1)];
    }else if(index == 1){
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(1,2)];
    }else{
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(2,2)];
    }
    return attStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
