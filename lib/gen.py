# -*- coding: utf-8 -*-

import subprocess
import os


def generate_ast_file(what, output_file):
    script = 'libgraphqlparser/ast/ast.py'
    ast_def = 'libgraphqlparser/ast/ast.ast'
    cmd = 'python %s %s %s' % (script, what, ast_def)
    output = subprocess.check_output(cmd, shell=True)
    with open(output_file, 'wb') as f:
        f.write(output)


if __name__ == '__main__':
    if not os.path.exists('gen'):
        os.makedirs('gen/c')
    generate_ast_file('cxx', 'gen/Ast.h')
    generate_ast_file('cxx_visitor', 'gen/AstVisitor.h')
    generate_ast_file('cxx_impl', 'gen/Ast.cpp')
    generate_ast_file('c', 'gen/c/GraphQLAst.h')
    generate_ast_file('c_impl', 'gen/c/GraphQLAst.cpp')
    generate_ast_file('c_visitor_impl', 'gen/c/GraphQLAstForEachConcreteType.h')
