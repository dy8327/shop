<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String sessionId=(String) session.getAttribute("sessionId");
%>

<header class="pb-3 mb-4 border-bottom">
    <div class="container">
        <div class="d-flex flex-wrap align-items-center justify-content-center justify-content-lg-start">
            <a href="./books.jsp" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-dark text-decoration-none">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-house-fill" viewBox="0 0 16 16">
                <path d="M8.707 1.5a1 1 0 0 0-1.414 0L.646 7.646a.5.5 0 0 0 .708.708L8 1.707l6.646 6.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293z"/>
                <path d="m8 3.293 6 6V13.5A1.5 1.5 0 0 1 12.5 15h-9A1.5 1.5 0 0 1 2 13.5V9.293z"/>
                </svg>
                <span class="fs-4">SSU</span>
            </a>
            <ul class="nav nav-pills">
                <li class="nav-item"><a href="./books.jsp" class="nav-link">NEW</a></li>
                <li class="nav-item"><a href="./addBook.jsp" class="nav-link">BEST</a></li>
                <li class="nav-item"><a href="./editBook.jsp?edit=update" class="nav-link">ALLCLOTHING</a></li>
                <li class="nav-item"><a href="./editBook.jsp?edit=update" class="nav-link">TOP</a></li>
                <li class="nav-item"><a href="./editBook.jsp?edit=update" class="nav-link">BOTTOM</a></li>
                <li class="nav-item"><a href="./editBook.jsp?edit=update" class="nav-link">DRESS</a></li>
                <li class="nav-item"><a href="./editBook.jsp?edit=update" class="nav-link">ACC</a></li>
            </ul>
        </div>
    </div>
</header>