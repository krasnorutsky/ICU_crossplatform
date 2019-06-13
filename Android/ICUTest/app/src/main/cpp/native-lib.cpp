#include <jni.h>
#include <string>
#include <vector>
#include <algorithm>
#include "StringCompare.hpp"

using namespace std;

extern "C" JNIEXPORT jstring JNICALL
Java_com_mkrasnorutsky_icutest_MainActivity_stringFromJNI(
        JNIEnv *env,
        jobject /* this */) {

    vector<string> toSort;
    toSort.push_back(u8"Здравствуйте");
    toSort.push_back(u8"я");
    toSort.push_back(u8"ваша");
    toSort.push_back(u8"тётя");

    shared_ptr<StringCompare> comparator = StringCompare::create("ru");

    sort(toSort.begin(), toSort.end(), [&comparator](string& a, string& b)->bool
    {
        return comparator->compare(a,b);
    });

   string hello = "Sorted:";

   for (auto& s : toSort)
   {
       hello += " ";
       hello += s;
   }

    return env->NewStringUTF(hello.c_str());
}
