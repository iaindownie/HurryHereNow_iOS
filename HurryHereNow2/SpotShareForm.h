//
//  SpotShareForm.h
//  HurryHereNow2
//
//  Created by Matt Froggett on 19/01/2015.
//  Copyright (c) 2015 mf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface SpotShareForm : NSObject <FXForm>

@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *offerDescription;

@end
