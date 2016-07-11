//
//  TableViewController.h
//  AudioRecorder
//
//  Created by Noah Shapiro on 7/8/16.
//  Copyright © 2016 Noah Shapiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recording.h"
#import <AVFoundation/AVFoundation.h>
@interface TableViewController : UITableViewController

@property (strong, nonatomic) AVAudioPlayer* player;

@property (strong, nonatomic) NSMutableArray *otherListOfRecordings;

- (void)play: (Recording *) aRecording;

@end
