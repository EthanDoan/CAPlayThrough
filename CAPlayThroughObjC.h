//
//  CAPlayThroughObjC.h
//  CAPlayThrough
//
//  Created by Hsiu Jesse on 1/17/15.
//
//

#include <CoreAudio/CoreAudio.h>
#include <AudioToolbox/AudioToolbox.h>
#include <AudioUnit/AudioUnit.h>
#import "CAPlayThroughObjCinterface.h"

// An Objective-C class that needs to be accessed from C++
@interface CAPlayThroughObjC : NSObject
{
    AudioBufferList *abl;
    NSMutableData *mutableData;
    Byte *byteData;// = (Byte*) malloc(l);
    Byte *byteData2;// = (Byte*) malloc(l);
    
    bool already_init;
}
// The Objective-C member function you want to call from C++
- (NSData *) encodeAudioBufferList:(AudioBufferList *)abl;
- (AudioBufferList *) decodeAudioBufferList: (NSData *) data;
@end
