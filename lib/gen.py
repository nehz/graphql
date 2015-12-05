# -*- coding: utf-8 -*-

import subprocess
import os

os.environ['PYTHONPATH'] = '%s;%s' % (os.environ.get('PYTHONPATH'), 'ast')


def generate_ast_file(what, output_file):
    script = 'libgraphqlparser/ast/ast.py'
    ast_def = 'libgraphqlparser/ast/ast.ast'
    cmd = 'python %s %s %s' % (script, what, ast_def)
    output = subprocess.check_output(cmd, shell=True, env=os.environ)
    with open(output_file, 'wb') as f:
        f.write(output)


if __name__ == '__main__':
    if not os.path.exists('gen'):
        os.makedirs('gen/cython')
    generate_ast_file('cxx', 'gen/Ast.h')
    generate_ast_file('cxx_visitor', 'gen/AstVisitor.h')
    generate_ast_file('cxx_impl', 'gen/Ast.cpp')
    generate_ast_file('cython_ast', 'gen/cython/graphql_ast.pxd')
