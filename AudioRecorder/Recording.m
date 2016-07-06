//
//  Recording.m
//  AudioRecorder
//
//  Created by Noah Shapiro on 7/6/16.
//  Copyright © 2016 Noah Shapiro. All rights reserved.
//

#import "Recording.h"

@implementation Recording

@synthesize date;

-(Recording*) initWithDate: (NSDate*) aDate
{
  self  = [super init];
  if(self)
  {
    self.date = aDate;
  }
  return self;
}
//Recording* r = [[Recording alloc] initWithDate: [NSDate today]];




-(NSString*) path
{
  NSString* home = NSHomeDirectory();
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyyMMddHHmmss"];
  NSString* dateString = [formatter stringFromDate:self.date];
    return [NSString stringWithFormat:@"%@/Documents/%@.caf", home, dateString];
  }

NSString* p  = r.path; // r.path is on the right side because it is a readonly property
  
  -(NSURL*) url
  {
    return [NSURL URLWithString: r.path]
  }

   //look up how to initialize / declare objects in Objective C
@end

  
 