//
//  ChatModel.swift
//  Willson
//
//  Created by JHKim on 12/07/2019.
//  Copyright © 2019 JaehuiKim. All rights reserved.
//
import ObjectMapper

class ChatModel: Mappable {
    
    public var users :Dictionary<String,Bool> = [:] //채팅방에 참여한 사람들
    public var comments :Dictionary<String,Comment> = [:] //채팅방의 대화내용
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        users <- map["users"]
        comments <- map["comments"]
    }
    public class Comment :Mappable{
        public var uid : String?
        public var message : String?
        public var timestamp :Int?
        public var readUsers : Dictionary<String,Bool> = [:]
        public required init?(map: Map) {
            
        }
        public  func mapping(map: Map) {
            uid <- map["uid"]
            message <- map["message"]
            timestamp <- map["timestamp"]
            readUsers <- map["readUsers"]
        }
    }
    
}
