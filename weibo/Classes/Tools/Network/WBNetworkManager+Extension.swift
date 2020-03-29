//
//  WBNetworkManager+Extension.swift
//  weibo
//
//  Created by 郝心如 on 2020/3/28.
//  Copyright © 2020 HAM02020. All rights reserved.
//

import Foundation

//MARK: - 封装新浪微博的网络请求方法
extension WBNetworkManager {
    
    
    /// 加载微博数据字典数组
    /// - Parameter since_id: 返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    /// - Parameter max_id: 则返回ID小于或等于max_id的微博，默认为0。
    /// - Parameter completion: 完成回调[list: 微博字典数组/是否成功]
    func statusList(since_id:Int64=0,max_id:Int64=0,completion: @escaping(_ list:[[String:AnyObject]]?,_ isSuccess:Bool)->()) {
        
            //用网络工具加载微博数据
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"

        let params = ["since_id":"\(since_id)",
            "max_id":"\(max_id > 0 ? max_id - 1 : 0)"]
        
        tokenRequest(URLString: urlString, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            let result = json?["statuses"] as? [[String:AnyObject]]
            
            completion(result,isSuccess)
//            result = result["statuses"] as! ([String : Any])

        }

    }
    
    //返回微博的未读数量
    func getUnreadCount(completion:@escaping (_ count:Int)->()) {
        
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        
        let pararms = ["uid":uid]
        
        tokenRequest(URLString: urlString, parameters: pararms as [String : AnyObject]) { (json, isSuccess) in
            
            let dict = json as? [String:AnyObject]
            let count = dict?["status"] as? Int
            completion(count ?? 0)
        
        }
    
    }

}

//OAuth相关方法
extension WBNetworkManager {
    func getAccessToken(code:String) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let pararms = ["client_id":WBAppKey,
                       "client_secret":WBAPPSecret,
                       "grant_type":"authorization_code",
                       "code":code,
                       "redirect_uri":WBRedirectURI]
        request(method: .POST, URLString: urlString, parameters: pararms as [String : AnyObject]) { (json, isSuccess) in
            print(json!)
            
            self.userAccount.yy_modelSet(with: (json as? [String:AnyObject]) ?? [:])
            
            print(self.userAccount)
        }
    }
}
