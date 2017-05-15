<%inherit file="../base.mak"/>

<a href="../../library/">&lt;&lt;</a>
<h1>${name}</h1>

<p>${blurb.replace('\n\n', '<p>')}</p>

<ul>
%if 'by' in context.keys():
<li><b>By</b>: ${by}
%endif
%if 'length' in context.keys():
<li><b>Length</b>: ${length}
%endif
%if 'size' in context.keys():
<li><b>Size</b>: ${size} players
%endif
%if 'url' in context.keys():
<li><a href="${url}"><b>Download</b></a>
%endif
%if 'static' in context.keys():
<li><a href="materials.html">Get Materials</a>
%endif
</ul>

<p><small>If you have feedback, questions, or suggestions, email
library@floating-worlds.org.</small></p>
