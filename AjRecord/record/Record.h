//
//  Record.h
//  record
//
//  Created by anjun on 6/20/14.
//  Copyright (c) 2014 anjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "RingBuffer.h"
#import "AudioFileWriter.h"
#import "AudioFileReader.h"

@interface Record : NSObject<AVAudioRecorderDelegate>{
    
}
@property (nonatomic, strong) Novocaine *audioManager;
@property (nonatomic, strong) AudioFileReader *fileReader;
@property (nonatomic, strong) AudioFileWriter *fileWriter;

@property(nonatomic,strong)NSURL *recordedFile;
@property (nonatomic) BOOL isRecording;
@property(nonatomic,strong) AVAudioPlayer *player;
@property(nonatomic,strong) AVAudioRecorder *recorder;

-(void)novocaineWriteFile;
+(Record*)shared;
@end
