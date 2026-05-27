function openConfirm() {
  document.getElementById('confirmModal').classList.add('show');
}

function closeConfirm() {
  document.getElementById('confirmModal').classList.remove('show');
}

function showDone() {
  // confirm 모달 닫기
  closeConfirm();

  // 장바구니 저장 (서버 요청)
  document.getElementById('cartForm').submit();

  // 완료 모달 띄우기
  document.getElementById('doneModal').classList.add('show');
}

function closeDone() {
  document.getElementById('doneModal').classList.remove('show');
}

// 👉 장바구니 이동 버튼
function goCart() {
  window.location.href = "/cart.jsp";
}