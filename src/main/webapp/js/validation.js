function CheckAddProduct(){

 
    var name=document.getElementById("proName");
    var proPrice=document.getElementById("proPrice");
    var proStock=document.getElementById("proStock");
    var proCont=document.getElementById("proCont");

    
    //상품명 체크
    if(name.value.length<4 || name.value.length>50){
        alert("[상품명]\n최소 4자에서 최대 50자까지 입력하세요");
        name.focus();
        return false;
    }

    //가격 체크
    if(proPrice.value.length==0 || isNaN(proPrice.value)){
        alert("[가격]\n숫자만 입력하세요");
        proPrice.focus();
        return false;
    }
    if(Number(proPrice.value)<0){
        alert("[가격]\n음수를 입력할 수 없습니다");
        proPrice.focus();
        return false;
    }

    if(isNaN(proStock.value)){
        alert("[재고 수]\n숫자만 입력하세요");
        proStock.focus();
        return false;
    }

    //상세 설명 체크
    if(proCont.value.length<100){
        alert("[상세설명]\n최소 100자 이상 입력하세요");
        proCont.focus();
        return false;
    }
    document.newProduct.submit();
}