//
//  VolumnBar.h
//  NightClubFlash
//
//  Created by Le Hai Nam on 6/18/16.
//  Copyright © 2016 FlySoFast. All rights reserved.
//

#import "CustomXibControl.h"
#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface VolumeBar : CustomXibControl

@property(assign, nonatomic) IBInspectable float minValue;
@property(assign, nonatomic) IBInspectable float maxValue;
@property(assign, nonatomic) float value;

@property(assign, nonatomic) IBInspectable float stop1;

@property(assign, nonatomic) IBInspectable float stop2;

@property(assign, nonatomic) IBInspectable float stop3;

@property(assign, nonatomic) IBInspectable float stop4;


@property(weak, nonatomic) IBOutlet UIImageView *trackBar;
@property(weak, nonatomic) IBOutlet UIImageView *trackBarHighLight;

- (void)updateTrackHighlight:(float)value forcedShow:(BOOL)forced;


@end
