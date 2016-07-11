//
//  ViewController.m
//  AudioRecorder
//
//  Created by Noah Shapiro on 7/6/16.
//  Copyright © 2016 Noah Shapiro. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"
@interface ViewController ()

@end

@implementation ViewController

@synthesize currentRecording;

@synthesize recorder;


-(ViewController*) initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if(self){
    self.listOfRecordings = [[NSMutableArray alloc] init];
    
    
  }
  return self;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  TableViewController* tvc = (TableViewController*)segue.destinationViewController;
  tvc.otherListOfRecordings = self.listOfRecordings;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"RecordingStudio.jpg"]]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)myStartButton:(id)sender
{
  
  //need to make as sesssion to allow recording to be made
  //set currentRecording to new Recording
  //insert currentRecording into recordingList
  //need to start progress bar
  // * set up a recording session
  // * also need a timer in order to update the progressView (eventually expire the recording session)
  

    AVAudioSession* recordingSession = [AVAudioSession sharedInstance];
    NSError* err = nil;
    [recordingSession setCategory: AVAudioSessionCategoryRecord error: &err];
    if(err){
      NSLog(@"recordingSession: %@ %ld %@",
            [err domain], [err code], [[err userInfo] description]);
      return;
    }
    err = nil;
    [recordingSession setActive:YES error:&err];
    if(err){
      NSLog(@"recordingSession: %@ %ld %@",
            [err domain], [err code], [[err userInfo] description]);
      return;
    }
    
    NSMutableDictionary* recordingSettings = [[NSMutableDictionary alloc] init];
    
    [recordingSettings setValue:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    
    [recordingSettings setValue:@44100.0 forKey:AVSampleRateKey];
    
    [recordingSettings setValue:@1 forKey:AVNumberOfChannelsKey];
    
    [recordingSettings setValue:@16 forKey:AVLinearPCMBitDepthKey];
    
    [recordingSettings setValue:@(NO) forKey:AVLinearPCMIsBigEndianKey];
    
    [recordingSettings setValue:@(NO) forKey:AVLinearPCMIsFloatKey];
    
    [recordingSettings setValue:@(AVAudioQualityHigh)
                         forKey:AVEncoderAudioQualityKey];
    
    
    NSDate* now = [NSDate date];
    
    self.currentRecording = [[Recording alloc] initWithDate: now];
    [self.listOfRecordings addObject: self.currentRecording];
    
    NSLog(@"%@",self.currentRecording);
    
    err = nil;
    
    self.recorder = [[AVAudioRecorder alloc]
                     initWithURL:self.currentRecording.url
                     settings:recordingSettings
                     error:&err];
    
    if(!self.recorder){
      NSLog(@"recorder: %@ %ld %@",
            [err domain], [err code], [[err userInfo] description]);
      UIAlertController* alert = [UIAlertController
                                  alertControllerWithTitle:@"Warning"
                                  message:[err localizedDescription]
                                  preferredStyle:UIAlertControllerStyleAlert];
      
      UIAlertAction* defaultAction = [UIAlertAction
                                      actionWithTitle:@"OK"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action) {}];
      
      [alert addAction:defaultAction];
      [self presentViewController:alert animated:YES completion:nil];
      
      return;
    }
    
    //prepare to record
    [self.recorder setDelegate:self];
    [self.recorder prepareToRecord];
    self.recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = recordingSession.inputAvailable;
    if( !audioHWAvailable ){
      UIAlertController* cantRecordAlert = [UIAlertController
                                            alertControllerWithTitle:@"Warning"
                                            message:@"Audio input hardware not available."
                                            preferredStyle:UIAlertControllerStyleAlert];
      
      UIAlertAction* defaultAction = [UIAlertAction
                                      actionWithTitle:@"OK"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action) {}];
      
      [cantRecordAlert addAction:defaultAction];
      [self presentViewController:cantRecordAlert animated:YES completion:nil];
      
      
      return;
    }
    
    // start recording
    [recorder recordForDuration:(NSTimeInterval)5];
    
    self.progressBarStatusLabel.text = @"Recording...";
    self.audioProgressBar.progress = 0.0;
    self.timer = [NSTimer
                  scheduledTimerWithTimeInterval:0.01
                  target:self
                  selector:@selector(handleTimer)
                  userInfo:nil
                  repeats:YES];
  

  
  Recording* r = [[Recording alloc] initWithDate:[NSDate date]];
  self.currentRecording = r;
  
  
  
}
 -(void) handleTimer
{
  
  NSLog(@"yoohoo");
  float n = self.audioProgressBar.progress;
  [self.audioProgressBar setProgress: (n + 0.002)  animated: YES];
  
 if (self.audioProgressBar.progress == 1.0)
 {
   [self.listOfRecordings addObject: self.currentRecording];
   [self.listOfRecordings addObject: @"Flurp"];
 }
  //need to have a method that updates the progress bar ever so much that after 5 seconds
  //the progress view will complete;
  
}



- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
  NSLog (@"audioRecorderDidFinishRecording:successfully:");
  [self.timer invalidate];
  self.progressBarStatusLabel.text = @"Stopped";
  self.audioProgressBar.progress = 1.0;
  
  if([[NSFileManager defaultManager] fileExistsAtPath: self.currentRecording.path]){
    NSLog(@"File exists");
  }else{
    NSLog(@"File does not exist");
  }
  
}

- (IBAction)myStopButton:(id)sender
{
  
  [self.recorder stop];
  
  [self.timer invalidate];
  self.progressBarStatusLabel.text = @"Stopped";
  self.audioProgressBar.progress = 1.0;
  
  if([[NSFileManager defaultManager] fileExistsAtPath: self.currentRecording.path]){
    NSLog(@"File exists");
    
  }else{
    NSLog(@"File does not exist");
  }

  
  //1. Turn off the timer
  //2. Take down the recording session (cleanUp)
  //3. setCurrentRecording to Nil
  //4. also need to stop and reset the progress bar
  // look at github for this method^^
  
  //archiving happens when you to stop the app
  //unarchiving happens when you start it
  
 
}
//need a new method didFinish
/*
-(void) didFinish
{
  //1. Turn off timer for progressView
  //2. clean up session
  
  self.currentRecording = nil;
  
  NSMutableArray* startingArray;
  if(startingArray == nil){
    startingArray = [[NSMutableArray alloc] init];
  }
  [startingArray addObject: @"cat"];
  [startingArray addObject: @"dog"];
  [startingArray addObject: @"sheep"];
  [startingArray addObject: @"snake"];
  [startingArray addObject: @"pig"];
  [startingArray addObject: @"llama"];
  [startingArray addObject: @"horse"];
  [startingArray addObject: @"tiger"];
  
  NSLog(@"%@", startingArray);
  for(NSString* s in startingArray){
   NSLog(@"%@", s);
   }
  
  NSString* archive = [NSString stringWithFormat:@"%@/Documents/arrayArchive", NSHomeDirectory()];
  [NSKeyedArchiver archiveRootObject: startingArray toFile: archive];
  
  assert([[NSFileManager defaultManager] fileExistsAtPath: archive]);
  
  archive = [NSString stringWithFormat:@"%@/Documents/arrayArchive", NSHomeDirectory()];
  
  
  NSMutableArray *secondArray;
  if([[NSFileManager defaultManager] fileExistsAtPath: archive]){
    secondArray = [NSKeyedUnarchiver unarchiveObjectWithFile:archive];
    [[NSFileManager defaultManager] removeItemAtPath:archive error:nil];
  }else{
    // Doesn't exist!
    NSLog(@"No file to open!!");
    exit(1);
  }
  
  NSLog(@"%@", secondArray);
  
  Person *p = [[Person alloc] init];
  p.weightInKG = @42;
  p.heightInM = @10;
  NSLog(@"%@", [p description]);
  
  archive = [NSString stringWithFormat:@"%@/Documents/personArchive", NSHomeDirectory()];
  
  [NSKeyedArchiver archiveRootObject: p toFile: archive];
  
  assert([[NSFileManager defaultManager] fileExistsAtPath: archive]);
  
  Person* otherPerson;
  if([[NSFileManager defaultManager] fileExistsAtPath: archive]){
    otherPerson = [NSKeyedUnarchiver unarchiveObjectWithFile:archive];
    [[NSFileManager defaultManager] removeItemAtPath:archive error:nil];
  }else{
    // Doesn't exist!
    NSLog(@"No file to open!!");
    exit(1);
  }
  
  NSLog(@"%@", [otherPerson description]);
  
  NSMutableArray* tenPeople = [[NSMutableArray alloc] init];
  for(int i = 0; i < 10; i++){
    int h = rand( ) % 100;
    int w = rand( ) % 50;
    Person *mysteryPerson = [[Person alloc] init];
    mysteryPerson.weightInKG = @(w);
    mysteryPerson.heightInM = @(h);
    [tenPeople addObject: mysteryPerson];
  }
  NSLog(@"%@", tenPeople);
  
  archive = [NSString stringWithFormat:@"%@/Documents/tenPeopleArchive", NSHomeDirectory()];
  
  [NSKeyedArchiver archiveRootObject: self.listOfRecordings toFile: archive];
  
  assert([[NSFileManager defaultManager] fileExistsAtPath: archive]);
  
  NSMutableArray* theOtherTenPeople;
  if([[NSFileManager defaultManager] fileExistsAtPath: archive]){
    theOtherTenPeople = [NSKeyedUnarchiver unarchiveObjectWithFile:archive];
    [[NSFileManager defaultManager] removeItemAtPath:archive error:nil];
  }else{
    // Doesn't exist!
    NSLog(@"No file to open!!");
    exit(1);
  }
  
  NSLog(@"%@", theOtherTenPeople);
  
}
return 0;
}



  //3. set currentRecording to nil
  //4. Reset progressView

}
*/
@end









