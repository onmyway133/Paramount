//
//  FTGParamount.h
//  FTGParamountDemo
//
//  Created by Khoa Pham on 8/27/14.
//  Copyright (c) 2014 Fantageek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FTGParamountActionBlock)();

@interface FTGParamount : NSObject

+ (void)show;
+ (void)hide;
+ (void)setActionBlock:(FTGParamountActionBlock)actionBlock;

@end
