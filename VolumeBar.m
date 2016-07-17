//
//  VolumnBar.m
//  NightClubFlash
//
//  Created by Le Hai Nam on 6/18/16.
//  Copyright © 2016 FlySoFast. All rights reserved.
//

#import "VolumeBar.h"
@interface VolumeBar () <UIGestureRecognizerDelegate> {
  double timestamp;
  UIButton *btStop1;
  UIButton *btStop2;
  UIButton *btStop3;
  UIButton *btStop4;
  UIImageView *thumb;

  BOOL isInitiated;
}
@end
@implementation VolumeBar
- (void)drawRect:(CGRect)rect {

  //Prevent doing this twice
  if (isInitiated) {
    return;
  }

  self.value=1;
  self.isActive=YES;
  float thumbHeight = 30;


  UIImage *mark = [UIImage imageNamed:@"trackbarMark"];


  //Add the marks on trackbar
  btStop1 = [self setupMarkwithNormalImage:mark
                                   forMark:_stop1
                                    action:@selector(markClicked:)];
  btStop2 = [self setupMarkwithNormalImage:mark
                                   forMark:_stop2
                                    action:@selector(markClicked:)];
  btStop3 = [self setupMarkwithNormalImage:mark
                                   forMark:_stop3
                                    action:@selector(markClicked:)];
  btStop4 = [self setupMarkwithNormalImage:mark
                                   forMark:_stop4
                                    action:@selector(markClicked:)];

  // The y position value to create a nice start animation of translating from the bottom of the screen
  thumb =
      [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 40, thumbHeight * 2)];


  thumb.image = [UIImage imageNamed:@"trackbarThumb"];

  [self addSubview:thumb];

  isInitiated = YES;

  [btStop1 sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)setupMarkwithNormalImage:(UIImage *)image1
                               forMark:(float)stop
                                action:(SEL)action {

  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button addTarget:self
                action:action
      forControlEvents:UIControlEventTouchUpInside];

  [button setImage:image1 forState:UIControlStateNormal];


  int inset = 15;
  [button setContentEdgeInsets:UIEdgeInsetsMake(inset, inset, inset, inset)];

  float ratio = self.trackBar.bounds.size.height / image1.size.height;

  button.frame = CGRectMake(0, 0, image1.size.width * ratio + inset * 2,
                            image1.size.height * ratio + inset * 2);

  [button setCenter:CGPointMake(stop * self.trackBar.bounds.size.width,
                                self.trackBar.center.y)];

  [self addSubview:button];

  return button;
}

- (void)loadConfig {
  [super loadConfig];
  timestamp = CFAbsoluteTimeGetCurrent();

  UIPanGestureRecognizer *panRecognizer =
      [[UIPanGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handlePan:)];
  [self addGestureRecognizer:panRecognizer];
  isInitiated = NO;
}

#pragma mark - Mark click
- (void)markClicked:(id)sender {
  UIButton *bt = (UIButton *)sender;

  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    [UIView animateWithDuration:0.2
        animations:^{
          [thumb setCenter:bt.center];
        }
        completion:^(BOOL finished) {
          [self updateValue];
        }];
  }];

}
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
  CGPoint translation = [recognizer translationInView:self];
  float xValue = MIN(MAX(thumb.center.x + translation.x , 0), self.bounds.size.width );

  thumb.center = CGPointMake(xValue, thumb.center.y);


  [self updateValue];

  [recognizer setTranslation:CGPointMake(0, 0) inView:self];
}

- (void)updateValue {
  self.value = (thumb.center.x / self.bounds.size.width ) * self.maxValue;
  [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)updateTrackHighlight:(float)value forceShow:(BOOL)force {

  if (!_isActive) {
    return;
  }
  
  double ts = CFAbsoluteTimeGetCurrent();
  //  double aa=CFAbsoluteTimeGetCurrent()-timestamp;
  //
  //  NSLog(@"%f",value);
  if (force || CFAbsoluteTimeGetCurrent() - timestamp > 0.1) {
    timestamp = ts;
  } else {
    return;
  }

  value = value / _maxValue;

  // Create a mask layer and the frame to determine what will be visible in the
  // view.
  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];

  CGFloat thumbMidXInHighlightTrack = self.trackBar.frame.size.width * value;
  CGRect maskRect = CGRectMake(0, 0, thumbMidXInHighlightTrack,
                               self.trackBar.frame.size.height);

  // Create a path and add the rectangle in it.
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddRect(path, nil, maskRect);

  // Set the path to the mask layer.
  [maskLayer setPath:path];

  // Release the path since it's not covered by ARC.
  CGPathRelease(path);

  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    // Set the mask of the view.
    self.trackBarHighLight.layer.mask = maskLayer;
  }];
}
@end
