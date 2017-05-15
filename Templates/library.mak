<%inherit file="base.mak"/>

<h1>Floating Worlds Library</h1>

<p>A compendium of LARPs (live-action roleplaying games), available here
and elsewhere, for your enjoyment and inspiration.

<p>Other good sources for LARPs:
<ul>
<li><a href="http://library.interactiveliterature.org/">the NEIL Larp
Library</a>
<li><a href="https://wiki.rpg.net/index.php/LARP_Scenarios">the
RPGnet
Wiki</a>
<li><a href="http://www.interactivitiesink.com/larps/">Interactives
Ink</a>
<li><a href="http://www.paracelsus-games.com/theatrical-experiences/">Paracelsus Games</a>
<li><a href="http://peakygames.wikidot.com/">Peaky Games</a>
</ul>

<h2>Games Archived Here</h2>

<table border="1">
<tr><th>Name</th><th>Premise</th><th>By</th><th>Size</th><th>Length</th></tr>

%for g in games:
<tr><td><a href="../game/${g['name']}/">${g['name']}</a></td><td>${g['desc']}</td><td>${g['by']}</td><td>${g.get('size', '')}</td><td>${g.get('length', '')}</td></tr>
%endfor

</table>

<h2>Other Recommended Games</h2>

<table border="1">
<tr><th>Name</th><th>Premise</th><th>By</th><th>Size</th><th>Length</th></tr>

%for g in recommended:
<tr><td><a href="../game/${g['name']}/">${g['name']}</a></td><td>${g['desc']}</td><td>${g['by']}</td><td>${g.get('size', '')}</td><td>${g.get('length', '')}</td></tr>
%endfor

</table>

<p><small>If you have feedback, questions, or suggestions, or want to
    submit a game, email library@floating-worlds.org.</small></p>
