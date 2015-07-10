//
//  LDTMessage.h
//  Lets Do This
//
//  Created by Aaron Schachter on 6/23/15.
//  Copyright (c) 2015 Do Something. All rights reserved.
//

#import "TSMessage.h"

@interface LDTMessage : TSMessage

+(void)displayErrorWithTitle:(NSString *)title;
+(void)errorMessage:(NSError *)error;

@end
