//
//  FlashButton.m
//  NightClubFlash
//
//  Created by Le Hai Nam on 6/16/16.
//  Copyright © 2016 FlySoFast. All rights reserved.
//

#import "CustomXibControl.h"

@implementation CustomXibControl

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self loadConfig];
  }

  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self loadConfig];
  }

  return self;
}

- (void)loadConfig {
  UIView *view = [[[NSBundle bundleForClass:[self class]]
      loadNibNamed:NSStringFromClass([self class])
             owner:self
           options:nil] firstObject];
  [self addSubview:view];
  view.frame = self.bounds;

  

}

@end
