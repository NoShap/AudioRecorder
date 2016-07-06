//
//  Recording.h
//  AudioRecorder
//
//  Created by Noah Shapiro on 7/6/16.
//  Copyright © 2016 Noah Shapiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recording : NSObject <NSSecureCoding>

@property (strong, nonatomic) NSDate* date;

// always save in ~/Documents/yyyyMMddHHmmss
// we have to save the array of audio recordings in the same file through Object serialization.
@property (readonly, nonatomic) NSString* path;
//look at the corrresponding .path to understand how a method is constructed from the property

@property (readonly, nonatomic) NSURL* url;
// you don’t have to synthesize these because you don’t store these values you just calculate them
//properties have setters and getters, putting readonly takes away the setter
//return an NSURL that represents the path

-(Recording*) initWithDate: (NSDate*) aDate;
//what we want to get to: Recording* r = [[Recording alloc] initWithDate: [NSDate today]]


//also add a description method for debugging and have it print out all of the recording's properties
//as well as a name property of type NSString
@end



