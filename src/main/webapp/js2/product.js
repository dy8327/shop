// [1] 수량 증감 버튼 제어 및 동기화
const displayQty = document.getElementById('displayQty');
const cartQuantity = document.getElementById('cartQuantity');
const btnPlus = document.querySelector('.btn-qty-plus');
const btnMinus = document.querySelector('.btn-qty-minus');

if(btnPlus && btnMinus) {
  btnPlus.addEventListener('click', () => {
    let qty = parseInt(displayQty.value) + 1;
    displayQty.value = qty;
    cartQuantity.value = qty;
  });

  btnMinus.addEventListener('click', () => {
    let qty = parseInt(displayQty.value);
    if (qty > 1) {
      displayQty.value = qty - 1;
      cartQuantity.value = qty - 1;
    }
  });
}

// [2] 옵션 상호작용 및 선택 상태 제어
const colorButtons = document.querySelectorAll('.color');
const sizeButtons = document.querySelectorAll('.size');

const selectedColorInput = document.getElementById('selectedColor');
const selectedSizeInput = document.getElementById('selectedSize');
const selectedOptionIdInput = document.getElementById('selectedOptionId');

// 컬러 클릭 시 작동 로직
colorButtons.forEach(btn => {
  btn.addEventListener('click', function() {
    colorButtons.forEach(b => b.classList.remove('selected'));
    this.classList.add('selected');
    
    const pickedColor = this.getAttribute('data-color').trim();
    selectedColorInput.value = pickedColor;

    // 컬러가 바뀌면 이전에 선택되어 있던 사이즈 데이터 리셋
    sizeButtons.forEach(b => b.classList.remove('selected'));
    selectedSizeInput.value = "";
    selectedOptionIdInput.value = "";

    // 고른 컬러에 맞추어 품절 상태 업데이트
    checkSizeStock(pickedColor);
  });
});

// 사이즈 클릭 시 작동 로직
sizeButtons.forEach(btn => {
  btn.addEventListener('click', function() {
    if(!selectedColorInput.value) {
      alert("컬러를 먼저 선택해주세요!");
      return;
    }
    sizeButtons.forEach(b => b.classList.remove('selected'));
    this.classList.add('selected');
    
    const pickedColor = selectedColorInput.value;
    const pickedSize = this.getAttribute('data-size').trim();
    selectedSizeInput.value = pickedSize;
    
    // 두 조건이 부합하는 완벽한 고유 OPTION_ID 탐색
    const matchedOpt = optionList.find(o => o.color === pickedColor && o.size === pickedSize);
    if(matchedOpt) {
      selectedOptionIdInput.value = matchedOpt.optionId;
    }
  });
});

// [3] 품절 버튼 스타일(회색조) 및 클릭 막기 제어 함수
function checkSizeStock(color) {
  sizeButtons.forEach(btn => {
    const size = btn.getAttribute('data-size').trim();
    const opt = optionList.find(o => o.color === color && o.size === size);
    
    // 매칭되는 조합이 아예 없거나 테이블 내 재고(PRO_STOCK) 수량이 0 이하인 경우
    if(!opt || opt.stock <= 0) {
      btn.classList.add('soldout');
      btn.disabled = true;
    } else {
      btn.classList.remove('soldout');
      btn.disabled = false;
    }
  });
}

// [4] 모달 및 비동기 Fetch 전송 처리 로직
function openConfirm() {
  if(!selectedColorInput.value) {
    alert("COLOR를 선택해주세요.");
    return;
  }
  if(!selectedSizeInput.value) {
    alert("SIZE를 선택해주세요.");
    return;
  }
  document.getElementById('confirmModal').classList.add('show');
}

function closeConfirm() {
  document.getElementById('confirmModal').classList.remove('show');
}

function showDone() {
  closeConfirm();

  const proId = document.querySelector('input[name="proId"]').value;
  const optionId = selectedOptionIdInput.value;
  const quantity = cartQuantity.value;

  fetch("addCart.jsp", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: new URLSearchParams({
      proId: proId,
      optionId: optionId,
      quantity: quantity
    })
  })
  .then(response => {
    if(response.ok) {
      document.getElementById('doneModal').classList.add('show');
    } else if(response.status === 401) {
      alert("로그인이 필요한 서비스입니다.");
    } else {
      alert("장바구니 담기 실패. 관리자에게 문의하세요.");
    }
  });
}

function closeDone() {
  document.getElementById('doneModal').classList.remove('show');
}

function goCart() {
  window.location.href = "cart.jsp";
}