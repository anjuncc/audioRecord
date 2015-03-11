//
//  Record.m
//  record
//
//  Created by anjun on 6/20/14.
//  Copyright (c) 2014 anjun. All rights reserved.
//

#import "Record.h"
static Record* _shared;

@interface Record()
@property (nonatomic, assign) RingBuffer *ringBuffer;
@end
@implementation Record

-(void)novocaineWriteFile{
    __weak Record * wself = self;
    
    self.ringBuffer = new RingBuffer(32768, 2);
    self.audioManager = [Novocaine audioManager];

    NSURL *outputFileURL = [self genFile];
    NSLog(@"URL: %@", outputFileURL);
    
    self.fileWriter = [[AudioFileWriter alloc]
                       initWithAudioFileURL:outputFileURL
                       samplingRate:self.audioManager.samplingRate
                       numChannels:self.audioManager.numInputChannels];
    
    __block int counter = 0;
    self.audioManager.inputBlock = ^(float *data, UInt32 numFrames, UInt32 numChannels) {
        [wself.fileWriter writeNewAudio:data numFrames:numFrames numChannels:numChannels];
        counter += 1;
        if (counter > 27132) { // roughly 5 seconds of audio
            wself.audioManager.inputBlock = nil;
            [wself.fileWriter stop];
            [wself novocaineWriteFile];
        }
    };
    
    // START IT UP YO
    [self.audioManager play];
}

+(Record*)shared{
    if (!_shared) {
        _shared = [Record new];
    }
    return _shared;
}

-(NSURL*)genFile{
  
    NSDateFormatter *dfmt = [NSDateFormatter new];
    dfmt.dateFormat = @"YMMddHHmm";
    NSString*datestring=   [dfmt stringFromDate:[NSDate new]];
    NSString*docment=  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString*filepath =[docment stringByAppendingPathComponent:datestring];
    NSString*ff = [NSString stringWithFormat:@"%@%@",filepath,@".m4a"];
    _recordedFile = [NSURL fileURLWithPath:ff];
    NSLog(@"_recordedFile:%@",_recordedFile);
    return [NSURL fileURLWithPath:ff];
}
@end
