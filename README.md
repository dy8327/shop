# 의류 쇼핑몰 프로젝트

JSP/Servlet 기반의 의류 쇼핑몰 웹 프로젝트입니다.  
회원, 상품, 장바구니, 주문, 재고 관리 기능을 중심으로 구현하는 학원 협업 프로젝트입니다.

---

## 프로젝트 소개

본 프로젝트는 사용자가 의류 상품을 조회하고 장바구니에 담아 주문할 수 있는 쇼핑몰 시스템입니다.  
관리자는 상품을 등록하고 재고를 관리할 수 있으며, 주문 시 상품 옵션별 재고가 차감되는 구조를 목표로 합니다.

---

## 개발 목적

- JSP/Servlet 기반 웹 애플리케이션 개발 흐름 이해
- Oracle DB를 활용한 회원, 상품, 주문 데이터 관리
- GitHub를 활용한 협업 및 버전 관리 경험
- 쇼핑몰의 기본 기능인 회원, 상품, 장바구니, 주문 흐름 구현
- 상품 옵션별 재고 관리 구조 설계

---

## 주요 기능

### 사용자 기능

- 회원가입
- 로그인 / 로그아웃
- 상품 목록 조회
- 상품 상세 조회
- 상품 옵션 선택
  - 사이즈
  - 색상
- 장바구니 담기
- 장바구니 수량 변경 및 삭제
- 주문하기
- 주문내역 조회

### 관리자 기능

- 상품 등록
- 상품 수정
- 상품 삭제
- 상품 옵션 등록
- 사이즈 / 색상별 재고 관리
- 주문 목록 확인

---

## 사용 기술

| 구분 | 기술 |
|---|---|
| Language | Java |
| Web | JSP, Servlet |
| Frontend | HTML, CSS, JavaScript |
| Database | Oracle Database |
| Server | Apache Tomcat |
| Version Control | Git, GitHub |
| Tool | VS Code / SQL Developer |

---

## DB 설계

### MEMBERS

회원 정보를 저장하는 테이블입니다.

| 컬럼명 | 설명 |
|---|---|
| MEM_ID | 회원 아이디 |
| MEM_PW | 비밀번호 |
| MEM_NAME | 회원 이름 |
| MEM_PHONE | 전화번호 |
| MEM_EMAIL | 이메일 |
| MEM_ADDRESS | 주소 |
| MEM_GRADE | 회원 등급 |
| MEM_ROLE | 권한 |
| MEM_DATE | 가입일 |

---

### PRODUCTS

상품의 기본 정보를 저장하는 테이블입니다.

| 컬럼명 | 설명 |
|---|---|
| PRO_ID | 상품 번호 |
| PRO_NAME | 상품명 |
| PRO_PRICE | 상품 가격 |
| PRO_CONTENT | 상품 설명 |
| PRO_IMAGE | 상품 이미지 |
| PRO_CATEGORY | 상품 카테고리 |
| PRO_DATE | 상품 등록일 |

---

### PRODUCT_OPTIONS

상품의 옵션과 재고를 저장하는 테이블입니다.  
의류 쇼핑몰 특성상 같은 상품이라도 사이즈와 색상에 따라 재고가 다르기 때문에 별도 테이블로 분리했습니다.

| 컬럼명 | 설명 |
|---|---|
| OPTION_ID | 옵션 번호 |
| PRO_ID | 상품 번호 |
| PRO_SIZE | 사이즈 |
| PRO_COLOR | 색상 |
| PRO_STOCK | 재고 수량 |

---

### CART

장바구니 정보를 저장하는 테이블입니다.

| 컬럼명 | 설명 |
|---|---|
| CART_ID | 장바구니 번호 |
| MEM_ID | 회원 아이디 |
| OPTION_ID | 상품 옵션 번호 |
| CART_QTY | 수량 |
| CART_DATE | 담은 날짜 |

---

### ORDERS

주문 기본 정보를 저장하는 테이블입니다.

| 컬럼명 | 설명 |
|---|---|
| ORDER_ID | 주문 번호 |
| MEM_ID | 회원 아이디 |
| ORDER_DATE | 주문일 |
| ORDER_TOTAL | 총 주문 금액 |
| ORDER_STATUS | 주문 상태 |

---

### ORDER_DETAILS

주문한 상품의 상세 정보를 저장하는 테이블입니다.

| 컬럼명 | 설명 |
|---|---|
| DETAIL_ID | 주문 상세 번호 |
| ORDER_ID | 주문 번호 |
| OPTION_ID | 상품 옵션 번호 |
| ORDER_QTY | 주문 수량 |
| ORDER_PRICE | 주문 당시 상품 가격 |

---

## 프로젝트 구조 예시
```text
shopping-mall-project
├── src
│   └── main
│       ├── java
│       │   ├── controller
│       │   ├── dao
│       │   ├── dto
│       │   └── util
│       └── webapp
│           ├── css
│           ├── js
│           ├── images
│           ├── member
│           ├── product
│           ├── cart
│           ├── order
│           └── admin
├── sql
│   ├── 01_create_tables.sql
│   ├── 02_insert_sample_data.sql
│   └── 03_drop_tables.sql
└── README.md
