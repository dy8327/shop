function CheckAddProduct(){

    var name = document.getElementById("proName");
    var proPrice = document.getElementById("proPrice");
    var proCont = document.getElementById("proCont");

    var proSizes = document.getElementsByName("proSize");
    var proColors = document.getElementsByName("proColor");
    var proStocks = document.getElementsByName("proStock");

    // 상품명 체크
    if(name.value.length < 4 || name.value.length > 50){
        alert("[상품명]\n최소 4자에서 최대 50자까지 입력하세요");
        name.focus();
        return false;
    }

    // 가격 체크
    if(proPrice.value.length == 0 || isNaN(proPrice.value)){
        alert("[가격]\n숫자만 입력하세요");
        proPrice.focus();
        return false;
    }

    if(Number(proPrice.value) < 0){
        alert("[가격]\n음수를 입력할 수 없습니다");
        proPrice.focus();
        return false;
    }

    // 옵션 체크
    for(var i = 0; i < proSizes.length; i++){

        if(proSizes[i].value == ""){
            alert("[옵션]\n사이즈를 선택하세요");
            proSizes[i].focus();
            return false;
        }

        if(proColors[i].value.trim() == ""){
            alert("[옵션]\n색상을 입력하세요");
            proColors[i].focus();
            return false;
        }

        if(proStocks[i].value.trim() == "" || isNaN(proStocks[i].value)){
            alert("[옵션]\n재고 수량은 숫자만 입력하세요");
            proStocks[i].focus();
            return false;
        }

        if(Number(proStocks[i].value) < 0){
            alert("[옵션]\n재고 수량은 음수를 입력할 수 없습니다");
            proStocks[i].focus();
            return false;
        }
    }

    // 상세 설명 체크
    if(proCont.value.length < 100){
        alert("[상세설명]\n최소 100자 이상 입력하세요");
        proCont.focus();
        return false;
    }

    document.newProduct.submit();
}


function addOption() {
    var optionArea = document.getElementById("optionArea");

    var row = document.createElement("div");
    row.className = "option-row";

    row.innerHTML =
        '<select name="proSize" class="option-size">' +
            '<option value="">사이즈 선택</option>' +
            '<option value="FREE">FREE</option>' +
            '<option value="S">S</option>' +
            '<option value="M">M</option>' +
            '<option value="L">L</option>' +
            '<option value="XL">XL</option>' +
        '</select>' +
        '<input type="text" name="proColor" class="option-color" placeholder="색상 입력">' +
        '<input type="text" name="proStock" class="option-stock" placeholder="재고수량">' +
        '<button type="button" class="option-delete-btn" onclick="removeOption(this)">삭제</button>';

    optionArea.appendChild(row);
}


function removeOption(btn) {
    var optionArea = document.getElementById("optionArea");

    if(optionArea.children.length <= 1){
        alert("옵션은 최소 1개 이상 필요합니다.");
        return false;
    }

    btn.parentElement.remove();
}