# -*- coding: utf-8 -*-

from __future__ import print_function

from contextlib import contextmanager
from casing import snake, title

namespace = 'facebook::graphql::ast'

type_map = {
    'OperationKind': 'const char *',
    'string': 'const char *',
    'boolean': 'bool ',
}

decode_map = {
    'OperationKind': 'utf-8',
    'string': 'utf-8',
}

start_file = '''
from libcpp cimport bool
from libcpp.vector cimport vector
from libcpp.memory cimport unique_ptr


cdef extern from 'AstNode.h' namespace 'facebook::graphql::ast':
    cdef cppclass Node:
        pass


cdef extern from "Ast.h" namespace "facebook::graphql::ast":
'''


class Type(object):
    def __init__(self, name):
        self.name = name
        self.fields = []

    def add_field(self, *args):
        self.fields.append(args)


class Union(object):
    def __init__(self, name):
        self.name = name
        self.options = []

    def add_option(self, *args):
        self.options.extend(args)


class Printer(object):
    def out(self, line='', indent=None):
        indent = self.indent if indent is None else indent
        print((' ' * indent * 4) + line.strip())

    def __init__(self):
        self.indent = 0
        self.types = []
        self.unions = []

    def start_block(self):
        self.indent += 1

    def end_block(self):
        self.indent -= 1

    @contextmanager
    def block(self):
        self.start_block()
        yield
        self.end_block()

    def start_file(self):
        self.out(start_file)
        self.start_block()

    def visit_option(self, option):
        option = snake(option)
        self.out('if dynamic_cast_%s(ptr):' % option)
        with self.block():
            self.out('return visit_%s(ptr)' % option)

    def visit_field(self, ast_type, field):
        field_type, name, nullable, plural = field
        ref = '' if nullable else '&'
        if plural:
            vector = 'vector[unique_ptr[%s]] *' % title(field_type)
            self.out('cdef const %s%s = %s(<%s *>ptr).get%s()' %
                     (vector, snake(name), ref, ast_type, title(name)))
            get = '%s[0].at(i).get()' % snake(name)
            size = '%s[0].size() if %s else 0' % (snake(name), snake(name))
            self.out('res["%s"] = [visit_%s(%s) for i in xrange(%s)]' %
                     (snake(name), snake(field_type), get, size))
        else:
            mapped = type_map.get(field_type)
            get = '(<%s *>ptr)[0].get%s()' % (title(ast_type), title(name))
            if mapped:
                assert(not nullable)
                decode = decode_map.get(field_type)
                if decode:
                    self.out('res["%s"] = (<%s>%s).decode("%s")' %
                             (snake(name), mapped, get, decode))
                else:
                    self.out('res["%s"] = <%s>%s' %
                             (snake(name), mapped, get))

            else:
                if nullable:
                    self.out('tmp = %s' % get)
                    self.out('res["%s"] = visit_%s(tmp) if tmp else None' %
                             (snake(name), snake(field_type)))
                else:
                    self.out('res["%s"] = visit_%s(&%s)' %
                             (snake(name), snake(field_type), get))

    def end_file(self):
        self.end_block()
        self.out()
        self.out()
        self.out('cdef extern from *:')
        with self.block():
            for u in self.unions:
                for o in u.options:
                    self.out('const %s *dynamic_cast_%s '
                             '"dynamic_cast<const %s::%s *>" (void *)' %
                             (title(o), snake(o), namespace, title(o)))
        for u in self.unions:
            self.out()
            self.out()
            self.out('cdef inline object visit_%s(const Node *ptr):' %
                     snake(u.name))
            with self.block():
                for o in u.options:
                    self.visit_option(o)

        for t in self.types:
            self.out()
            self.out()
            self.out('cdef inline object visit_%s(const Node *ptr):' %
                     snake(t.name))
            with self.block():
                self.out('cdef const Node *tmp')
                self.out('res = {}')
                for f in t.fields:
                    self.visit_field(t.name, f)
                self.out('return res')

    def start_type(self, name):
        self.types.append(Type(name))
        self.out('cdef cppclass %s(Node):' % name)
        self.start_block()

    def field(self, field_type, name, nullable, plural):
        self.types[-1].add_field(field_type, name, nullable, plural)
        name = 'get%s()' % title(name)
        ref = '*' if nullable else '&'
        if plural:
            self.out('const vector[unique_ptr[%s]] %s%s const' %
                     (field_type, ref, name))
        else:
            mapped = type_map.get(field_type)
            if mapped:
                assert(not nullable)
                self.out('%s%s' % (mapped, name))
            else:
                self.out('const %s %s%s' % (field_type, ref, name))

    def end_type(self, name):
        self.end_block()

    def start_union(self, name):
        self.unions.append(Union(name))
        self.out('cdef cppclass %s(Node):' % name)
        with self.block():
            self.out('pass')

    def union_option(self, option):
        self.unions[-1].add_option(option)

    def end_union(self, name):
        pass
