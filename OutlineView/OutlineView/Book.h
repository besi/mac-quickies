//
//  Book.h
//  OutlineView
//
//  Copyright (c) 2013 company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (copy) NSString *title;
@property (copy) NSString *author;

+ (Book*) bookWithTitle:(NSString *)title andAuthor:(NSString *) author;


@property (readonly) BOOL isLeaf;

@end
