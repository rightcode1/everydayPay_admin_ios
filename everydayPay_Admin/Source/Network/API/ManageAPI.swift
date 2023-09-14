//
//  ManageAPI.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/18.
//

import Foundation
import Moya

enum ManageAPI {
  case jobList(param: JobListRequest)
  case jobDetail(id: Int)
  case siteList(id: Int)
  case noticeList(id: Int)
  case noticeDetail(id: Int)
  case noticeRegist(param: NoticeRegistRequest)
  case commentList(boardId: Int)
  case commentRegist(param: CommentRequest)
  case supportList(param: CalendarRequest)
  case calendarList(param: CalendarRequest)
  case scheduleList(param: ScheduleRequest)
  case supportUpdate(id:Int,param: SupportUpdateRequest)
}

extension ManageAPI: TargetType {
  public var baseURL: URL {
    switch self {
    default:
      return URL(string: ApiEnvironment.baseUrl)!
    }
  }
  
  var path: String {
    switch self {
    case .jobList : return "/v1/job/list"
    case .siteList : return "/v1/site/list"
    case .noticeList : return "/v1/board/list"
    case .noticeDetail : return "/v1/board/detail"
    case .noticeRegist : return "/v1/board/register"
    case .commentList : return "/v1/boardComment/list"
    case .commentRegist : return "/v1/boardComment/register"
    case .jobDetail : return "/v1/job/detail"
    case .supportList : return "/v1/support/list"
    case .scheduleList : return "/v1/schedule/list"
    case .calendarList : return "/v1/job/calendar"
    case .supportUpdate : return "/v1/support/update"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case.jobList,
        .jobDetail,
        .noticeList,
        .noticeDetail,
        .siteList,
        .commentList,
        .supportList,
        .scheduleList,
        .calendarList:
      return .get
    case.supportUpdate:
      return .put
    case .commentRegist,
        .noticeRegist:
      return .post
    }
  }
  
  var sampleData: Data {
    return "!!".data(using: .utf8)!
  }
  
  var task: Task {
    switch self {
    case .jobList(let param) :
      return .requestParameters(parameters: param.dictionary ?? [:], encoding: URLEncoding.queryString)
    case .jobDetail(let id) :
      return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
    case .siteList(let id) :
      return .requestParameters(parameters: ["companyId": id], encoding: URLEncoding.queryString)
    case .commentList(let boardId) :
      return .requestParameters(parameters: ["boardId": boardId], encoding: URLEncoding.queryString)
    case .noticeList(let id) :
      return .requestParameters(parameters: ["jobId": id], encoding: URLEncoding.queryString)
    case .noticeRegist(let param) :
      return .requestJSONEncodable(param)
    case .commentRegist(let param) :
      return .requestJSONEncodable(param)
    case .noticeDetail(let id) :
      return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
    case .supportList(let param) :
      return .requestParameters(parameters: param.dictionary ?? [:], encoding: URLEncoding.queryString)
    case .calendarList(let param) :
      return .requestParameters(parameters: param.dictionary ?? [:], encoding: URLEncoding.queryString)
    case .scheduleList(let param) :
      return .requestParameters(parameters: param.dictionary ?? [:], encoding: URLEncoding.queryString)
    case .supportUpdate(let id,let param):
      return .requestCompositeParameters(bodyParameters: param.dictionary ?? [:], bodyEncoding: JSONEncoding.default, urlParameters: ["id": id])
    }
  }
  
  var headers: [String : String]? {
    switch self {
    default:
      if let token = DataHelperTool.token {
        return ["Content-type": "application/json", "Authorization": token]
      } else {
        return ["Content-type": "application/json"]
      }
    }
  }
}


enum SupportUpdate: String, Codable {
  case cancel = "취소"
  case start = "출근"
  case end = "퇴근"
  case review = "평가"
}

struct SupportUpdateRequest: Codable {
  let status: SupportUpdate?
  let customWorkCount: Double?
  
  init(
    status: SupportUpdate? = nil,
    customWorkCount: Double? = nil
  ) {
    self.status = status
    self.customWorkCount = customWorkCount
  }
}

struct SupportUpdateResponse: Codable {
  let statusCode: Int
  let message: String
  let data: SupportUpdateData
}
struct SupportUpdateData: Codable {
  var startHour: String?
  var endHour: String?
  var workCount: Double? //공수
  var customWorkCount: Double?
}


struct JobListRequest: Codable {
  let search: String?
  let companyId: Int?
  let category: String?
  let subCategory: String?
  
  
  init(
    search: String? = nil,
    category: String? = nil,
    subCategory: String? = nil,
    companyId: Int? = nil
  ) {
    self.search = search
    self.category = category
    self.subCategory = subCategory
    self.companyId = companyId
  }
}

struct ManageListResponse: Codable {
  let statusCode: Int
  let message: String
  let list: [ManageData]
}

// MARK: - UserInfoData
struct ManageData: Codable {
  var active: Bool
  var address: String
  var category: String
  var companyName: String
  var createdAt: String
  var diff: String
  var id: Int
  var maxPay: Int?
  var maxPeople: Int?
  var minPay: Int?
  var minPeople: Int?
  var siteId: Int
  var siteName: String
  var status: String
  var subCategory: String
  var workingTime: String?
  var rate: Float?
}
struct ManageDetailResponse: Codable {
  let statusCode: Int
  let message: String
  let data: ManageDetailData
}

