//
//  Book.m
//  OutlineView
//
//  Copyright (c) 2013 company. All rights reserved.
//

#import "Book.h"

@implementation Book

+(Book *)bookWithTitle:(NSString *)title andAuthor:(NSString *)author{
    Book *result = [Book new];
    result.author = author;
    result.title = title;
    
    return result;
}

-(BOOL)isLeaf{
    return YES;
}

@end
