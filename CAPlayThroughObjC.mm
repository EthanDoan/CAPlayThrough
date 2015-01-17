//
//  CAPlayThroughObjC.m
//  CAPlayThrough
//
//  Created by Hsiu Jesse on 1/17/15.
//
//

#import <Foundation/Foundation.h>
#import "CAPlayThroughObjC.h"

@implementation CAPlayThroughObjC

void TransferAudioBuffer (void *self,  AudioBufferList *list)
{
    if(self == Nil)
    {
        self = [[CAPlayThroughObjC alloc]init];
        [(id) self initVariables];
    }
//    @autoreleasepool {
    NSData *tmp =  [(id) self encodeAudioBufferList:list];
//    list = [(id) self decodeAudioBufferList:tmp];
//    return list;
//    }
}
void* initializeInstance(void *self){
    self = [[CAPlayThroughObjC alloc]init];
    [(id)self initVariables];
    return self;
}

-(void)initVariables
{
    if (abl == Nil) {
        abl = (AudioBufferList*) malloc(sizeof(AudioBufferList));
        byteData = (Byte*) malloc(1024); //should maybe be a different value in the future
        byteData2 = (Byte*) malloc(1024);
    }
}

- (NSData *)encodeAudioBufferList:(AudioBufferList *)ablist {
    //NSMutableData *data = [NSMutableData data];
    if(mutableData == nil){
        mutableData = [NSMutableData data];
    } else {
        [mutableData setLength:0];
    }
    
    for (UInt32 y = 0; y < ablist->mNumberBuffers; y++){
        AudioBuffer ab = ablist->mBuffers[y];
        Float32 *frame = (Float32*)ab.mData;
        [mutableData appendBytes:frame length:ab.mDataByteSize];
    }
    return mutableData;
}

- (AudioBufferList *)decodeAudioBufferList:(NSData *)data {
    
    if (data.length > 0) {
        int nc = 2; // This value should be changed once there are more than 2 channels
        
        //AudioBufferList *abl = (AudioBufferList*) malloc(sizeof(AudioBufferList));
        abl->mNumberBuffers = nc;
        
        NSUInteger len = [data length];
        
        //Take the range of the first buffer
        NSUInteger olen = 0;
        // NSUInteger lenx = len / nc;
        NSUInteger step = len / nc;
        int i = 0;
        
        while (olen < len) {
            
            //NSData *d = [NSData alloc];
            NSData *pd = [data subdataWithRange:NSMakeRange(olen, step)];
            NSUInteger l = [pd length];
            NSLog(@"l: %lu",(unsigned long)l);
            //            Byte *byteData = (Byte*) malloc(l);
            if(i == 0){
                memcpy(byteData, [pd bytes], l);
                if(byteData){
                    
                    //I think the zero should be 'i', but for some reason that doesn't work...
                    abl->mBuffers[i].mDataByteSize = (UInt32)l;
                    abl->mBuffers[i].mNumberChannels = 1;
                    abl->mBuffers[i].mData = byteData;
                    //                memcpy(&self.abl->mBuffers[i].mData, byteData, l);
                }
            } else {
                memcpy(byteData2, [pd bytes], l);
                if(byteData2){
                    
                    //I think the zero should be 'i', but for some reason that doesn't work...
                    abl->mBuffers[i].mDataByteSize = (UInt32)l;
                    abl->mBuffers[i].mNumberChannels = 1;
                    abl->mBuffers[i].mData = byteData2;
                    //                memcpy(&self.abl->mBuffers[i].mData, byteData, l);
                }
            }
            
            
            //Update the range to the next buffer
            olen += step;
            //lenx = lenx + step;
            i++;
            //            free(byteData);
        }
        return abl;
    }
    return nil;
}



@end