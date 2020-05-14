//
//  NCBDateFormatter.swift
//  NCBApp
//
//  Created by Thuan on 3/31/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

/** NCBDateFormatter Class
 
 */
class NCBDateFormatter {
    
    static let sharedInstance = NCBDateFormatter()
    
    private init(){}
}

var yyyyMMddUTCFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            
            return dateFormatter
        }()
    }
    
    return Static.instance
}

var yyyyMMddFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            return dateFormatter
        }()
    }
    
    return Static.instance
}

var yyyyMMddHHmmssFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            
            return dateFormatter
        }()
    }
    
    return Static.instance
}

var yyyyMMddHHmmss: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            
            return dateFormatter
        }()
    }
    
    return Static.instance
}

var ddMMyyyyFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            return dateFormatter
        }()
    }
    
    return Static.instance
}

var yyyyMMdd: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            
            return dateFormatter
        }()
    }
    
    return Static.instance
}

var monthYearFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/yyyy"
            
            return dateFormatter
        }()
    }
    
    return Static.instance
}

var dateTimeFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            
            return dateFormatter
        }()
    }
    
    return Static.instance
}

var hh24mmFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            return dateFormatter
        }()
    }
    
    return Static.instance
}

var hhmmAmPmFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            
            return dateFormatter
        }()
    }
    
    return Static.instance
}

var hh12mmFormatter: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm"
            
            return dateFormatter
        }()
    }
    
    return Static.instance
}

var yyMM: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyMM"
            
            return dateFormatter
        }()
    }
    
    return Static.instance
}

var MMyy: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/yy"
            
            return dateFormatter
        }()
    }
    
    return Static.instance
}

var ddMMyy: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy"
            
            return dateFormatter
        }()
    }
    
    return Static.instance
}

var statementMonthDf: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMyy"
            
            return dateFormatter
        }()
    }
    
    return Static.instance
}

var HHmmss: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HHmmss"
            
            return dateFormatter
        }()
    }
    
    return Static.instance
}

var HHmmssSSS: DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HHmmssSSS"
            
            return dateFormatter
        }()
    }
    
    return Static.instance
}
