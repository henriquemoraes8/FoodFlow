//
//  LineGraphViewController.m
//  FoodFlow
//
//  Created by Henrique Moraes on 11/11/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import "LineGraphViewController.h"

@interface LineGraphViewController ()
{
    ShinobiChart* _chart;
    NSMutableArray *mockData;
    NSMutableArray *dataPoints;
}
@end

@implementation LineGraphViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMockData];
    [self buildGraphicView];
}

-(void) initMockData {
    dataPoints = [[NSMutableArray alloc] initWithObjects:[NSMutableArray new],[NSMutableArray new], nil];
    
    NSMutableArray *cumulativeSum = [[NSMutableArray alloc] initWithObjects:@"14.44",@"27.81",@"33.94",@"48.19",@"63.36",@"69.9",@"74.14",@"81.29",@"96.39",@"108.79",@"114.04",@"122.29",@"131.7",@"139.51",@"145.69",@"154.05",@"163.71",@"175.53",@"181.46",@"187.82",@"200.17",@"206.59",@"211.22",@"221.42",@"235.19",@"245.79",@"256.95",@"265.1",@"279.65",@"292.81",@"300.54",@"308.54",@"314.34",@"321.75",@"326.04",@"339.97",@"346.5",@"361.09",@"372.64",@"380.16",@"386.27",@"399",@"403.31",@"414.89",@"430.83",@"443.14",@"452.07",@"458.24",@"464.17",@"478.64",@"488.16",@"502.57",@"514.94",@"527.14",@"532.48",@"537.44",@"546.66",@"559.19",@"566.82",@"571.57",@"578.5",@"586.36",@"590.39",@"600.1",@"606.59",@"613.62",@"628.51",@"639.83",@"652.35",@"666.7",@"677.18",@"685.9",@"690.09",@"697.05",@"703.73",@"719.67",@"727.26",@"734.38",@"748.28",@"759.69",@"767.12",@"772.78",@"783.35",@"795.52",@"805.6",@"810.03",@"817.71",@"827.7",@"837.72",@"847.65",@"861.01",@"874.74",@"884.44",@"889.28",@"904.85",@"913.16",@"926.29",@"941.79",@"954.2",@"963.63",@"973.63",@"986.04",@"996.73",@"1000.97",@"1011.8",@"1015.82",@"1030.25",@"1045.12",@"1056.57",@"1068.89",@"1078.64",@"1089.46",@"1097.56",@"1104.21",@"1115.62",@"1125.61",@"1130.91",@"1140.19",@"1145.42",@"1149.61",@"1162.68", nil];
    
    NSDate *currentDate;
    for (int i = 0; i < 120; i ++) {
        currentDate = [NSDate dateWithTimeIntervalSinceNow:i*3600*24];
        
        SChartDataPoint* dataPoint = [SChartDataPoint new];
        dataPoint.xValue = currentDate;
        dataPoint.yValue = @(i*1500/120);
        [dataPoints[0] addObject:dataPoint];
        
        dataPoint = [SChartDataPoint new];
        dataPoint.xValue = currentDate;
        dataPoint.yValue = @([cumulativeSum[i] intValue]);
        [dataPoints[1] addObject:dataPoint];
    }
}

#pragma  mark - Grafico

-(void) buildGraphicView {
    CGRect viewFrame = CGRectMake(0, 30, self.view.frame.size.height, self.view.frame.size.width-30);
    viewFrame = CGRectInset(viewFrame, 5.0, 2.0);
    
    _chart = [[ShinobiChart alloc] initWithFrame:viewFrame];
    
    _chart.autoresizingMask =  UIViewAutoresizingNone;
    
    SChartDataPoint* dataPointFirst = dataPoints[0][0];
    SChartDataPoint* dataPointLast = [dataPoints[0] lastObject];
    SChartDateRange* dateRange = [[SChartDateRange alloc] initWithDateMinimum:dataPointFirst.xValue
                                                               andDateMaximum:dataPointLast.xValue];
    
    SChartDateTimeAxis *xAxis = [[SChartDateTimeAxis alloc] initWithRange:dateRange];
    xAxis.style.interSeriesPadding = @0;
    _chart.xAxis = xAxis;
    
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.rangePaddingHigh = @1.0;
    _chart.yAxis = yAxis;
    
    // add to the view
    [self.view addSubview:_chart];
    
    _chart.datasource = self;
    _chart.delegate = self;
    
    // enable gestures
    yAxis.enableGesturePanning = YES;
    yAxis.enableGestureZooming = YES;
    xAxis.enableGesturePanning = YES;
    xAxis.enableGestureZooming = YES;
    
    // show the legend
    _chart.legend.hidden = NO;
    _chart.legend.placement = SChartLegendPlacementInsidePlotArea;
    _chart.legend.position = SChartLegendPositionMiddleRight;
}

#pragma mark - SChartDatasource methods

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 2;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    
    SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];
    //lineSeries.style.showFill = YES;
    
    // the first series is a cosine curve, the second is a sine curve
    lineSeries.title = index == 0 ? @"Limit" : @"Current spending";
    lineSeries.style.pointStyle.showPoints = NO;
    lineSeries.selectionMode = SChartSelectionSeries;
    
    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return [dataPoints[0] count];
}


- (SChartDataPoint*)dataPointForDate:(NSString*)date andValue:(NSNumber*)value {
    SChartDataPoint* dataPoint = [SChartDataPoint new];
    dataPoint.xValue = [self dateFromString:date];
    dataPoint.yValue = value;
    return dataPoint;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex
{
    return [dataPoints[seriesIndex] objectAtIndex:dataIndex];
    //return [self dataPointForDate:str andValue:num];
}

#pragma mark - utility methods

- (NSDate*) dateFromString:(NSString*)date {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    }
    return [dateFormatter dateFromString:date];
}


-(void) updateChart {
    [_chart reloadData];
    [_chart redrawChart];
}


@end
