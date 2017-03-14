//
//  DJLMarqueeView.m
//  DJLMarquee
//
//  Created by EDZ on 2017/3/13.
//  Copyright © 2017年 EDZ. All rights reserved.
//

#import "DJLMarqueeView.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
//间隔
#define WordSpace 10
#define WordFont 14

@implementation DJLMarqueeView
{
    NSInteger _showIndex;
    NSTimer* _timer;
    CGFloat _height;
    BOOL _timerStar;
}
#pragma mark 构造方法

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _height = frame.size.height;
        _showIndex = 0;
        self.clipsToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blueColor].CGColor;
    }
    return self;
}
#pragma mark control
/**
 计算字符串宽度

 @param value 字符串
 @param fontSize 字符串尺寸
 @param height 高度
 @return 宽度
 */
- (float)widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    CGSize titleSize = [value boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return titleSize.width;
}

/**
 添加新的数据源

 @param str 字符串
 */
-(void)addNewItemWithStr:(NSString *)str
{
    NSMutableArray* arr = [[NSMutableArray alloc] initWithArray:self.dataSource];
    [arr addObject:str];
    self.dataSource = arr;
    //如果是不循环的跑马灯，则需要重新开启跑马灯
    if (!_timerStar) {
        _showIndex = self.dataSource.count-1;
        [self addNewLabel];
        [_timer setFireDate:[NSDate distantPast]];
        _timerStar = YES;
    }
}
/**
 创建label

 @param str 字符串
 @return 返回label
 */
- (UILabel*)getLabelWithString:(NSString*)str
{
    CGFloat width = [self widthForString:str fontSize:WordFont andHeight:_height];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, width, _height)];
    label.font = [UIFont systemFontOfSize:WordFont];
    if ([self.delegate respondsToSelector:@selector(marqueeLabelAttrWithStr:index:)]) {
        label.attributedText = [self.delegate marqueeLabelAttrWithStr:str index:_showIndex];
    }else{
        label.text = str;
    }
    return label;
}
#pragma mark 开启跑马灯相关
/**
 开启跑马灯
 */
- (void)starMarQuee
{
    //开始添加label显示
    [self addSubview:[self getLabelWithString:self.dataSource[_showIndex]]];
    //开启定时器
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeLabelFrame) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    [_timer setFireDate:[NSDate distantPast]];
    _timerStar = YES;
}
/**
 添加新的label
 */
- (void)addNewLabel
{
    //判断是否需要继续添加新的label
    if (_showIndex >= self.dataSource.count) {
        if (self.replace == DJLMarqueeReplaceTypeReplaceWord)
            _showIndex = 0;
        else
            return;
    }
    //加入新的label
    [self addSubview:[self getLabelWithString:self.dataSource[_showIndex]]];
}
#pragma mark 计时器
- (void)changeLabelFrame
{
    //通过计时器来修改所有子标签的frame
    NSArray* subViewArray = self.subviews;
    for (int i = 0; i < subViewArray.count; i ++) {
        UILabel* label = subViewArray[i];
        CGRect newFrame = label.frame;
        newFrame.origin.x--;
        label.frame = newFrame;
    }
    //获取第一个标签，判断位置
    UILabel* firLabel = [subViewArray firstObject];
    if (firLabel.frame.origin.x < -firLabel.frame.size.width) {
        //如果超出屏幕，移除label
        [firLabel removeFromSuperview];
        //移除所有视图后，关闭定时器
        if (self.subviews.count == 0) {
            [_timer setFireDate:[NSDate distantFuture]];
            _timerStar = NO;
            _showIndex = 0;
            if (self.replace == DJLMarqueeReplaceTypeReplaceAll)
                [self starMarQuee];
            return;
        }
    }
    //获取最后一个标签，判断是否已经全部显示
    UILabel* lastLabel = [subViewArray lastObject];
    if (self.frame.size.width - lastLabel.frame.origin.x >= lastLabel.frame.size.width+WordSpace) {
        //添加新的标签
        _showIndex++;
        [self addNewLabel];
    }
}

@end
