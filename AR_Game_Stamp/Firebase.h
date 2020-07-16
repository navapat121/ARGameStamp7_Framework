// Copyright 2019 Google
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// The module qualified imports are for CocoaPods and the simple file names
// for Swift Package Manager.

#if !defined(__has_include)
  #error "Firebase.h won't import anything if your compiler doesn't support __has_include. Please \
          import the headers individually."
#else

#if __has_include(<FirebaseCore/FirebaseCore.h>)
  #import <FirebaseCore/FirebaseCore.h>
#elif __has_include("FirebaseCore.h")
  #import "FirebaseCore.h"
#endif

  #if __has_include(<FirebaseAnalytics/FirebaseAnalytics.h>)
    #import <FirebaseAnalytics/FirebaseAnalytics.h>
  #endif


#endif  // defined(__has_include)
