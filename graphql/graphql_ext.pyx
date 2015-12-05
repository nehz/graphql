# -*- coding: utf-8 -*-

from libcpp.memory cimport unique_ptr
from graphql_ast cimport Node, visit_document


cdef extern from 'GraphQLParser.h' namespace 'facebook::graphql':
    unique_ptr[Node] parseString(const char *text, char **error)


class GraphQLError(Exception):
    pass


def parse(query):
    query = query.encode('utf8')
    cdef char *c_query = query
    cdef const char *c_err = NULL
    cdef Node *ast = parseString(c_query, &c_err).release()
    if not ast:
        if not c_err:
            raise GraphQLError('Unknown error')
        raise GraphQLError(c_err.decode('utf-8'))
    return visit_document(ast)
