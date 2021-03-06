//
//  MenuPopController.h
//  haopin
//
//  Created by 朱明科 on 16/3/29.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DidSelectStringBlock)(NSString *string);
@interface MenuPopController : UIViewController
@property(nonatomic,copy)DidSelectStringBlock selectHandler;
@property(nonatomic)NSArray *dataArray;

-(void)setSelectHandler:(DidSelectStringBlock)selectHandler;
@end
