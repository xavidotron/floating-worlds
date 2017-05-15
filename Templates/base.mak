<html>
<head>
  <meta charset="UTF-8" />
  <title>Floating Worlds: ${title}</title>
  <style type="text/css">
body {
  max-width: 1000px;
  margin: auto;
  padding: 10px
}
td,th {
  text-align: center;
  padding: 2px;
}
table { margin: 5ex auto }

h1 a {
  text-decoration: none;
  color: black;
}

.tabs {
  margin: 0 5px;
}
.tabs li {
  display: inline-block;
  border: thin solid black;
  padding: 4px 10px;
  background: lightgrey;
}
.tabs li.current {
  background: white;
  border-bottom: thin solid white;
}
.tabs li a {
  text-decoration: none;
}

.main {
  overflow: auto;
  border: thin solid black;
  margin-top: -1px;
  padding: 1em 2em;
  background: white;
}

</style>
</head>
<body>

<%
tablist = [('Events', prefix), ('Library', prefix + 'library/')]
%>

<h1><a href="${prefix}">Floating Worlds</a></h1>

<ul class="tabs">
%for tab,href in tablist:
  %if title == tab:
    <li class="current">${tab}</li>
  %else:
    <li><a href="${href}">${tab}</a></li>
  %endif
%endfor
</ul>
  
<div class="main">
  ${self.body()}
</div>

</body>
</html>
