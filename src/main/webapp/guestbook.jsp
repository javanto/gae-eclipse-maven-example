<?xml version="1.0" encoding="UTF-8"?>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:directive.page contentType="text/html; charset=UTF-8"
	language="java" isELIgnored="false" />
<jsp:directive.page import="java.util.List" />
<jsp:directive.page import="javax.jdo.PersistenceManager" />
<jsp:directive.page import="com.google.appengine.api.users.User" />
<jsp:directive.page import="com.google.appengine.api.users.UserService" />
<jsp:directive.page
	import="com.google.appengine.api.users.UserServiceFactory" />
<jsp:directive.page import="guestbook.Greeting" />
<jsp:directive.page import="guestbook.PMF" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
<title>GAE + Eclipse + Maven Example - Guestbook</title>
</head>
<body>

<%
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	request.setAttribute("user", user);
%>
<c:if test="${user != null}">
	<p>Hello, <c:out value="${user.nickname}" />! (You can <a
		href="<%=userService.createLogoutURL(request.getRequestURI())%>">sign
	out</a>.)</p>
</c:if>
<c:if test="${user == null}">
	<p>Hello! <a
		href="<%=userService.createLoginURL(request.getRequestURI())%>">Sign
	in</a> to include your name with greetings you post.</p>
</c:if>

<%
	PersistenceManager pm = PMF.get().getPersistenceManager();
	String query = "select from " + Greeting.class.getName();
	List<Greeting> greetings = (List<Greeting>) pm.newQuery(query)
			.execute();
	request.setAttribute("greetings", greetings);
%>
<c:if test="${empty greetings}">
	<p>The guestbook has no messages.</p>
</c:if>
<c:if test="${not empty greetings}">
	<c:forEach items="${greetings}" var="g">
		<c:if test="${g.author == null}">
			<p>An anonymous person wrote:</p>
		</c:if>
		<c:if test="${g.author != null}">
			<p><b><c:out value="${g.author.nickname}" /></b> wrote:</p>
		</c:if>
		<blockquote>
		<c:out value="${g.content}" />
		</blockquote>
	</c:forEach>
</c:if>
<%
	pm.close();
%>
<form action="/sign" method="post">
<div><textarea name="content" rows="3" cols="60"></textarea></div>
<div><input type="submit" value="Post Greeting" /></div>
</form>

</body>
</html>