# -*- coding: utf-8 -*-

from setuptools import setup
from Cython.Distutils.extension import Extension

include_dirs = ['lib', 'lib/libgraphqlparser', 'lib/gen', 'lib/gen/cython']
sources = [
    'lib/libgraphqlparser/JsonVisitor.cpp',
    'lib/libgraphqlparser/parser.tab.cpp',
    'lib/libgraphqlparser/lexer.cpp',
    'lib/libgraphqlparser/GraphQLParser.cpp',
    'lib/gen/Ast.cpp',
]
depends = [
    'lib/gen/cython/graphql_ast.pxd',
]

setup(
    name='graphql',
    version='0.0.4',
    url='https://github.com/nehz/graphql',
    packages=['graphql'],
    ext_modules=[
        Extension('graphql_ext',
                  sources=sources + ['graphql/graphql_ext.pyx'],
                  include_dirs=include_dirs, depends=depends,
                  language='c++',
                  extra_compile_args=['-std=c++11']),
    ],
    install_requires=[
        'Cython < 1'
    ],
)
