//
//  StringCompare.hpp
//  iAstrologer
//
//  Created by Mikhail Krasnorutsky on 04/01/2019.
//

#ifndef StringCompare_hpp
#define StringCompare_hpp

#include <string>

class StringCompare
{
protected:
    StringCompare(std::string localeId);
    std::string localeId_;
public:
    StringCompare(const StringCompare&) = delete;
    void operator=(const StringCompare&) = delete;
    
    static std::shared_ptr<StringCompare> create(std::string localeId);
    
    virtual bool compare(const std::string&, const std::string&) = 0;
};

#endif /* StringCompare_hpp */
