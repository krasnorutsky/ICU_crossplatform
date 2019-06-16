//
//  StringCompare_android.cpp
//  iAstrologer
//
//  Created by Mikhail Krasnorutsky on 27/04/2019.
//

#include "StringCompare.hpp"

using namespace std;

#if 0
#include "toolset_android.hpp"

class AndroidStringCompare : public StringCompare
{
    JNIEnv* env;
    jobject nativeComparator;
    jmethodID compareMethodID;
public:
    AndroidStringCompare(string localeId);
    ~AndroidStringCompare();
    
    bool compare(const string& a, const string& b) override;
};

StringCompare::StringCompare(string localeId) : localeId_(localeId) {}

shared_ptr<StringCompare> StringCompare::create(string  localeId)
{
    return static_pointer_cast<StringCompare>(make_shared<AndroidStringCompare>(localeId));
}

AndroidStringCompare::AndroidStringCompare(string localeId) : StringCompare(localeId)
{
    if (env = get_JNIEnv())
    {
        if (auto jcls=env->FindClass("com/mkrasnorutsky/astrologerxp/StringCompare"))
        {
            if (auto constructor = env->GetMethodID(jcls,
                                      "<init>","(Ljava/lang/String;)V"))
            {
                if (compareMethodID = env->GetMethodID(jcls,
                                                   "compare","(Ljava/lang/String;Ljava/lang/String;)I"))
                {
                    if (auto nativeComparator_ = env->NewObject(jcls, constructor, env->NewStringUTF(to_string(localeId).c_str())))
                    {
                        nativeComparator = env->NewGlobalRef(nativeComparator_);
                        env->DeleteLocalRef(nativeComparator_);
                    }
                }
            }
        }
    }
}

AndroidStringCompare::~AndroidStringCompare()
{
    if (env &&
        nativeComparator)
    {
        env->DeleteGlobalRef(nativeComparator);
    }
}

bool AndroidStringCompare::compare(const string& a, const string& b)
{
    if (nativeComparator)
    {
        auto a_ = env->NewStringUTF(a.c_str());
        auto b_ = env->NewStringUTF(b.c_str());
        
        auto rv = env->CallIntMethod(nativeComparator,
                                     compareMethodID,
                                     a_,
                                     b_);
        
        env->DeleteLocalRef(a_);
        env->DeleteLocalRef(b_);
        
        return rv < 0;
    }
    
    return false;
}
#else

#include <stdio.h>
#include <unicode/unistr.h>
#include <unicode/utypes.h>
#include <unicode/locid.h>
#include <unicode/coll.h>
#include <unicode/tblcoll.h>
#include <unicode/coleitr.h>
#include <unicode/sortkey.h>

using namespace icu;

class ICUStringCompare : public StringCompare
{
    Locale icuLocale;
    Collator* icuCollator;
    
    UBool collateWithLocaleInCPP(UErrorCode& status, bool& lesser, const string& aStr, const string& bStr);
public:
    ICUStringCompare(string localeId);
    ~ICUStringCompare();
    
    bool compare(const string& a, const string& b) override;
};

StringCompare::StringCompare(string localeId) : localeId_(localeId) {}

shared_ptr<StringCompare> StringCompare::create(string localeId)
{
    return static_pointer_cast<StringCompare>(make_shared<ICUStringCompare>(localeId));
}

ICUStringCompare::ICUStringCompare(string localeId) : StringCompare(localeId)
{
    icuLocale = Locale(localeId.c_str());
    
    UErrorCode status = U_ZERO_ERROR;
    icuCollator = Collator::createInstance(icuLocale, status);
    if (U_FAILURE(status))
    {
        UnicodeString dispName;
        icuLocale.getDisplayName(dispName);
        /*Report the error with display name... */
        //fprintf(stderr, "%s: Failed to create the collator for : \"%s\"\n", dispName);
        icuCollator = nullptr;
    }
}

ICUStringCompare::~ICUStringCompare()
{
    if (icuCollator)
    {
        delete icuCollator;
    }
}

UBool ICUStringCompare::collateWithLocaleInCPP(UErrorCode& status, bool& lesser, const string& aStr, const string& bStr)
{
    //UnicodeString dispName;
    UnicodeString source(aStr.c_str(),aStr.size(),"UTF-8");
    UnicodeString target(bStr.c_str(),bStr.size(),"UTF-8");
    
#if 0
    result = icuCollator->compare(source, target);
    /* result is 1, secondary differences only for ignorable space characters*/
    if (result != UCOL_LESS)
    {
        fprintf(stderr,
                "Comparing two strings with only secondary differences in C failed.\n");
        return FALSE;
    }
#endif
#if 0
    /* To compare them with just primary differences */
    myCollator->setStrength(Collator::PRIMARY);
    result = icuCollator->compare(source, target);
    /* result is 0 */
    if (result != 0)
    {
        fprintf(stderr,
                "Comparing two strings with no differences in C failed.\n");
        return FALSE;
    }
    /* Now, do the same comparison with keys */
#endif
    CollationKey sourceKey;
    CollationKey targetKey;
    icuCollator->getCollationKey(source, sourceKey, status);
    icuCollator->getCollationKey(target, targetKey, status);
    
    Collator::EComparisonResult result = sourceKey.compareTo(targetKey);
    lesser = result==Collator::LESS;
    
    return TRUE;
}

bool ICUStringCompare::compare(const string& a, const string& b)
{
    UErrorCode status = U_ZERO_ERROR;
    bool lesser = false;
    
    if (!icuCollator ||
        !collateWithLocaleInCPP(status,lesser,a,b))
    {
        return false;
    }
    
    return lesser;
}

#endif
