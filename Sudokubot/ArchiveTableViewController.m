//
//  ArchiveTableViewController.m
//  Sudokubot
//
//  Created by Haoest on 4/12/11.
//  Copyright 2011 none. All rights reserved.
//

#import "ArchiveTableViewController.h"
#import "BoardViewController.h"

@implementation ArchiveTableViewController

@synthesize archiveContents;

- (void)dealloc
{
    [super dealloc];
}


+(ArchiveTableViewController*) archiveTableViewControllerFromDefaultArchive{
    ArchiveTableViewController* rv = [[ArchiveTableViewController alloc] initWithStyle:UITableViewStylePlain];
    NSString *archiveContent = [NSString stringWithContentsOfFile:
                                [NSString stringWithCString:archiveFileName encoding:NSASCIIStringEncoding] 
                                 encoding:NSUTF8StringEncoding error:Nil];
    NSArray *archiveEntries = [archiveContent componentsSeparatedByString:@"\n"];
    NSMutableArray *mutableEntries = [[NSMutableArray alloc]init ];
    for (int i=0; i<[archiveEntries count]; i++){
        if ([[[archiveEntries objectAtIndex:i] componentsSeparatedByString:@"\t"] count] == 3){
            [mutableEntries addObject:[archiveEntries objectAtIndex:i]];
        }
    }
    rv.archiveContents = [NSArray arrayWithArray:mutableEntries];
    return rv;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rv = [archiveContents count]; // exclude last row
    return rv;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *rowId = @"myRowId";
	// Try to retrieve from the table view a now-unused cell with the given identifier.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rowId];
	// If no cell is available, create a new one using the given identifier.
	if (cell == nil) {
		// Use the default cell style.
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rowId] autorelease];
	}
    NSString *archiveEntry = [archiveContents objectAtIndex:indexPath.row];
    NSArray *entrySegments = [archiveEntry componentsSeparatedByString:@"\t"];
	// Set up the cell.
	NSString *label = [NSString stringWithFormat:@"%@\n%@", [entrySegments objectAtIndex:0], [entrySegments objectAtIndex:2]];
	cell.textLabel.text = label;
	return cell;
}
@end