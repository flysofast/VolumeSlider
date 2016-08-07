//
//  ViewController.m
//  CustomControl
//
//  Created by Le Hai Nam on 7/12/16.
//  Copyright © 2016 FlySoFast. All rights reserved.
//

#import "ViewController.h"
#import "EZMicrophone.h"
@interface ViewController () <EZMicrophoneDelegate> 
@property(nonatomic, strong) EZMicrophone *microphone;

@end
@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(prepareForAudioRecording)
   name:UIApplicationDidBecomeActiveNotification
   object:nil];

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (IBAction)valueChanged:(id)sender {
  NSLog(@"Control value: %f",_volumeBar.value);
}

-(void)prepareForAudioRecording{
  //
  // Setup the AVAudioSession. EZMicrophone will not work properly on iOS
  // if you don't do this!
  //
  AVAudioSession *session = [AVAudioSession sharedInstance];
  NSError *error;
  [session setCategory:AVAudioSessionCategoryPlayAndRecord
           withOptions:AVAudioSessionCategoryOptionMixWithOthers

                 error:&error];

  if (error) {
    NSLog(@"Error setting up audio session category: %@",
          error.localizedDescription);
  }
  [session setActive:YES error:&error];
  if (error) {
    NSLog(@"Error setting up audio session active: %@",
          error.localizedDescription);
  }


  // Juts to make sure the microphone's delegates are not being called multiple times
  if(self.microphone){
    [self.microphone stopFetchingAudio];
  }

  //
  // Create the microphone
  //
  self.microphone = [EZMicrophone microphoneWithDelegate:self];

  NSArray *inputs = [EZAudioDevice inputDevices];

  for (int i = 0; i < inputs.count; i++) {
    EZAudioDevice *device = inputs[i];

    //Use the back microphone
//    EZAudioDevice *device = inputs[i];
    if ([device.name containsString:@"Back"]) {
      [self.microphone setDevice:device];
      break;
    }

    [self.microphone setDevice:inputs[0]];
  }

  //
  // Override the output to the speaker. Do this after creating the
  // EZAudioPlayer
  // to make sure the EZAudioDevice does not reset this.
  //

  [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                             error:&error];

  if (error) {
    NSLog(@"Error overriding output to the speaker: %@",
          error.localizedDescription);
  }

  //
  // Start the microphone
  //
  [self.microphone startFetchingAudio];

}

#pragma mark - Delegates
- (void)microphone:(EZMicrophone *)microphone
  hasAudioReceived:(float **)buffer
    withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {

  float buf = *buffer[0];
  //  NSLog(@"%lf",*buffer[0]);

  if (buf >= _volumeBar.value) {
    [self.volumeBar updateTrackHighlight:fabs(buf) forcedShow:YES];

  }

  [self.volumeBar updateTrackHighlight:fabs(buf) forcedShow:NO];
}

@end