// MARK: - UserInfoData
struct ManageDetailData: Codable {
  var pay: Int
  var id: Int
  var category: String
  var cert: String
  var subCategory: String
  var workTerm: String?
  var minPeople: Int
  var address: String
  var minPay: Int?
  var details: String?
  var care: Int
  var maxPeople: Int
  var addressDetail: String
  var workPeople: Int?
  var tax: Int
  var createdAt: String
  var healthInsurance: Int
  var nationalPension: Int
  var etc: String?
  var localTax: Int
  var isWish: Bool
  var employmentInsurance: Int
  var parking: String
  var siteName: String
  var siteId: Int
  var wage: String
  var maxPay: Int?
  var workingTime: String
  var jobSchedule: [CalendarData]
  var startDate: String
  var companyName: String
  var endDate: String
  
  var conditions: String?
  var pcr: String?
  var vaccine: String?
  var charge: String?
}

struct CalendarData: Codable {
  var id,people: Int?
  var deletedAt: String?
  var date,updatedAt,createdAt: String
}
struct SiteList: Codable {
  var address,siteName,companyName,createdAt: String
  var isSelect: Bool = false
}
struct ScheduleRequest: Codable {
  let category: HomeCategory?
  let date: String?
  
  init(
    category: HomeCategory? = nil,
    date: String? = nil
  ) {
    self.category = category
    self.date = date
  }
}

struct ScheduleListResponse: Codable {
  let statusCode: Int
  let message: String
  let list: [ScheduleList]
}
struct ScheduleList: Codable {
  var id: Int
  var detailThumbnail: String?
  var active,isComment: Bool
  var url,title,diff,location,userDiff,thumbnail,createdAt: String
}

struct CalendarRequest: Codable {
  let jobId: Int?
  let date: String?
  
  init(
    jobId: Int? = nil,
    date: String? = nil
  ) {
    self.jobId = jobId
    self.date = date
  }
}


struct CalendarListResponse: Codable {
  let statusCode: Int
  let message: String
  let list: [CalendarList]
}

// MARK: - UserInfoData
struct CalendarList: Codable {
  var count: Int?
  var date: String
  var isSupport: Bool
  var jobScheduleId: Int?
  var supportCount: Int
}
//
//struct ManageSupportListRequest: Codable {
//  let userId: Int?
//  let subCategory: String?
//
//  init(
//    userId: Int? = nil,
//    subCategory: String? = nil
//  ) {
//    self.userId = userId
//    self.subCategory = subCategory
//  }
//}
//
//
//

struct ManageSupportListResponse: Codable {
  let statusCode: Int
  let message: String
  let list: [ManageSupportData]
}

// MARK: - UserInfoData
struct ManageSupportData: Codable {
  var id: Int
  var jobId: Int
  var date: String
  var startHour: String?
  var endHour: String?
  var category: String
  var workCount: Double? //공수
  var customWorkCount: Double?
  var review: Review?
  var user: User
}
struct User: Codable{
  var id: Int
  var birth: String
  var name: String
  var pay: Int
  var averageRate: Int
  var isCert: Bool
  var isComplete: Bool
  var isHealth: Bool
  var diff: String
  var tel: String
  var nation: String?
}
struct OtherUser: Codable{
  var id: Int
  var name: String
  var tel: String
  var thumbnail: String?
}

struct Review: Codable{
  var userId: Int
  var fromUserName: String
  var rate: Int
  var id: Int
  var content: String
  var supportId: Int
  var createdAt: String
}
struct SiteListResponse: Codable {
  let statusCode: Int
  let message: String
  let list: [SiteData]
}

// MARK: - UserInfoData
struct SiteData: Codable {
  
  var active: Bool
  var address: String
//  var addressDetail: String
//  var companyId: Int
  var companyName: String
  var createdAt: String
//  var diff: String
//  var id: Int
//  var latitude: String
//  var longitude: String
  var name: String
//  var wishCount: String
  var category: HomeCategory
  var annualArea: String?
  var builder: String?
  var buildingArea: String?
  var startDate: String?
  var purpose: String?
  var size: String?
  var earthArea: String?
  var endDate: String?
}


struct ManageBoardListResponse: Codable {
  let statusCode: Int
  let message: String
  let list: [BoardList]
}
struct ManageBoardDetailResponse: Codable {
  let statusCode: Int
  let message: String
  let data: BoardList
}

// MARK: - UserInfoData
struct BoardList: Codable {
  var id: Int
  var jobId: Int
  var title: String
  var content: String
  var createdAt: String
  var userName: String
  var siteName: String
  var category: String
  var subCategory: String
  var images:[Image]?
}

struct NoticeRegistRequest: Codable {
  let jobId: Int?
  let title: String?
  let content: String?
  let diff: String?
  
  init(
    jobId: Int? = nil,
    title: String? = nil,
    content: String? = nil,
    diff: String? = nil
  ) {
    self.jobId = jobId
    self.title = title
    self.content = content
    self.diff = diff
  }
}

struct CommentRequest: Codable {
  let boardId: Int?
  let content: String?
  let boardCommentId: Int?
  
  init(
    boardId: Int? = nil,
    content: String? = nil,
    boardCommentId: Int? = nil
  ) {
    self.boardId = boardId
    self.content = content
    self.boardCommentId = boardCommentId
  }
}
struct CommentListResponse: Codable {
  let statusCode: Int
  let message: String
  let list: [CommentList]
}
struct CommentList: Codable {
  var userId: Int
  var content:String
  var depth:Int
  var id: Int
  var boardId: Int
  var createdAt: String
  var user: OtherUser
}



