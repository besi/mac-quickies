//
//  AppDelegate.m
//  OutlineView
//
//  Copyright (c) 2013 company. All rights reserved.
//

#import "AppDelegate.h"
#import "Book.h"

@interface AppDelegate()

@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet NSTreeController *booksController;

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.outlineView.delegate = self;
    self.outlineView.floatsGroupRows = NO; // Prevent a sticky header
    [self addData];
    
     // Expand the first group and select the first item in the list
    [self.outlineView expandItem:[self.outlineView itemAtRow:0]];
    [self.outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
}


#pragma mark - Add data

- (void) addData{
    
    // `children` and `isLeaf` have to be configured for the Tree Controller in IB
    NSMutableDictionary *root = @{@"title": @"BOOKS",
                                  @"isLeaf": @(NO),
                                  @"children":@[
                                          [Book bookWithTitle:@"To Kill a Mockingbird" andAuthor:@"Harper Lee"],
                                          [Book bookWithTitle:@"Pride and Prejudice" andAuthor:@"Jane Austen"],
                                          [Book bookWithTitle:@"The Catcher in the Rye" andAuthor:@"J.D. Salinger"]
                                          ].mutableCopy
                                  }.mutableCopy;
    
    [self.booksController addObject:root];
}


#pragma mark - Helpers

- (BOOL) isHeader:(id)item{
    
    if([item isKindOfClass:[NSTreeNode class]]){
        return ![((NSTreeNode *)item).representedObject isKindOfClass:[Book class]];
    } else {
        return ![item isKindOfClass:[Book class]];
    }
}


#pragma mark - NSOutlineViewDelegate

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item{
    return ![self isHeader:item];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    
    if ([self isHeader:item]) {
        return [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
    } else {
        return [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item{
    // This converts a group to a header which influences its style
    return [self isHeader:item];
}

@end
