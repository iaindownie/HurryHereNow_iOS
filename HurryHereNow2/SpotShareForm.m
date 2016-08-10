//
//  SpotShareForm.m
//  HurryHereNow2
//
//  Created by Matt Froggett on 19/01/2015.
//  Copyright (c) 2015 mf. All rights reserved.
//

#import "SpotShareForm.h"

@implementation SpotShareForm

- (NSArray *)fields
{
    return @[
             @{FXFormFieldKey: @"storeName", FXFormFieldType: FXFormFieldTypeLongText},
             @{FXFormFieldKey: @"offerDescription", FXFormFieldType: FXFormFieldTypeLongText}
             ];
}

@end
