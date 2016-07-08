//
//  ViewController.h
//  AudioRecorder
//
//  Created by Noah Shapiro on 7/6/16.
//  Copyright © 2016 Noah Shapiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recording.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController : UIViewController <AVAudioPlayerDelegate>

@property AVAudioSession* recordingSession;

@property (strong, nonatomic)AVAudioRecorder* recorder;

@property (strong, nonatomic) NSTimer* timer;

@property (strong, nonatomic) Recording* currentRecording;

@property (strong, nonatomic) NSMutableArray* listOfRecordings;


@property (strong, nonatomic) IBOutlet UIProgressView *audioProgressBar;


@property (strong, nonatomic) IBOutlet UILabel *progressBarStatusLabel;

//need to add a gesture recognizer swipe from the left
//gesture recognizers allow you to understand what your swipe, pinch, tap, hold means
//initWithCoder makes a new Array if one is not ofund on the system
- (IBAction)myStartButton:(id)sender;

- (IBAction)myStopButton:(id)sender;

 -(void) handleTimer;

@end

