//
//  WHCustomActivity.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/13.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHCustomActivity.h"

@interface WHCustomActivity ()

@property (nonatomic, copy) NSString *internalActivityTitle;
@property (nonatomic, strong) UIImage *internalActivityImage;
@property (nonatomic, strong) NSArray *activityItems;
@property (nonatomic, copy) void (^performAction)(NSArray *);

@end

@implementation WHCustomActivity

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image performAction:(void (^)(NSArray *))performAction {
    if (self = [super init]) {
        self.internalActivityTitle = title;
        self.internalActivityImage = image;
        self.performAction = performAction;
    }
    
    return self;
}

- (UIImage *)activityImage {
    return self.internalActivityImage;
}

- (NSString *)activityTitle {
    return self.internalActivityTitle;
}

- (UIActivityType)activityType {
    return @"com.Wormholy.Wormholy-iOS";
}

- (UIActivityCategory)activityCategory {
    return UIActivityCategoryAction;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    self.activityItems = activityItems;
}

- (void)performActivity {
    if (self.performAction) {
        self.performAction(self.activityItems);
    }
    
    [self activityDidFinish:YES];
}

@end
