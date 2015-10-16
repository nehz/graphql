# -*- coding: utf-8 -*-

cdef extern from 'c/GraphQLAstNode.h':
    struct GraphQLAstNode
    void graphql_node_free(GraphQLAstNode* node)

cdef extern from 'c/GraphQLParser.h':
    GraphQLAstNode* graphql_parse_string(char* text, char** error)


class GraphQLError(Exception):
    pass


cdef class AstNode:
    cdef GraphQLAstNode* ptr

    @staticmethod
    cdef create(GraphQLAstNode* ptr):
        ast_node = AstNode()
        ast_node.ptr = ptr
        return ast_node

    def __dealloc__(self):
        graphql_node_free(self.ptr)


def parse(query):
    query = query.encode('utf8')
    cdef char* c_query = query
    cdef const char* c_err = NULL
    cdef GraphQLAstNode* ast = graphql_parse_string(c_query, &c_err)
    if not ast:
        if not c_err:
            raise GraphQLError('Unknown error')
        raise GraphQLError(c_err.decode('utf-8'))
    return AstNode.create(ast)
