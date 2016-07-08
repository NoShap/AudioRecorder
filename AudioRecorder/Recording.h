//
//  Recording.h
//  AudioRecorder
//
//  Created by Noah Shapiro on 7/6/16.
//  Copyright © 2016 Noah Shapiro. All rights reserved.
//

/* 1) make a plan
 2) start & stop BUTTON_ALT
 3) keep track of recordings
 4) make an array that will hold your recordings
 */

#import <Foundation/Foundation.h>

@interface Recording : NSObject <NSCoding>

@property (strong, nonatomic) NSDate* date;

@property (readonly, nonatomic) NSString* name;



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



