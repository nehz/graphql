from libcpp cimport bool
from libcpp.vector cimport vector
from libcpp.memory cimport unique_ptr


cdef extern from 'AstNode.h' namespace 'facebook::graphql::ast':
    cdef cppclass Node:
        pass


cdef extern from "Ast.h" namespace "facebook::graphql::ast":
    cdef cppclass Definition(Node):
        pass
    cdef cppclass Document(Node):
        const vector[unique_ptr[Definition]] &getDefinitions() const
    cdef cppclass OperationDefinition(Node):
        const char *getOperation()
        const Name *getName()
        const vector[unique_ptr[VariableDefinition]] *getVariableDefinitions() const
        const vector[unique_ptr[Directive]] *getDirectives() const
        const SelectionSet &getSelectionSet()
    cdef cppclass VariableDefinition(Node):
        const Variable &getVariable()
        const Type &getType()
        const Value *getDefaultValue()
    cdef cppclass SelectionSet(Node):
        const vector[unique_ptr[Selection]] &getSelections() const
    cdef cppclass Selection(Node):
        pass
    cdef cppclass Field(Node):
        const Name *getAlias()
        const Name &getName()
        const vector[unique_ptr[Argument]] *getArguments() const
        const vector[unique_ptr[Directive]] *getDirectives() const
        const SelectionSet *getSelectionSet()
    cdef cppclass Argument(Node):
        const Name &getName()
        const Value &getValue()
    cdef cppclass FragmentSpread(Node):
        const Name &getName()
        const vector[unique_ptr[Directive]] *getDirectives() const
    cdef cppclass InlineFragment(Node):
        const NamedType &getTypeCondition()
        const vector[unique_ptr[Directive]] *getDirectives() const
        const SelectionSet &getSelectionSet()
    cdef cppclass FragmentDefinition(Node):
        const Name &getName()
        const NamedType &getTypeCondition()
        const vector[unique_ptr[Directive]] *getDirectives() const
        const SelectionSet &getSelectionSet()
    cdef cppclass Value(Node):
        pass
    cdef cppclass Variable(Node):
        const Name &getName()
    cdef cppclass IntValue(Node):
        const char *getValue()
    cdef cppclass FloatValue(Node):
        const char *getValue()
    cdef cppclass StringValue(Node):
        const char *getValue()
    cdef cppclass BooleanValue(Node):
        bool getValue()
    cdef cppclass EnumValue(Node):
        const char *getValue()
    cdef cppclass ArrayValue(Node):
        const vector[unique_ptr[Value]] &getValues() const
    cdef cppclass ObjectValue(Node):
        const vector[unique_ptr[ObjectField]] &getFields() const
    cdef cppclass ObjectField(Node):
        const Name &getName()
        const Value &getValue()
    cdef cppclass Directive(Node):
        const Name &getName()
        const vector[unique_ptr[Argument]] *getArguments() const
    cdef cppclass Type(Node):
        pass
    cdef cppclass NamedType(Node):
        const Name &getName()
    cdef cppclass ListType(Node):
        const Type &getType()
    cdef cppclass NonNullType(Node):
        const Type &getType()
    cdef cppclass Name(Node):
        const char *getValue()


cdef extern from *:
    const OperationDefinition *dynamic_cast_operation_definition "dynamic_cast<const facebook::graphql::ast::OperationDefinition *>" (void *)
    const FragmentDefinition *dynamic_cast_fragment_definition "dynamic_cast<const facebook::graphql::ast::FragmentDefinition *>" (void *)
    const Field *dynamic_cast_field "dynamic_cast<const facebook::graphql::ast::Field *>" (void *)
    const FragmentSpread *dynamic_cast_fragment_spread "dynamic_cast<const facebook::graphql::ast::FragmentSpread *>" (void *)
    const InlineFragment *dynamic_cast_inline_fragment "dynamic_cast<const facebook::graphql::ast::InlineFragment *>" (void *)
    const Variable *dynamic_cast_variable "dynamic_cast<const facebook::graphql::ast::Variable *>" (void *)
    const IntValue *dynamic_cast_int_value "dynamic_cast<const facebook::graphql::ast::IntValue *>" (void *)
    const FloatValue *dynamic_cast_float_value "dynamic_cast<const facebook::graphql::ast::FloatValue *>" (void *)
    const StringValue *dynamic_cast_string_value "dynamic_cast<const facebook::graphql::ast::StringValue *>" (void *)
    const BooleanValue *dynamic_cast_boolean_value "dynamic_cast<const facebook::graphql::ast::BooleanValue *>" (void *)
    const EnumValue *dynamic_cast_enum_value "dynamic_cast<const facebook::graphql::ast::EnumValue *>" (void *)
    const ArrayValue *dynamic_cast_array_value "dynamic_cast<const facebook::graphql::ast::ArrayValue *>" (void *)
    const ObjectValue *dynamic_cast_object_value "dynamic_cast<const facebook::graphql::ast::ObjectValue *>" (void *)
    const NamedType *dynamic_cast_named_type "dynamic_cast<const facebook::graphql::ast::NamedType *>" (void *)
    const ListType *dynamic_cast_list_type "dynamic_cast<const facebook::graphql::ast::ListType *>" (void *)
    const NonNullType *dynamic_cast_non_null_type "dynamic_cast<const facebook::graphql::ast::NonNullType *>" (void *)


