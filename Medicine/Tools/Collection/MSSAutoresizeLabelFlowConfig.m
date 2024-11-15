//
//  MSSAutoresizeLabelFlowConfig.m
//  MSSAutoresizeLabelFlow
//
//  Created by Mrss on 15/12/26.
//  Copyright © 2015年 expai. All rights reserved.
//

#import "MSSAutoresizeLabelFlowConfig.h"

@implementation MSSAutoresizeLabelFlowConfig

+ (MSSAutoresizeLabelFlowConfig *)shareConfig {
    static MSSAutoresizeLabelFlowConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc]init];
    });
    return config;
}

// default

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentInsets = UIEdgeInsetsMake(10, 10, 10, 2);
        self.lineSpace = 10;
        self.itemHeight = 35;
        self.itemSpace = 10;
        self.itemCornerRaius = 17.5;
        self.itemColor = [UIColor whiteColor];
        self.textMargin = 20;
        self.textColor = COLOR_3B3B3B;
        self.textFont = [UIFont systemFontOfSize:13];
        self.backgroundColor = COLOR_F6F6F6;
    }
    return self;
}

@end
