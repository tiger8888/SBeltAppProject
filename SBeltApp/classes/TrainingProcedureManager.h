//
//  TrainingProcedureManager.h
//  SBeltApp
//
//  Created by 王 维 on 10/29/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainingProcedureManager : NSObject{
    
    float   _targetBR;                      //目标呼吸率
    float   _initiateGuideBR;                    //初始引导呼吸率
    
    float   totalBreathRateForInitBR;       //初始呼吸率计算缓冲
    int     countOfBreathRateForInitBR;     //初始呼吸率接收数据
    int     M;                              //初始引导呼吸率编号
    int     N;                              //目标呼吸率编号
    int     m;                              //当前阶段呼吸率编号
    int     outOfCurrentLevelTimes;         //连续超出当前阶段计数
    
    int     T_Period;                       //当前阶段训练时间
    int     T_Total;                        //训练总时间
    int     Time_X[7];                      //各个阶段训练时间
    float   MatchingRateSum_X[7];           //
    int     MatchingNum_X[7];               //
    float   MatchingRateAvg_X[7];           //
    int     MatchingRateScore;              //
    int     TestingScore;                   //
    
    BOOL    bStartTraining;
}

+(TrainingProcedureManager *)sharedInstance;


-(void)setTargetBreathRate:(float)targetBR;

-(void)addBreathRate:(float)br;



@end
