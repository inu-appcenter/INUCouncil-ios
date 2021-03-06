//
//  NetworkModel.swift
//  INUnion(2)
//
//  Created by 이형주 on 2018. 8. 3..
//  Copyright © 2018년 이형주. All rights reserved.
//

import Foundation


import Alamofire
import UIKit

class NetworkModel{

private let serverURL = "http://117.16.231.66:7001"
    var view : NetworkCallback
    init(_ view: NetworkCallback) {
        self.view = view
    }

//    로그인 통신
    func login(username: String, password: String) {
      
        let param = ["username": username,
                     "password": password]
        
        let header = ["Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Content-Type" : "application/x-www-form-urlencoded"]
        
        Alamofire.request("\(serverURL)/login", method: .post, parameters: param, headers: header).responseJSON { response in
            switch response.result{
            case .success(let item):
                self.view.networkSuc(resultdata: item, code: "loginSuccess")
                
            case .failure(let error):
                self.view.networkFail(code: "loginError")
                print("loginError")
            
            }
        }
    }
    
//    공지사항 리스트 통신
    func boardList(department: String){
        let param = ["department": department]
        
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        
        Alamofire.request("\(serverURL)/boardSelect/", method: .post, parameters: param, headers: header).responseJSON { response in
            switch response.result{
            case .success(let item):
                self.view.networkSuc(resultdata: item, code: "boardListSuccess")
                
            case .failure(let error):
                self.view.networkFail(code: "boardListError")
                print(error)
            }
        }
    }

//    공지사항 세부 리스트
    func boardDetailList(department: String, content_serial_id: String){
        
        let param = ["department": department,
                     "content_serial_id": content_serial_id]
        
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        
        Alamofire.request("\(serverURL)/boardSelectOne/", method: .post, parameters: param, headers: header).responseJSON { response in
            switch response.result{
            case .success(let item):
                self.view.networkSuc(resultdata: item, code: "boardListSuccess")
                
            case .failure(let error):
                self.view.networkFail(code: "boardListError")
                print(error)
            }
        }
    }

//    공지사항 업로드
    func uploadBoard(userfile: [UIImage] ,title: String, content: String, department:String){
        let params: Parameters = [
            "title" : title,
            "content" : content,
            "department" : department]
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key,value) in params {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            for index in 0..<userfile.count {
                var data = UIImagePNGRepresentation(userfile[index])
                if data != nil {
                    // PNG
                    multipartFormData.append(data!, withName: "userfile",fileName: "userfile", mimeType: "image/png")
                } else {
                    // jpg
                    data = UIImageJPEGRepresentation(userfile[index], 0.5)
                    multipartFormData.append((data?.base64EncodedData())!, withName: "userfile",fileName: "userfile", mimeType: "image/jpeg")
                }
            }
        },
                         to: "\(serverURL)/boardSave/",
            headers: ["Content-Type" : "multipart/form-data"],
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON{ res in
                        switch res.result{
                        case .success(let item):
                            self.view.networkSuc(resultdata: item, code: "uploadProductSuccess")
                            break
                        case .failure(let error):
                            print(error)
                            self.view.networkFail(code: "uploadProductError")
                            break
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }
    
//    공지사항 수정
    func modifyBoard(userfile: [UIImage] ,title: String, content: String, department:String, content_serial_id: String){
        let params: Parameters = [
            "title" : title,
            "content" : content,
            "department" : department,
            "content_serial_id": content_serial_id]
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key,value) in params {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            for index in 0..<userfile.count {
                var data = UIImagePNGRepresentation(userfile[index])
                if data != nil {
                    // PNG
                    multipartFormData.append(data!, withName: "userfile",fileName: "userfile", mimeType: "image/png")
                } else {
                    // jpg
                    data = UIImageJPEGRepresentation(userfile[index], 0.5)
                    multipartFormData.append((data?.base64EncodedData())!, withName: "userfile",fileName: "userfile", mimeType: "image/jpeg")
                }
            }
        },
                         to: "\(serverURL)/boardModify/",
            headers: ["Content-Type" : "multipart/form-data"],
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON{ res in
                        switch res.result{
                        case .success(let item):
                            self.view.networkSuc(resultdata: item, code: "modifyProductSuccess")
                            break
                        case .failure(let error):
                            print(error)
                            self.view.networkFail(code: "modifyProductError")
                            break
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }
//    공지사항 삭제
    func deleteBoard(content_serial_id: String){
        let param = ["content_serial_id": content_serial_id]
        
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        
        Alamofire.request("\(serverURL)/boardDelete/", method: .post, parameters: param, headers: header).responseJSON { response in
            switch response.result{
            case .success(let item):
                self.view.networkSuc(resultdata: item, code: "boardDeleteSuccess")
                
            case .failure(let error):
                self.view.networkFail(code: "boardDeleteError")
                print(error)
            }
        }
    }
    
    //    연락처 리스트 통신
    func DirectoryList(department: String){
        let param = ["department": department]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        
        Alamofire.request("\(serverURL)/addressSelectAll/", method: .post, parameters: param, headers: header).responseJSON { response in
            switch response.result{
            case .success(let item):
                self.view.networkSuc(resultdata: item, code: "directoryListSuccess")
                
            case .failure(let error):
                self.view.networkFail(code: "directoryListError")
                print(error)
            }
        }
    }
  

    //    연락처 상세보기
    func DirectoryDetail(name: String){
        let param = ["name": name]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        
        Alamofire.request("\(serverURL)/addressSelect/", method: .post, parameters: param, headers: header).responseJSON { response in
            switch response.result{
            case .success(let item):
                self.view.networkSuc(resultdata: item, code: "DirectoryDetailSuccess")
                
            case .failure(let error):
                self.view.networkFail(code: "DirectoryDetailError")
                print(error)
            }
        }
    }
    //    연락처 등록
    func upLoadDirectory(name: String, phoneNumber: String, email: String, position: String, etc: String, department: String){
        let param = ["name": name, "phoneNumber": phoneNumber, "email":email, "position":position, "etc":etc, "department":department]
        
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        
        Alamofire.request("\(serverURL)/addressSave/", method: .post, parameters: param, headers: header).responseJSON { response in
            switch response.result{
            case .success(let item):
                self.view.networkSuc(resultdata: item, code: "DirectorySaveSucces")
                
            case .failure(let error):
                self.view.networkFail(code: "DirectorySaveFail")
                print(error)
            }
        }
    }
    
    //    연락처 삭제
    func deleteDirectory(addressId: String){
        let param = ["addressId": addressId]
        
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        
        Alamofire.request("\(serverURL)/addressDelete/", method: .post, parameters: param, headers: header).responseJSON { response in
            switch response.result{
            case .success(let item):
                self.view.networkSuc(resultdata: item, code: "DirectoryDeleteSuccess")
                
            case .failure(let error):
                self.view.networkFail(code: "DirectoryListError")
                print(error)
            }
        }
    }
    //    연락처 수정
    func modifyDirectory(name: String, phoneNumber: String, email: String, position: String, etc: String, department: String, addressId: Int){
        let param = ["name": name, "phoneNumber": phoneNumber, "email":email, "position":position, "etc":etc, "department": department, "addressId":addressId] as [String : Any]
        
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        
        Alamofire.request("\(serverURL)/addressModify", method: .post, parameters: param, headers: header).responseJSON { response in
            switch response.result{
            case .success(let item):
                self.view.networkSuc(resultdata: item, code: "DirectoryModifySucces")
                
            case .failure(let error):
                self.view.networkFail(code: "DirectoryModifyError")
                print(error)
            }
        }
 }

    //    캘린더 통신
    func CalendarList(department: String){
        let param = ["department": department]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        
        Alamofire.request("\(serverURL)/calendarSelect/", method: .post, parameters: param, headers: header).responseJSON { response in
            switch response.result{
            case .success(let item):
                self.view.networkSuc(resultdata: item, code: "calendarListSuccess")
                
            case .failure(let error):
                self.view.networkFail(code: "calendarListError")
                print(error)
            }
        }
    }
    
    //    캘린더 등록
    func upLoadCalendar(scheduleTitle: String, startTime: String, position: String, memo: String, department: String, endTime: String, startDate: String, endDate: String){
        let param = ["scheduleTitle": scheduleTitle, "startTime": startTime, "position": position, "memo":memo, "department":department, "endTime":endTime, "startDate":startDate, "endDate":endDate]
        
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        
        Alamofire.request("\(serverURL)/calendarSave/", method: .post, parameters: param, headers: header).responseJSON { response in
            switch response.result{
            case .success(let item):
                self.view.networkSuc(resultdata: item, code: "CalendarSaveSuccess")
                
            case .failure(let error):
                self.view.networkFail(code: "CalendarSaveFail")
                print(error)
            }
        }
    }
    
    //    캘린더 수정
    func modifyCalendar(scheduleTitle: String, endTime: String, position: String, memo: String, department: String, startTime: String, scheduleId: String){
        let param = ["scheduleTitle": scheduleTitle, "endTime": endTime, "position": position, "memo":memo, "department":department, "startTime":startTime, "scheduleId":scheduleId]
        
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        
        Alamofire.request("\(serverURL)/calendarModify/", method: .post, parameters: param, headers: header).responseJSON { response in
            switch response.result{
            case .success(let item):
                self.view.networkSuc(resultdata: item, code: "CalendarModifySuccess")
                
            case .failure(let error):
                self.view.networkFail(code: "CalendarModifyFail")
                print(error)
            }
        }
    }
    
    //  캘린더 삭제
    func deleteCalendar(scheduleId: Int){
        let param = ["scheduleId":scheduleId]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        
        Alamofire.request("\(serverURL)/calendarDelete/", method: .post, parameters: param, headers: header).responseJSON { response in
            switch response.result{
            case .success(let item):
                self.view.networkSuc(resultdata: item, code: "CalendarDeleteSuccess")
                
            case .failure(let error):
                self.view.networkFail(code: "CalendarDeleteError")
                print(error)
            }
        }
    }
}