cdef inline object visit_definition(const Node *ptr):
    if dynamic_cast_operation_definition(ptr):
        return visit_operation_definition(ptr)
    if dynamic_cast_fragment_definition(ptr):
        return visit_fragment_definition(ptr)


cdef inline object visit_selection(const Node *ptr):
    if dynamic_cast_field(ptr):
        return visit_field(ptr)
    if dynamic_cast_fragment_spread(ptr):
        return visit_fragment_spread(ptr)
    if dynamic_cast_inline_fragment(ptr):
        return visit_inline_fragment(ptr)


cdef inline object visit_value(const Node *ptr):
    if dynamic_cast_variable(ptr):
        return visit_variable(ptr)
    if dynamic_cast_int_value(ptr):
        return visit_int_value(ptr)
    if dynamic_cast_float_value(ptr):
        return visit_float_value(ptr)
    if dynamic_cast_string_value(ptr):
        return visit_string_value(ptr)
    if dynamic_cast_boolean_value(ptr):
        return visit_boolean_value(ptr)
    if dynamic_cast_enum_value(ptr):
        return visit_enum_value(ptr)
    if dynamic_cast_array_value(ptr):
        return visit_array_value(ptr)
    if dynamic_cast_object_value(ptr):
        return visit_object_value(ptr)


cdef inline object visit_type(const Node *ptr):
    if dynamic_cast_named_type(ptr):
        return visit_named_type(ptr)
    if dynamic_cast_list_type(ptr):
        return visit_list_type(ptr)
    if dynamic_cast_non_null_type(ptr):
        return visit_non_null_type(ptr)


cdef inline object visit_document(const Node *ptr):
    cdef const Node *tmp
    res = {}
    cdef const vector[unique_ptr[Definition]] *definitions = &(<Document *>ptr).getDefinitions()
    res["definitions"] = [visit_definition(definitions[0].at(i).get()) for i in xrange(definitions[0].size() if definitions else 0)]
    return res


