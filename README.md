# Spec

**Development target**

development target을 9.0 -> **10.0**으로 수정하였습니다.
(사전 협의되었습니다.)

**Open source**

cocoapods을 이용해 사용하였습니다.
list는 Podfile을 참고해주세요.

**Architecture**

RxSwift+MVVM을 기반으로 개발되었습니다.

**Unittest**
- ResponseModelMapping
- Util

# Detail

- **이미지 URL이 없는 경우**

  Response에 thumbnail image url이 오지 않는 경우가 있습니다.
  이 때, 불필요한 imageView 영역을 제거하여 레이아웃을 채웠습니다.
- **한번 본 아이템에 대한 Dimmed처리**

  webview를 진입한 시점에 대한 저장값을 url로 잡았습니다.
  이에따라, 같은 blog, cafe구분없이 같은 웹페이지를 진입한 적이 있다면 같이 dimmed 처리됩니다.
