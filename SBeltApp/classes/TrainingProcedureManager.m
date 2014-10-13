//
//  TrainingProcedureManager.m
//  SBeltApp
//
//  Created by 王 维 on 10/29/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "TrainingProcedureManager.h"


#define    countOfAverageInitBreathRate         10  //默认1秒1个数据，所以60个相当于一分钟
#define    T_Period_Max                         3.0*60.0//当前阶段训练时间3分钟
#define    T_Total_Max                          21.0*60.0//总时间21分钟
#define    outOfCurrentLevelTimesMax             4

#define  clearArray(_arr)   {   _arr[0] = 0;\
                                _arr[1] = 0;\
                                _arr[2] = 0;\
                                _arr[3] = 0;\
                                _arr[4] = 0;\
                                _arr[5] = 0;\
                                _arr[6] = 0;\
                            }


static float X[7] = {14,12.5,11,9.5,8,6,4};//代表引导呼吸率

static TrainingProcedureManager *_sharedIntance;

@implementation TrainingProcedureManager

+(TrainingProcedureManager *)sharedInstance{
    if (_sharedIntance == nil) {
        _sharedIntance = [[TrainingProcedureManager alloc] init];
    }
    return _sharedIntance;
}
-(id)init{
    self = [super init];
    if (self) {
        //初始化
        [self initAllVariables];
    }
    return self;
}

-(void)initAllVariables{
    bStartTraining = NO;
    totalBreathRateForInitBR = 0.0;
    countOfBreathRateForInitBR = 0;
     M = 0;                              //初始引导呼吸率编号
     N = 0;                              //目标呼吸率编号
    
    T_Period = 0;                       //当前阶段训练时间
    T_Total = 0;                        //训练总时间
    outOfCurrentLevelTimes = 0;
    
    clearArray(Time_X);
    clearArray(MatchingRateSum_X);
    clearArray(MatchingRateAvg_X);
    clearArray(MatchingNum_X);
    
   MatchingRateScore = 0;              //
   TestingScore = 0;
}
-(void)reStartTrainingClear{

    T_Period = 0;                       //当前阶段训练时间

    outOfCurrentLevelTimes = 0;

    
    MatchingRateScore = 0;              //
    TestingScore = 0;

}
-(void)setTargetBreathRate:(float)targetBR{
    _targetBR = targetBR;
}

-(void)addBreathRate:(float)br{
    
    
    printf("add breathe rate %.1f\n",br);
    
    if (bStartTraining) {
        [self trainingHandler:br];
    }else{
        [self preTrainingHandler:br];
    }
    
    
    
    
}
-(void)preTrainingHandler:(CGFloat)br{
    
    totalBreathRateForInitBR += br;
    countOfBreathRateForInitBR++;
    
    if ([self checkInitBreathRateGenerated]) {
        NSLog(@"initiate Breath Rate Generated: %f",_initiateGuideBR);
    }else{
        NSLog(@"Just Add To Generate Init BR: totalBreathRateForInitBR = %f,countOfBreathRateForInitBR = %d",totalBreathRateForInitBR,countOfBreathRateForInitBR);
    }
}

-(BOOL)checkInitBreathRateGenerated{
    
    if (countOfBreathRateForInitBR >= countOfAverageInitBreathRate) {//一分钟开始计算初始呼吸率
        float averageBreathRate = totalBreathRateForInitBR/countOfBreathRateForInitBR;
        for (int i = 0; i < 7; i++) {
            if (averageBreathRate >= X[i]) {
                _initiateGuideBR = X[i];
                M = i;
                
                NSLog(@"generateInitBreatheRate: %.1f",_initiateGuideBR);
                return YES;
            }
        }
        NSLog(@"average breathe rate error: no right value in X[7]!!");
    }
    
    return NO;
    
}
//确定初始引导呼吸率后，开始训练
-(void)startTraining{
    bStartTraining = YES;
    [self reStartTrainingClear];
}
-(void)trainingHandler:(CGFloat)br{
    
    T_Period ++ ;
    T_Total ++;

//add code here,新值用符号取反表示
    
    if (br>=(X[m]+1)) {//超出当前阶段+1
        
        if (outOfCurrentLevelTimes >= 4) {
            [self matchingNumCaculate];         //跟随拟合率计算
            m = (m>M)?(m-1):M;                  //不超出初始引导率
            [self startTraining];               //新阶段重新训练
        }else{
            outOfCurrentLevelTimes++;           //连续超出计数
        }
        
    }else{
        outOfCurrentLevelTimes = 0;
        Time_X[m]++;
        if (T_Period >= T_Period_Max && T_Total <= T_Total_Max) {
            m = (m>N)?N:(m+1);                  //不超出目标呼吸率
        }
    }
    
    
    /*
        总训练时间已到，则进行评分
     */
    
    if (T_Total >= T_Total_Max) {
        [self scoreCaculate];
    }
    
}

-(void)matchingNumCaculate{
    MatchingNum_X[m] ++ ;
    MatchingRateSum_X[m] += (float)T_Period/T_Period_Max * 100;
}
-(void)scoreCaculate{
//每阶段拟合平均值
    for (int i = 0; i<7; i++) {
        MatchingRateAvg_X[i] = MatchingRateSum_X[i]/MatchingNum_X[i];
    }
//总拟合平均值
    float matchingSum = 0.0;
    for (int i = 0; i<7; i++) {
        matchingSum += MatchingRateAvg_X[i];
    }
    MatchingRateScore = matchingSum/7;
    
//有效训练时间
    if (M>2) {
        for (int i = M; i<N ; i++) {
            TestingScore += Time_X[i];
        }
    }else{
        for (int i = 3; i<N ; i++) {
            TestingScore += Time_X[i];
        }
    }
    
//得出两个值MatchingRateScore,TestingScore
    
}
@end
