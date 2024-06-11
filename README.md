# Google Play Books
## 검색 화면

<img src="https://github.com/dev-Lena/kidsnote_pre_project/assets/52783516/36fca114-87c1-4fbc-88dd-0e87e2d8029f" width="200" /><img src="https://github.com/dev-Lena/kidsnote_pre_project/assets/52783516/a79f2363-d231-490b-a1d8-b6d362933504" width="200" /><img src="https://github.com/dev-Lena/kidsnote_pre_project/assets/52783516/f33305cb-7a7d-4e4c-9411-5de24ae3c7b7" width="200" /> 

0. 검색바 구현
1. 언더바라인이 있는 탭(Segmented Control) 구현
    - 검색어를 입력 후 탭을 바꾸면 동일한 검색어로 책 타입을 변경하여 검색됩니다. 
    - Book 탭에서는 모든 타입의 책에서 검색하고, eBook 탭은 e북 책에서 검색합니다.
2. 페이지네이션
    - 한 번에 20개의 결과를 가져와 보여줍니다.
    - 스크롤을 아래로 내려 마지막에 도달하면 다음 20개의 결과를 추가로 불러와 보여줍니다.
3. 아래로 당겨 새로고침
    - 아래로 당겨 새로고침을 하면 기존 검색결과는 초기화 되고, 새로 검색한 결과 20개의 책 정보를 불러와 보여줍니다.

| related PR   |      related issue      |  related file |
|----------|:-------------:|------:|
| [#10](https://github.com/dev-Lena/kidsnote_pre_project/pull/10#issue-2343870791), [#11](https://github.com/dev-Lena/kidsnote_pre_project/pull/11#issue-2343899696) |  [#2](https://github.com/dev-Lena/kidsnote_pre_project/issues/2#issue-2331383400), [#4](https://github.com/dev-Lena/kidsnote_pre_project/issues/4) | SearchBook--.** , <br> BookList.swift |

## 도서 정보 화면

<img src="https://github.com/dev-Lena/kidsnote_pre_project/assets/52783516/fa7be373-7e34-44a8-bf7f-cccc6d81cfbe" width="200" /><img src="https://github.com/dev-Lena/kidsnote_pre_project/assets/52783516/9e81eadc-35f2-4b25-9c26-c3e5bccfe060" width="200" /><img src="https://github.com/dev-Lena/kidsnote_pre_project/assets/52783516/f1bb3a06-f809-4c3d-98cd-71aa6ef13406" width="200" /><img src="https://github.com/dev-Lena/kidsnote_pre_project/assets/52783516/b64061e9-3d57-4987-ab2e-a5fde0f2f8bf" width="200" />

0. 도서 정보 상세 화면
    - 책 ID로 요청한 도서 상세 정보 표시
1. 구매하기 버튼 터치시 구매 가능한 링크로 이동
    - 구매하기 버튼 터치시 Alert 창이 뜨고, OK를 누르면 웹뷰로 구매 가능한 링크로 이동합니다.
2. 구매정보 버튼 터치시 가격 정보 확인 가능한 모달 열림
    - 구매정보 버튼 터치시 가격 정보를 확인 가능한 half modal 이 열립니다.
    - 가격 정보는 정가, 소매가 확인이 가능합니다.

| related PR   |      related issue      |  related file |
|----------|:-------------:|------:|
| [#12](https://github.com/dev-Lena/kidsnote_pre_project/pull/12#issue-2345326443) |  [#3](https://github.com/dev-Lena/kidsnote_pre_project/issues/3#issue-2331384292), [#5](https://github.com/dev-Lena/kidsnote_pre_project/issues/5#issue-2333328357) | BookInfo--.** <br> 또는 BookDetail--.**, <br> Book.swift |

## 네트워크
전체 구조

<img src="https://github.com/dev-Lena/kidsnote_pre_project/assets/52783516/fb821ccf-ac71-452f-8a41-70e1175503c5" width="600" />

0. 네트워크 프로토콜 구현 
    - Unit Test를 가능하게 하고 타입에 좀 더 유연하게 하여 확장성을 열어두기 위해 프로토콜을 이용하여 구현했습니다.
      - URLSessionable
      - NetworkRequestable
1. Network Error 처리
    - 문제가 생겼을 경우 원인을 빠르게 찾아 디버깅이 가능하도록 발생할 수 있는 Error 타입에 맞게 Error를 정의하였습니다.
2. 탭에 따라서 URL을 생성할 수 있는 Endpoint 객체를 만들었습니다.
3. 공통으로 API 요청을 할 수 있는 NetworkManager 객체를 구현했습니다.
    - 제내릭을 이용하여 타입에 유연하게 구현하였습니다.
4. 네트워크 단위 테스트 구현
    - 프로토콜을 이용하여 Unit Test를 구현했습니다.
    - 실제 네트워크 통신을 하지 않더라도 MockSession을 만들어서 NetworkManager에 주입해 NetworkManager 객체의 단위 테스트를 구현하였습니다.
5. 책 검색 화면과 도서 정보 화면에 필요한 Repository 구현하였습니다.
    - NetworkManager객체의 메서드를 사용하여 request를 한 뒤, ViewController에서 ReactorKit과 RxSwift와 함께 사용하기 위해 받아온 데이터를 가지고 Single로 전환하여 반환하도록 구현했습니다.

| related PR   |      related issue      |  related file |
|----------|:-------------:|------------:|
| [#9](https://github.com/dev-Lena/kidsnote_pre_project/pull/9#issue-2342652258) |  [#1](https://github.com/dev-Lena/kidsnote_pre_project/issues/1#issue-2331382900), [#6](https://github.com/dev-Lena/kidsnote_pre_project/issues/6#issue-2334745408), [#7](https://github.com/dev-Lena/kidsnote_pre_project/issues/7#issue-2337945421) | BookInfo--.** <br> 또는 BookDetail--.** <br> Book.swift |

## 구현 정보
0. 라이브러리 세팅
    - SnapKit: 코드로 Constraint를 잡기 유용하고 코드 가독성을 높이도록 하기 위해 사용했습니다. 
    - RxSwift, RxCocoa: 반응형 UI를 구현하기 위해 사용했습니다.
    - ReactorKit: Reactor를 사용함으로써 단방향 데이터 스트림, View의 상태와 비즈니스 로직을 관리할 수 있어 사용했습니다.
    - Cosmos: ⭐️모양 평점을 만들어주는 라이브러리를 사용했습니다.
1. Reactor를 이용한 데이터 및 상태 관리, 단방향 스트림 관리
2. SnapKit을 이용하여 constraint 설정
3. Code베이스 UI 구현
4. 네트워크 요청은 aync/await을 사용하였습니다.
    - 라이브러리를 사용하지 않으면서, 가독성이 좋고 사용중인 라이브러리(RxSwift와 ReactorKit)와의 사용을 고려하여 aync/await을 기반으로 네트워크 통신을 구현했습니다.
