function openConfirm() {
  document.getElementById('confirmModal').classList.add('show');
}

function closeConfirm() {
  document.getElementById('confirmModal').classList.remove('show');
}

function showDone() {
  closeConfirm();

  fetch("addCart.jsp", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: new URLSearchParams({
      proId: document.querySelector('input[name="proId"]').value,
      quantity: document.querySelector('input[name="quantity"]').value
    })
  })
  .then(() => {
    document.getElementById('doneModal').classList.add('show');
  });
}

function closeDone() {
  document.getElementById('doneModal').classList.remove('show');
}

// 👉 장바구니 이동 버튼
function goCart() {
  window.location.href = "/cart.jsp";
}
