# -*- coding: utf-8 -*-
import re, sys, os
import yaml
from mako.template import Template
from mako.lookup import TemplateLookup

def WalkTree(d, exclude_products=False):
    assert d.endswith('/'), d
    matches = []
    for root, dirnames, filenames in os.walk(d):
        if ('/.' in root or root.startswith(d + 'Out')
            or root.startswith(d + 'static') 
            or root.startswith(d + 'Library')):
            continue
        for filename in filenames:
            if (filename.endswith('~') or filename.endswith('.pyc')
                or filename.startswith('.')):
                continue
            if root == d and exclude_products and (
                filename.endswith('.log') or filename.endswith('.pdf')
                or filename.endswith('.out')):
                continue
            if filename.startswith('run') and filename.endswith('-LIST.tex'):
                continue
            matches.append(os.path.join(root, filename))
    return matches

def get_name(f):
    if str(f).endswith('game.yaml'):
        return str(f).split('/')[-2]
    else:
        return os.path.basename(str(f)).rsplit('.', 1)[0]

def get_game(yamlf, include_locals):
    with open(str(yamlf)) as fil:
        d = yaml.load(fil)
    for k in d:
        assert k in ('desc', 'blurb', 'by', 'size', 'length', 'url',
                     'characters', 'game', 'type'), (
            str(yamlf), k)
    d['name'] = get_name(yamlf)
    d['title'] = d['name']
    if 'blurb' not in d:
        d['blurb'] = d['desc']
    if include_locals:
        static = 'Games/%s/static/' % d['name']
        d['static'] = [f[len(static):]
                         for f in WalkTree(static) if not f.startswith('.')]
        d['static'].sort(key=lambda s: ' ' + s
                         if s.startswith('instructions') or s.startswith('gm')
                         else s)
        if 'characters' in d:
            d['example'] = []
            dirname = 'Games/%s/example/' % d['name']
            for root, directories, filenames in os.walk(dirname):
                for f in filenames:
                    d['example'].append(os.path.join(root[len(dirname):], f))
            d['example'].sort(key=lambda s: (s.count('/'), s))
    return d

def yaml_mako(local):
    def yaml_mako_impl(target, source, env):
        makof, yamlf = source
        tmpl = Template(filename=str(makof), default_filters=['decode.utf8'],
                        lookup=TemplateLookup(directories=['Templates']))
        d = get_game(yamlf, local)
        d['prefix'] = '../../'
        rendered = tmpl.render(**d)
        with open(str(target[0]), 'w') as fil:
            fil.write(rendered.encode('utf-8'))
    return yaml_mako_impl

games = []
recommended = []

for yamlf in Glob('Games/*/game.yaml'):
    games.append(yamlf)
    stem = str(yamlf).rsplit('/', 2)[-2]
    htmlf = 'docs/game/' + stem + '/index.html'
    c = Command(htmlf, ['Templates/game.mak', yamlf], yaml_mako(True))
    Depends(c, 'SConstruct')
    Depends(c, 'Templates/base.mak')
    materialsf = 'docs/game/' + stem + '/materials.html'
    c = Command(materialsf, ['Templates/materials.mak', yamlf], yaml_mako(True))
    Depends(c, 'SConstruct')
    Depends(c, 'Templates/base.mak')
    Depends(c, 'Games/%s/' % stem)
    Depends(c, Glob('Games/%s/*' % stem))

    c = Zip('docs/game/%s/%s.zip' % (stem, stem),
            Glob('Games/%s/static/*' % stem)
            + Glob('Games/%s/static/*/*' % stem),
            ZIPROOT='Games/%s/static/' % stem)
    Depends(c, 'SConstruct')

    c = Zip('docs/game/%s/source.zip' % (stem),
            WalkTree('Games/%s/source/' % stem, exclude_products=True),
            ZIPROOT='Games/%s/source/' % stem)
    Depends(c, 'SConstruct')

for yamlf in Glob('Games/*.yaml'):
    recommended.append(yamlf)
    stem = str(yamlf)[len('Games/'):-len('.yaml')]
    htmlf = 'docs/game/' + stem + '/index.html'
    c = Command(htmlf, ['Templates/game.mak', yamlf], yaml_mako(False))
    Depends(c, 'SConstruct')
    Depends(c, 'Templates/base.mak')

def make_index(title, prefix, gamefs=None, recommendedfs=None):
    def make_index_impl(target, source, env):
        makof = source[0]
        tmpl = Template(filename=str(makof),
                        lookup=TemplateLookup(directories=[
                    os.path.dirname(os.path.dirname(os.path.abspath(str(makof))))]))
        d = dict(title=title, prefix=prefix)
        if gamefs:
            d['games'] = [get_game(yamlf, False) for yamlf in gamefs]
        if recommendedfs:
            recgames = {}
            for yamlf in recommendedfs:
                g = get_game(yamlf, False)
                if g['type'] not in recgames:
                    recgames[g['type']] = []
                recgames[g['type']].append(g)
            d['recommended'] = recgames
                
        rendered = tmpl.render(**d)
        with open(str(target[0]), 'w') as ofil:
            ofil.write(rendered.encode('utf-8'))
    return make_index_impl

for s in Glob('Games/*/static') + Glob('Games/*/example'):
    _, rest = str(s).split('/', 1)
    c = Command('docs/game/%s' % (rest),
                s,
                Copy('$TARGET', '$SOURCE'))            
    Depends(c, Glob(str(s) + '/*'))
    Depends(c, Glob(str(s) + '/*/*'))

c = Command('docs/index.html',
            ['Templates/index.mak'],
            make_index('Events', ''))
Depends(c, 'SConstruct')
Depends(c, 'Templates/base.mak')

c = Command('docs/library/index.html',
            ['Templates/library.mak'] + games + recommended,
            make_index('Library', '../', games, recommended))
Depends(c, 'Templates/base.mak')
Depends(c, 'SConstruct')
