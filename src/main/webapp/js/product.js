let selectedColor = "";
let selectedSize = "";
let selectedStock = 0;

const colorButtons = document.querySelectorAll(".color");
const sizeButtons = document.querySelectorAll(".size");

const selectedColorInput = document.getElementById("selectedColor");
const selectedSizeInput = document.getElementById("selectedSize");
const selectedOptionIdInput = document.getElementById("selectedOptionId");

const displayQty = document.getElementById("displayQty");
const cartQuantity = document.getElementById("cartQuantity");

const minusBtn = document.querySelector(".btn-qty-minus");
const plusBtn = document.querySelector(".btn-qty-plus");

function findSelectedOption() {
  if (selectedColor === "" || selectedSize === "") {
    selectedOptionIdInput.value = "";
    selectedStock = 0;
    return;
  }

  const option = optionList.find(function(item) {
    return item.color === selectedColor && item.size === selectedSize;
  });

  if (option) {
    selectedOptionIdInput.value = option.optionId;
    selectedStock = option.stock;

    if (selectedStock <= 0) {
      alert("선택한 옵션은 품절입니다.");
      selectedOptionIdInput.value = "";
      return;
    }

    displayQty.value = "1";
    cartQuantity.value = "1";
  } else {
    selectedOptionIdInput.value = "";
    selectedStock = 0;
    alert("선택할 수 없는 옵션 조합입니다.");
  }
}

colorButtons.forEach(function(btn) {
  btn.addEventListener("click", function() {
    colorButtons.forEach(function(b) {
      b.classList.remove("selected");
    });

    btn.classList.add("selected");

    selectedColor = btn.dataset.color;
    selectedColorInput.value = selectedColor;

    findSelectedOption();
  });
});

sizeButtons.forEach(function(btn) {
  btn.addEventListener("click", function() {
    sizeButtons.forEach(function(b) {
      b.classList.remove("selected");
    });

    btn.classList.add("selected");

    selectedSize = btn.dataset.size;
    selectedSizeInput.value = selectedSize;

    findSelectedOption();
  });
});

minusBtn.addEventListener("click", function() {
  let qty = parseInt(displayQty.value);

  if (qty > 1) {
    qty--;
    displayQty.value = qty;
    cartQuantity.value = qty;
  }
});

plusBtn.addEventListener("click", function() {
  let qty = parseInt(displayQty.value);

  if (selectedOptionIdInput.value === "") {
    alert("색상과 사이즈를 먼저 선택해주세요.");
    return;
  }

  if (qty >= selectedStock) {
    alert("재고 수량보다 많이 담을 수 없습니다.");
    return;
  }

  qty++;
  displayQty.value = qty;
  cartQuantity.value = qty;
});

function openConfirm() {
  if (selectedColorInput.value === "") {
    alert("색상을 선택해주세요.");
    return;
  }

  if (selectedSizeInput.value === "") {
    alert("사이즈를 선택해주세요.");
    return;
  }

  if (selectedOptionIdInput.value === "") {
    alert("선택한 옵션 정보를 확인할 수 없습니다.");
    return;
  }

  document.getElementById("confirmModal").classList.add("show");
}

function closeConfirm() {
  document.getElementById("confirmModal").classList.remove("show");
}

function submitCart() {
  document.getElementById("cartForm").submit();
}

function closeDone() {
  const doneModal = document.getElementById("doneModal");

  if (doneModal) {
    doneModal.classList.remove("show");
  }

  const url = new URL(window.location.href);
  url.searchParams.delete("cart");
  window.history.replaceState({}, document.title, url.toString());
}