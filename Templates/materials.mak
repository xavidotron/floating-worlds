<%inherit file="../base.mak"/>

<a href=".">&lt;&lt; Back to ${name}</a>

<h1>Materials for ${name}</h2>

%if 'characters' in context.keys():
<h2>Static Materials</h2>
%endif

<ul>
%for f in static:
  <li><a href="static/${f}">${f}</a>
%endfor
</ul>

%if 'characters' not in context.keys():
<a href="${name}.zip">Download all as zip</a>
%endif

%if 'characters' in context.keys():
<h2>Casting-specific Materials</h2>

<p>Some materials for ${name} depend on casting; particularly,
characters have flexible gender. Here are generic example
versions of these materials for reference; fill out the form below for
versions tailored to your players' preferences.</p>

<ul>
%for f in example:
  <li><a href="example/${f}">${f}</a>
%endfor
</ul>

<form action="http://gameki.xvm.mit.edu/prod/${game}">
<table border="1">
<tr><th>Character</th><th>Gender</th><th>Player Name (Optional)</th></tr>
%for c in sorted(characters, key=lambda c:characters[c]):
<tr>
  <% macro = 'c' + c.replace(' ', '') %>
  <td>${characters[c]} (${c})</td>
  <td><label><input type="radio" name="${macro}-sex" value="\female" /> F</label> <label><input type="radio" name="${macro}-sex" value="\male" /> M</label></td>
  <td><input type="text" name="${macro}-player" /></td>
</tr>
%endfor
</table>
<label>Game Date/Run Name (Optional): <input type="text" name="gamedate" /></label><br />
<input type="submit" value="Produce Casting-specific Materials" />
</form>

%endif

<h2>Source</h2>

<a href="source.zip">Download GameTeX Source</a>

<p><small>If you have feedback, questions, or suggestions, email
library@floating-worlds.org.</small></p>

