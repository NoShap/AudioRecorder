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

-(NSString*) description
{
  return [NSString stringWithFormat:@"%@", self.date];
}


-(NSString*) path
{
  NSString* home = NSHomeDirectory();
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyyMMddHHmmss"];
  NSString* dateString = [formatter stringFromDate:self.date];
    return [NSString stringWithFormat:@"%@/Documents/%@.caf", home, dateString];
  }
  
  -(NSURL*) url
  {
    return [NSURL URLWithString: self.path];
  }


- (Recording*)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if(self){
    self.date = [decoder decodeObjectOfClass: [Recording class] forKey: @"date"];
    
  }
  return self;
  
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject: self.date forKey: @"date"];
  
}

-(NSString*)name
{
  return [self.date description];
}

//Recording* r = [[Recording alloc] initWithDate: [NSDate today]];
//NSString* p  = r.path; r.path is on the right side because it is a readonly property



@end

  
 