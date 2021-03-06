//
//  NearbyViewController.m
//  CSSAMon
//
//  Created by Zhaoyang Zeng on 11/15/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "NearbyViewController.h"

@interface NearbyViewController ()

@end

@implementation NearbyViewController
@synthesize anno_list;
@synthesize sorted_anno_list;
@synthesize latitude, longitude;
UITableView *tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    for (Annotation *annotation in anno_list) {
        CLLocationCoordinate2D coord = [annotation coordinate];
        CLLocation *anotLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        CLLocation *self_location = [[CLLocation alloc] initWithLatitude: latitude longitude: longitude];
        annotation.distance = [self_location distanceFromLocation:anotLocation];
    }
    
    sorted_anno_list = [anno_list sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber *first = [NSNumber numberWithDouble:[(Annotation*)a distance]];
        NSNumber *second = [NSNumber numberWithDouble:[(Annotation*)b distance]];
        return [first compare:second];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadView
{
    tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    
    self.view = tableView;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    NSString* sectionTitle = @"";
    
    if (section == 0)
    {
        sectionTitle = @"Nearby";
    }
    
    return sectionTitle;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 1;
    
    if (section == 0)
    {
        result = [sorted_anno_list count];
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //[[cell imageView] setImage:[UIImage imageNamed:@"Icon13.png"]];
    //[[cell textLabel] setText:[NSString stringWithFormat:@"%ld",(long)[indexPath row]]];
    [self updateCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[aTableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0)
    {
        Annotation* tmp =(Annotation*)[sorted_anno_list objectAtIndex:indexPath.row];
        NSInteger a = [tmp.user_id integerValue];
        [MapViewController right_function:a];
        //[tableView setHidden:YES];
        
    }

}

#pragma mark - Private

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0)
    {
        Annotation* tmp =(Annotation*)[sorted_anno_list objectAtIndex:indexPath.row];
        cell.textLabel.text = tmp.title;
        cell.imageView.image = [tmp getImageFromURL:tmp.image_url];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.textLabel.text = @"End";
        cell.imageView.image = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
