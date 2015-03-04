//
//  ViewController.m
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13. Updated by Sam Spencer on 1/11/14.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//  Copyright (c) 2014 Sam Spencer.
//

#import "ViewController.h"


@interface ViewController () {
    int previousStepperValue;
    int totalNumber;
}

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.arrayOfValues = [[NSMutableArray alloc] init];
    self.arrayOfValues2 = [[NSMutableArray alloc] init];
    self.arrayOfDates = [[NSMutableArray alloc] init];
    
    previousStepperValue = self.graphObjectIncrement.value;
    totalNumber = 0;
    
    for (int i = 0; i < 9; i++) {
        [self.arrayOfValues addObject:@([self getRandomInteger])]; // Random values for the graph
        [self.arrayOfValues2 addObject:@([self getRandomInteger])]; // Random values for the graph
        [self.arrayOfDates addObject:[NSString stringWithFormat:@"%@", @(2000 + i)]]; // Dates for the X-Axis of the graph
        
        totalNumber = totalNumber + [[self.arrayOfValues objectAtIndex:i] intValue]; // All of the values added together
    }
    
    /* This is commented out because the graph is created in the interface with this sample app. However, the code remains as an example for creating the graph using code.
     BEMSimpleLineGraphView *myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 60, 320, 250)];
     myGraph.delegate = self;
     myGraph.dataSource = self;
     [self.view addSubview:myGraph]; */
    
    // Customization of the graph
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    self.myGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    self.myGraph.enableTouchReport = YES;
    self.myGraph.enablePopUpReport = YES;
    self.myGraph.enableYAxisLabel = YES;
    self.myGraph.autoScaleYAxis = YES;
    self.myGraph.alwaysDisplayDots = NO;
    self.myGraph.enableReferenceXAxisLines = YES;
    self.myGraph.enableReferenceYAxisLines = YES;
    self.myGraph.enableReferenceAxisFrame = YES;
    self.myGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    // Setup initial curve selection segment
    self.curveChoice.selectedSegmentIndex = self.myGraph.enableBezierCurve;

    // The labels to report the values of the graph when the user touches it
    self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSumForLineIndex:0] intValue]];
    self.labelDates.text = @"between 2000 and 2010";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Graph Actions

- (IBAction)refresh:(id)sender {
    [self.arrayOfValues removeAllObjects];
    [self.arrayOfValues2 removeAllObjects];
    
    [self.arrayOfDates removeAllObjects];
    
    for (int i = 0; i < self.graphObjectIncrement.value; i++) {
        [self.arrayOfValues addObject:@([self getRandomInteger])]; // Random values for the graph
        [self.arrayOfValues2 addObject:@([self getRandomInteger])]; // Random values for the graph
        [self.arrayOfDates addObject:[NSString stringWithFormat:@"%@", @(2000 + i)]]; // Dates for the X-Axis of the graph
        
        totalNumber = totalNumber + [(self.arrayOfValues)[i] intValue]; // All of the values added together
    }
    UIColor *color;
    if (self.graphColorChoice.selectedSegmentIndex == 0) color = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    else if (self.graphColorChoice.selectedSegmentIndex == 1) color = [UIColor colorWithRed:255.0/255.0 green:187.0/255.0 blue:31.0/255.0 alpha:1.0];
    else if (self.graphColorChoice.selectedSegmentIndex == 2) color = [UIColor colorWithRed:0.0 green:140.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    self.myGraph.enableBezierCurve = (BOOL) self.curveChoice.selectedSegmentIndex;
    self.myGraph.colorTop = color;
    self.myGraph.colorBottom = color;
    self.myGraph.backgroundColor = color;
    self.view.tintColor = color;
    self.labelValues.textColor = color;
    self.navigationController.navigationBar.tintColor = color;
    
    self.myGraph.animationGraphStyle = BEMLineAnimationFade;
    [self.myGraph reloadGraph];
}

- (NSInteger)getRandomInteger {
    NSInteger i1 = (int)(arc4random() % 10000);
    return i1;
}

- (IBAction)addOrRemoveLineFromGraph:(id)sender {
    if (self.graphObjectIncrement.value > previousStepperValue) {
        // Add line
        [self.arrayOfValues addObject:@([self getRandomInteger])];
        [self.arrayOfValues2 addObject:@([self getRandomInteger])];
        [self.arrayOfDates addObject:[NSString stringWithFormat:@"%i", (int) [[self.arrayOfDates lastObject] integerValue] + 1]];
        [self.myGraph reloadGraph];
    } else if (self.graphObjectIncrement.value < previousStepperValue) {
        // Remove line
        [self.arrayOfValues removeObjectAtIndex:0];
        [self.arrayOfValues2 removeObjectAtIndex:0];
        [self.arrayOfDates removeObjectAtIndex:0];
        [self.myGraph reloadGraph];
    }
    
    previousStepperValue = self.graphObjectIncrement.value;
}

- (IBAction)displayStatistics:(id)sender {
    [self performSegueWithIdentifier:@"showStats" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"showStats"]) {
        StatsViewController *controller = segue.destinationViewController;
        controller.standardDeviation = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculateLineGraphStandardDeviationForLineIndex:0] floatValue]];
        controller.average = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculatePointValueAverageForLineIndex:0] floatValue]];
        controller.median = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculatePointValueMedianForLineIndex:0] floatValue]];
        controller.mode = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculatePointValueModeForLineIndex:0] floatValue]];
        controller.minimum = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculateMinimumPointValueForLineIndex:0] floatValue]];
        controller.maximum = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculateMaximumPointValueForLineIndex:0] floatValue]];
        controller.snapshotImage = [self.myGraph graphSnapshotImage];
    }
}

#pragma mark - SimpleLineGraph Data Source

-(NSInteger)numberOfLinesOnGraph:(BEMSimpleLineGraphView *)graph
{
    return 2;
}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph onLine:(NSInteger)lineIndex
{
    switch (lineIndex) {
        case 0:
            return (int)[self.arrayOfValues count];
            break;
        case 1:
            return (int)[self.arrayOfValues2 count];
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index onLine:(NSInteger)lineIndex
{
    switch (lineIndex) {
        case 0:
            return [[self.arrayOfValues objectAtIndex:index] floatValue];
            break;
        case 1:
            return [[self.arrayOfValues2 objectAtIndex:index] floatValue];
            break;
        default:
            return 0.0f;
            break;
    }
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 1;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *label = [self.arrayOfDates objectAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.arrayOfValues objectAtIndex:index]];
    self.labelDates.text = [NSString stringWithFormat:@"in %@", [self.arrayOfDates objectAtIndex:index]];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.labelValues.alpha = 0.0;
        self.labelDates.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSumForLineIndex:0] intValue]];
        self.labelDates.text = [NSString stringWithFormat:@"between %@ and %@", [self.arrayOfDates firstObject], [self.arrayOfDates lastObject]];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.labelValues.alpha = 1.0;
            self.labelDates.alpha = 1.0;
        } completion:nil];
    }];
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
    self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSumForLineIndex:0] intValue]];
    self.labelDates.text = [NSString stringWithFormat:@"between %@ and %@", [self.arrayOfDates firstObject], [self.arrayOfDates lastObject]];
}

@end