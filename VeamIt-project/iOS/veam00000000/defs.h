//
//  defs.h
//  Stats
//
//  Created by veam on 2014/09/23.
//  Copyright (c) 2014年 veam. All rights reserved.
//

#ifndef Stats_defs_h
#define Stats_defs_h

// 最大ページ数
#define MAX_PAGE_NUMBER 6

// ローカル通知の識別名
#define NOTIFICATION_REPORT_MANAGER_UPDATE @"reportManagerUpdate"

// WEBAPIのURL
//#define URL_WEBAPI @"https://stats.veam.co/api/31000015.php"
//#define URL_WEBAPI @"https://stats.veam.co/api/veamapp_detail.php?veamid=31000015"
#define URL_WEBAPI @"https://stats.veam.co/api/veamapp_detail.php?veamid=%@"

// WEBAPIリクエスト時のUser-Agent
#define HTTP_API_USER_AGENT @"Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_2_1 like Mac OS X; ja-jp) AppleWebKit/533.17.9 (KHTML,like Gecko) Version/5.0.2 Mobile/8C148a Safari/6533.18.5"

// WEBAPIリクエスト時のTimeout値
#define HTTP_API_TIMEOUT 1000



#define ANIMATION_TIME 0.5

#define CIRCLE_LINE_WIDTH 6.5

#define DEFAULT_APP_ID @"31000015"
#define DEFAULT_IAP_CUSTOMER_PRICE 0.99 // $


#endif
