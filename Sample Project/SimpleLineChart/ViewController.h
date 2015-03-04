//
//  ViewController.h
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13. Updated by Sam Spencer on 1/11/14.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//  Copyright (c) 2014 Sam Spencer.
//

#import "BEMSimpleLineGraphView.h"
#import "StatsViewController.h"

@interface ViewController : UIViewController <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph;

@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfValues2;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;

@property (strong, nonatomic) IBOutlet UILabel *labelValues;
@property (strong, nonatomic) IBOutlet UILabel *labelDates;

- (IBAction)refresh:(id)sender;
- (IBAction)addOrRemoveLineFromGraph:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *graphColorChoice;
@property (strong, nonatomic) IBOutlet UISegmentedControl *curveChoice;
@property (weak, nonatomic) IBOutlet UIStepper *graphObjectIncrement;

- (IBAction)displayStatistics:(id)sender;

@end