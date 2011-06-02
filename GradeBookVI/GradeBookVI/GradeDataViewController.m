//
//  RootViewController.m
//  GradeBookVI
//
//  Created by Gibson, Christopher on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GradeDataViewController.h"

@implementation GradeDataViewController

@synthesize gradeData=_gradeData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    
    [self loadURL];
    
    if(self != nil )
    {
        [self loadURL];
        
        self.gradeData = [[[GradeData alloc] init] autorelease];
        
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self != nil )
    {
        [self loadURL];
        
        self.gradeData = [[[GradeData alloc] init] autorelease];
        
    }
    
    return self;
}

- (void) loadURL
{
    if(!self.gradeData.url || self.gradeData.url == nil)
        self.gradeData.url = @"root";
    
    NSLog(@"New URL: '%@' depth: %d", self.gradeData.url, self.gradeData.depth);
}

- (void) saveURL:(NSString*)newUrl
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:newUrl forKey:@"currURL"];
    [defaults synchronize];
}

- (void)viewDidLoad
{
    NSLog(@"ui table view controller loaded");
    [self.gradeData load];
    self.title = self.gradeData.title;
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadURL];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"SIZE: %d", [self.gradeData.options count]);
    return [self.gradeData.options count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    int style;
    
    if(self.gradeData.depth == 0)
    {
        style = UITableViewCellStyleSubtitle;
    }else{
        style = UITableViewCellStyleValue1;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Select the 'option' text for the current grade data
    cell.textLabel.text = [self.gradeData valAtIndex:indexPath.row];
    if(self.gradeData.depth == 2)
    {
        NSString *color = [self.gradeData colorAtIndex:indexPath.row];
        if([color isEqualToString:@"RED"])
            cell.detailTextLabel.textColor = [UIColor redColor];
        if([color isEqualToString:@"GRAY"])
            cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    cell.detailTextLabel.text = [self.gradeData detailAtIndex:indexPath.row];
    // Configure the cell.
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"SELECTED: %d", indexPath.row);

    if([self.gradeData canGoDeeper])
    {
        GradeDataViewController *gradeViewController = [[GradeDataViewController alloc] initWithNibName:@"GradeDataViewController" bundle:nil];
    
        //NSString *newUrl = [self.gradeData urlFromIndex:indexPath.row];
    
        //[self saveURL:newUrl];
        NSLog(@"setting depth to %d", self.gradeData.depth + 1);
        gradeViewController.gradeData.depth = self.gradeData.depth + 1;
        gradeViewController.gradeData.url = self.gradeData.url;
        gradeViewController.gradeData.auth = self.gradeData.auth;
        
        NSMutableDictionary* dict = [self.gradeData.options objectAtIndex:indexPath.row];
        
        switch (self.gradeData.depth) {
            case 0: // Will be enrollments
                gradeViewController.gradeData.term = [dict objectForKey:@"term"];
                gradeViewController.gradeData.course = [dict objectForKey:@"course"];
                break;
            case 1: // Will be scores
                gradeViewController.gradeData.term = self.gradeData.term;
                gradeViewController.gradeData.course = self.gradeData.course;
                gradeViewController.gradeData.user = [dict objectForKey:@"user"];
                
            default:
                break;
        }
    
        [self.navigationController pushViewController:gradeViewController animated:YES];
        [gradeViewController release];
    }

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    NSLog(@"Dealloc'ing view controller");
    [_gradeData release];
    [super dealloc];
}

@end