cdef inline object visit_operation_definition(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["operation"] = (<const char *>(<OperationDefinition *>ptr)[0].getOperation()).decode("utf-8")
    tmp = (<OperationDefinition *>ptr)[0].getName()
    res["name"] = visit_name(tmp) if tmp else None
    cdef const vector[unique_ptr[VariableDefinition]] *variable_definitions = (<OperationDefinition *>ptr).getVariableDefinitions()
    res["variable_definitions"] = [visit_variable_definition(variable_definitions[0].at(i).get()) for i in xrange(variable_definitions[0].size() if variable_definitions else 0)]
    cdef const vector[unique_ptr[Directive]] *directives = (<OperationDefinition *>ptr).getDirectives()
    res["directives"] = [visit_directive(directives[0].at(i).get()) for i in xrange(directives[0].size() if directives else 0)]
    res["selection_set"] = visit_selection_set(&(<OperationDefinition *>ptr)[0].getSelectionSet())
    return res


cdef inline object visit_variable_definition(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["variable"] = visit_variable(&(<VariableDefinition *>ptr)[0].getVariable())
    res["type"] = visit_type(&(<VariableDefinition *>ptr)[0].getType())
    tmp = (<VariableDefinition *>ptr)[0].getDefaultValue()
    res["default_value"] = visit_value(tmp) if tmp else None
    return res


cdef inline object visit_selection_set(const Node *ptr):
    cdef const Node *tmp
    res = {}
    cdef const vector[unique_ptr[Selection]] *selections = &(<SelectionSet *>ptr).getSelections()
    res["selections"] = [visit_selection(selections[0].at(i).get()) for i in xrange(selections[0].size() if selections else 0)]
    return res


cdef inline object visit_field(const Node *ptr):
    cdef const Node *tmp
    res = {}
    tmp = (<Field *>ptr)[0].getAlias()
    res["alias"] = visit_name(tmp) if tmp else None
    res["name"] = visit_name(&(<Field *>ptr)[0].getName())
    cdef const vector[unique_ptr[Argument]] *arguments = (<Field *>ptr).getArguments()
    res["arguments"] = [visit_argument(arguments[0].at(i).get()) for i in xrange(arguments[0].size() if arguments else 0)]
    cdef const vector[unique_ptr[Directive]] *directives = (<Field *>ptr).getDirectives()
    res["directives"] = [visit_directive(directives[0].at(i).get()) for i in xrange(directives[0].size() if directives else 0)]
    tmp = (<Field *>ptr)[0].getSelectionSet()
    res["selection_set"] = visit_selection_set(tmp) if tmp else None
    return res


cdef inline object visit_argument(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["name"] = visit_name(&(<Argument *>ptr)[0].getName())
    res["value"] = visit_value(&(<Argument *>ptr)[0].getValue())
    return res


cdef inline object visit_fragment_spread(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["name"] = visit_name(&(<FragmentSpread *>ptr)[0].getName())
    cdef const vector[unique_ptr[Directive]] *directives = (<FragmentSpread *>ptr).getDirectives()
    res["directives"] = [visit_directive(directives[0].at(i).get()) for i in xrange(directives[0].size() if directives else 0)]
    return res


cdef inline object visit_inline_fragment(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["type_condition"] = visit_named_type(&(<InlineFragment *>ptr)[0].getTypeCondition())
    cdef const vector[unique_ptr[Directive]] *directives = (<InlineFragment *>ptr).getDirectives()
    res["directives"] = [visit_directive(directives[0].at(i).get()) for i in xrange(directives[0].size() if directives else 0)]
    res["selection_set"] = visit_selection_set(&(<InlineFragment *>ptr)[0].getSelectionSet())
    return res


cdef inline object visit_fragment_definition(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["name"] = visit_name(&(<FragmentDefinition *>ptr)[0].getName())
    res["type_condition"] = visit_named_type(&(<FragmentDefinition *>ptr)[0].getTypeCondition())
    cdef const vector[unique_ptr[Directive]] *directives = (<FragmentDefinition *>ptr).getDirectives()
    res["directives"] = [visit_directive(directives[0].at(i).get()) for i in xrange(directives[0].size() if directives else 0)]
    res["selection_set"] = visit_selection_set(&(<FragmentDefinition *>ptr)[0].getSelectionSet())
    return res


cdef inline object visit_variable(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["name"] = visit_name(&(<Variable *>ptr)[0].getName())
    return res


cdef inline object visit_int_value(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["value"] = (<const char *>(<IntValue *>ptr)[0].getValue()).decode("utf-8")
    return res


cdef inline object visit_float_value(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["value"] = (<const char *>(<FloatValue *>ptr)[0].getValue()).decode("utf-8")
    return res


cdef inline object visit_string_value(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["value"] = (<const char *>(<StringValue *>ptr)[0].getValue()).decode("utf-8")
    return res


cdef inline object visit_boolean_value(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["value"] = <bool >(<BooleanValue *>ptr)[0].getValue()
    return res


cdef inline object visit_enum_value(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["value"] = (<const char *>(<EnumValue *>ptr)[0].getValue()).decode("utf-8")
    return res


cdef inline object visit_array_value(const Node *ptr):
    cdef const Node *tmp
    res = {}
    cdef const vector[unique_ptr[Value]] *values = &(<ArrayValue *>ptr).getValues()
    res["values"] = [visit_value(values[0].at(i).get()) for i in xrange(values[0].size() if values else 0)]
    return res


cdef inline object visit_object_value(const Node *ptr):
    cdef const Node *tmp
    res = {}
    cdef const vector[unique_ptr[ObjectField]] *fields = &(<ObjectValue *>ptr).getFields()
    res["fields"] = [visit_object_field(fields[0].at(i).get()) for i in xrange(fields[0].size() if fields else 0)]
    return res


cdef inline object visit_object_field(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["name"] = visit_name(&(<ObjectField *>ptr)[0].getName())
    res["value"] = visit_value(&(<ObjectField *>ptr)[0].getValue())
    return res


cdef inline object visit_directive(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["name"] = visit_name(&(<Directive *>ptr)[0].getName())
    cdef const vector[unique_ptr[Argument]] *arguments = (<Directive *>ptr).getArguments()
    res["arguments"] = [visit_argument(arguments[0].at(i).get()) for i in xrange(arguments[0].size() if arguments else 0)]
    return res


cdef inline object visit_named_type(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["name"] = visit_name(&(<NamedType *>ptr)[0].getName())
    return res


cdef inline object visit_list_type(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["type"] = visit_type(&(<ListType *>ptr)[0].getType())
    return res


cdef inline object visit_non_null_type(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["type"] = visit_type(&(<NonNullType *>ptr)[0].getType())
    return res


cdef inline object visit_name(const Node *ptr):
    cdef const Node *tmp
    res = {}
    res["value"] = (<const char *>(<Name *>ptr)[0].getValue()).decode("utf-8")
    return res
