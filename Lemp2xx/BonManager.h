//
//  BonManager.h
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 28..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "bon_mobile.h"

@interface BonManager : NSObject{
    NSThread *bonThread;
    BOOL alreadyBon;
}

+ (BonManager *)sharedBon;

- (void)bonStart;
- (void)_th_bon;
- (void)bonJoin:(int)type;
- (void)bonTyping:(int)type;
- (void)bonLeave;
- (void)bonStop;

@end
