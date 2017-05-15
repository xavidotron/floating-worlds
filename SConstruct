# -*- coding: utf-8 -*-
import re, sys, os
import yaml
from mako.template import Template
from mako.lookup import TemplateLookup

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
    if include_locals:
        static = 'Games/%s/static' % d['name']
        d['static'] = [f for f in os.listdir(static) if not f.startswith('.')]
        d['static'].sort(key=lambda s: ' ' + s
                         if s.startswith('instructions') or s.startswith('gm')
                         else s)
        if 'characters' in d:
            d['example'] = []
            dirname = 'Games/%s/example/' % d['name']
            for root, directories, filenames in os.walk(dirname):
                for f in filenames:
                    d['example'].append(os.path.join(root[len(dirname):], f))
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
            Glob('Games/%s/static/*' % stem),
            ZIPROOT='Games/%s/static/' % stem)
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
            d['recommended'] = [
                get_game(yamlf, False) for yamlf in recommendedfs]
        rendered = tmpl.render(**d)
        with open(str(target[0]), 'w') as ofil:
            ofil.write(rendered.encode('utf-8'))
    return make_index_impl

for s in Glob('Games/*/*'):
    _, rest = str(s).split('/', 1)
    Command('docs/game/%s' % (rest),
            s,
            Copy('$TARGET', '$SOURCE'))            

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