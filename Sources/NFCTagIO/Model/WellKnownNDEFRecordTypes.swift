//
//  File.swift
//  
//
//  Created by yusuga on 2023/08/19.
//

import Foundation

/// Well-known NDEF Record Types
/// - SeeAlso: https://nfc-forum.org/build/assigned-numbers
public enum WellKnownNDEFRecordType: String, Hashable {

  case Di
  case Gc
  case Hc
  case Hi
  case Hm
  case Hr
  case Hs
  case Mr
  case Mt
  case PHD
  case Sig
  case Sp
  case T
  case Te
  case Tp
  case Ts
  case U
  case V
  case WLCCAP
  case WLCCTL
  case WLCFOD
  case WLCINF

  init(data: Data, encoding: String.Encoding = .utf8) throws {
    guard let rawValue = String(data: data, encoding: encoding) else {
      throw WellKnownNDEFRecordTypeError.invalidDataEncoding
    }
    guard let value = Self(rawValue: rawValue) else {
      throw WellKnownNDEFRecordTypeError.unknownRecordType
    }
    self = value
  }
}

extension WellKnownNDEFRecordType: CustomStringConvertible {

  public var description: String {
    switch self {
    case .Di: "Device Information"
    case .Gc: "Generic Control"
    case .Hc: "Handover Carrier"
    case .Hi: "Handover Initiate"
    case .Hm: "Handover Mediation"
    case .Hr: "Handover Request"
    case .Hs: "Handover Select"
    case .Mr: "Money Transfer Response"
    case .Mt: "Money Transfer Request"
    case .PHD: "Personal Health Device"
    case .Sig: "Signature"
    case .Sp: "Smart Poster"
    case .T: "Text"
    case .Te: "TNEP Status"
    case .Tp: "Service Parameter"
    case .Ts: "Service Select"
    case .U: "URI"
    case .V: "Verb"
    case .WLCCAP: "WLC Capability"
    case .WLCCTL: "WLC Listen Control"
    case .WLCFOD: "WLC JiFOD"
    case .WLCINF: "WLC Poll Information"
    }
  }
}

public extension WellKnownNDEFRecordType {

  var fullURIReference: String {
    switch self {
    case .Di: "urn:nfc:wkt:Di"
    case .Gc: "urn:nfc:wkt:Gc"
    case .Hc: "urn:nfc:wkt:Hc"
    case .Hi: "urn:nfc:wkt:Hi"
    case .Hm: "urn:nfc:wkt:Hm"
    case .Hr: "urn:nfc:wkt:Hr"
    case .Hs: "urn:nfc:wkt:Hs"
    case .Mr: "urn:nfc:wkt:Mr"
    case .Mt: "urn:nfc:wkt:Mt"
    case .PHD: "urn:nfc:wkt:PHD"
    case .Sig: "urn:nfc:wkt:Sig"
    case .Sp: "urn:nfc:wkt:Sp"
    case .T: "urn:nfc:wkt:T"
    case .Te: "urn:nfc:wkt:Te"
    case .Tp: "urn:nfc:wkt:Tp"
    case .Ts: "urn:nfc:wkt:Ts"
    case .U: "urn:nfc:wkt:U"
    case .V: "urn:nfc:wkt:V"
    case .WLCCAP: "urn:nfc:wkt:WLCCAP"
    case .WLCCTL: "urn:nfc:wkt:WLCCTL"
    case .WLCFOD: "urn:nfc:wkt:WLCFOD"
    case .WLCINF: "urn:nfc:wkt:WLCINF"
    }
  }

  var specificationReference: String {
    switch self {
    case .Di: "Device Information Record Type Definition"
    case .Gc: "Generic Control Record Type Definition**"
    case .Hc: "Connection Handover"
    case .Hi: "Connection Handover"
    case .Hm: "Connection Handover"
    case .Hr: "Connection Handover"
    case .Hs: "Connection Handover"
    case .Mr: "NFC Money Transfer"
    case .Mt: "NFC Money Transfer"
    case .PHD: "Personal Health Device Communication"
    case .Sig: "Signature Record Type Definition"
    case .Sp: "Smart Poster Record Type Definition"
    case .T: "Text Record Type Definition"
    case .Te: "Tag NDEF Exchange Protocol"
    case .Tp: "Tag NDEF Exchange Protocol"
    case .Ts: "Tag NDEF Exchange Protocol"
    case .U: "URI Record Type Definition"
    case .V: "Verb Record Type Definition"
    case .WLCCAP: "Wireless Charging"
    case .WLCCTL: "Wireless Charging"
    case .WLCFOD: "Wireless Charging"
    case .WLCINF: "Wireless Charging"
    }
  }
}
