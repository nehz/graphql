# -*- coding: utf-8 -*-

from setuptools import setup, Extension
from Cython.Build import cythonize

include_dirs = ['lib/libgraphqlparser', 'lib', 'lib/gen']
sources = [
    'lib/libgraphqlparser/JsonVisitor.cpp',
    'lib/libgraphqlparser/c/GraphQLAstNode.cpp',
    'lib/libgraphqlparser/c/GraphQLAstToJSON.cpp',
    'lib/libgraphqlparser/c/GraphQLAstVisitor.cpp',
    'lib/libgraphqlparser/c/GraphQLParser.cpp',
    'lib/libgraphqlparser/parser.tab.cpp',
    'lib/libgraphqlparser/lexer.cpp',
    'lib/libgraphqlparser/GraphQLParser.cpp',
    'lib/gen/Ast.cpp',
    'lib/gen/c/GraphQLAst.cpp',
    'graphql/graphql_ext.pyx'
]

setup(
    name='graphql',
    version='0.0.1',
    ext_modules=cythonize([
        Extension('graphql_ext', include_dirs=include_dirs, sources=sources)
    ]),
    install_requires=[
        'Cython < 1'
    ],
)
