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
    self.outlineView.dataSource = self;
    self.outlineView.floatsGroupRows = NO; // Prevent a sticky header
    [self addData];
    
     // Expand the first group and select the first item in the list
    [self.outlineView expandItem:[self.outlineView itemAtRow:0]];
    [self.outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
    
    // Enable Drag and Drop
    [self.outlineView registerForDraggedTypes: [NSArray arrayWithObject: @"public.text"]];
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


- (IBAction)addClicked:(id)sender {
    NSUInteger indexArr[] = {0,0};

    [self.booksController insertObject:[Book new] atArrangedObjectIndexPath:[NSIndexPath indexPathWithIndexes:indexArr length:2]];
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


#pragma mark - Drag & Drop

- (id <NSPasteboardWriting>)outlineView:(NSOutlineView *)outlineView pasteboardWriterForItem:(id)item{
    // No dragging if <some condition isn't met>
    BOOL dragAllowed = YES;
    if (!dragAllowed)  {
        return nil;
    }
    
    Book *book = (Book *)(((NSTreeNode *)item).representedObject);
    NSString *identifier = book.title;
    
    NSPasteboardItem *pboardItem = [[NSPasteboardItem alloc] init];
    [pboardItem setString:identifier forType: @"public.text"];
   
    return pboardItem;
}


- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id < NSDraggingInfo >)info proposedItem:(id)targetItem proposedChildIndex:(NSInteger)index{
    
    BOOL canDrag = index >= 0 && targetItem;

    if (canDrag) {
        return NSDragOperationMove;
    }else {
        return NSDragOperationNone;
    }
}


- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id < NSDraggingInfo >)info item:(id)targetItem childIndex:(NSInteger)index{

    NSPasteboard *p = [info draggingPasteboard];
    NSString *title = [p stringForType:@"public.text"];
    NSTreeNode *sourceNode;
    
    for(NSTreeNode *b in [targetItem childNodes]){
        if ([[[b representedObject] title] isEqualToString:title]){
            sourceNode = b;
        }
    }

    if(!sourceNode){
        // Not found
        return NO;
    }
    
    NSUInteger indexArr[] = {0,index};
    NSIndexPath *toIndexPATH =[NSIndexPath indexPathWithIndexes:indexArr length:2];

    [self.booksController moveNode:sourceNode toIndexPath:toIndexPATH];
    
    return YES;
}

@end
