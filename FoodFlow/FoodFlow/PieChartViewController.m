//
//  PieChartViewController.m
//  FoodFlow
//
//  Created by Henrique Moraes on 11/11/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import "PieChartViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface PieChartViewController ()
{
    ShinobiChart* _chart;
    NSMutableArray *mockData;
    NSMutableArray *mockLabels;
}
@end

@implementation PieChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMockData];
    [self buildGraphicView];
}

-(void) initMockData {
    mockData = [[NSMutableArray alloc] initWithObjects:@(12.56),@(70.40),@(65.36),@(25.60),@(34.80), nil];
    mockLabels = [[NSMutableArray alloc] initWithObjects:@"Loop",@"Divinity School Refectory",@"abp",@"Panda Express",@"Mc Donald's", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - Grafico

-(void) buildGraphicView {
    CGRect viewFrame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-95);
    viewFrame = CGRectInset(viewFrame, 25.0, 20.0);
    
    _chart = [[ShinobiChart alloc] initWithFrame:viewFrame];
    
    _chart.autoresizingMask =  UIViewAutoresizingNone;
    
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.style.interSeriesPadding = @0;
    _chart.xAxis = xAxis;
    
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.rangePaddingHigh = @1.0;
    _chart.yAxis = yAxis;
    
    // add to the view
    [self.view addSubview:_chart];
    
    _chart.datasource = self;
    _chart.delegate = self;
    
    // show the legend
    _chart.legend.hidden = NO;
    _chart.legend.placement = SChartLegendPlacementOutsidePlotArea;
    _chart.legend.position = SChartLegendPositionBottomMiddle;
}

#pragma mark - SChartDelegate methods

- (void)sChart:(ShinobiChart *)chart toggledSelectionForRadialPoint:(SChartRadialDataPoint *)dataPoint inSeries:(SChartRadialSeries *)series atPixelCoordinate:(CGPoint)pixelPoint{
}

#pragma mark - SChartDatasource methods

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartPieSeries* pieSeries = [[SChartPieSeries alloc] init];
    pieSeries.selectedStyle.protrusion = 10.0f;
    pieSeries.selectionAnimation.duration = @0.4;
    return pieSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return mockData.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartRadialDataPoint *datapoint = [[SChartRadialDataPoint alloc] init];
    datapoint.name = mockLabels[dataIndex];
    datapoint.value = mockData[dataIndex];
    
    return datapoint;
}

-(void) updateChart {
    [_chart reloadData];
    [_chart redrawChart];
}


@end
