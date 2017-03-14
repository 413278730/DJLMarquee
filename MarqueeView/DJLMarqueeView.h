//
//  DJLMarqueeView.h
//  DJLMarquee
//
//  Created by EDZ on 2017/3/13.
//  Copyright © 2017年 EDZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DJLMarqueeReplaceType) {
    DJLMarqueeReplaceTypeNone = 0,  //不重复显示
    DJLMarqueeReplaceTypeReplaceAll ,  //重复所有信息
    DJLMarqueeReplaceTypeReplaceWord //不间断重复文字显示
};

@protocol DJLMarqueeViewDelegate <NSObject>
/**
 获取每一个label对应的样式

 @param str 字符串
 @param index 对应label下标
 @return att
 */
- (NSMutableAttributedString*)marqueeLabelAttrWithStr:(NSString*)str index:(NSInteger)index;

@end

@interface DJLMarqueeView : UIView
/**
 是否重复
 */
@property (nonatomic,assign) DJLMarqueeReplaceType replace;
/**
 显示数据源
 */
@property (nonatomic,strong) NSArray* dataSource;
/**
 委托对象
 */
@property (nonatomic,weak) id<DJLMarqueeViewDelegate> delegate;
/**
 开始跑马灯
 */
- (void)starMarQuee;
/**
 添加新的数据源

 @param str 显示字符串
 */
- (void)addNewItemWithStr:(NSString*)str;
@end
