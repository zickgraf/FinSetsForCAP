# SPDX-License-Identifier: GPL-2.0-or-later
# FinSetsForCAP: The elementary topos of (skeletal) finite sets
#
# Implementations
#

##
CapJitAddLogicFunction( function ( tree )
  local pre_func;
    
    Info( InfoCapJit, 1, "####" );
    Info( InfoCapJit, 1, "Apply logic for global functions applied to literal integers." );
    
    pre_func := function ( tree, additional_arguments )
        local args;
        
        if CapJitIsCallToGlobalFunction( tree, ReturnTrue ) then
            
            args := tree.args;
            
            if ForAll( args, a -> a.type = "EXPR_INT" ) then
                
                if tree.funcref.gvar in [ "+", "-", "*", "QUO_INT", "REM_INT" ] then
                    
                    return rec(
                               type := "EXPR_INT",
                               value := CallFuncList( ValueGlobal( tree.funcref.gvar ), AsListMut( List( args, a -> a.value ) ) ),
                               );
                    
                # elif tree.funcref.gvar in [ "=" ] then
                #
                # if CallFuncList( ValueGlobal( tree.funcref.gvar ), AsListMut( List( args, a -> a.value ) ) ) then
                # return rec( type := "EXPR_TRUE" );
                # else
                # return rec( type := "EXPR_FALSE" );
                # fi;
                    
                fi;
                
            fi;
            
        fi;
        
        return tree;
        
    end;
    
    return CapJitIterateOverTree( tree, pre_func, CapJitResultFuncCombineChildren, ReturnTrue, true );
    
end );

## Teach CompilerForCAP about the input type of the function so it can correctly type the function,
## that can be done with the following code (adapted from the existing List type signature):
##
CapJitAddTypeSignature( "List", [ IsSkeletalFiniteSet, IsFunction ], function ( args, func_stack )
    
    args := ShallowCopy( args );
    
    args.2 := CAP_JIT_INTERNAL_INFERRED_DATA_TYPES_OF_FUNCTION_BY_ARGUMENTS_TYPES( args.2, [ rec( filter := IsInt ) ], func_stack );
    
    if args.2 = fail then
        
        #Error( "could not determine output type" );
        return fail;
        
    fi;
    
    return rec( args := args, output_type := rec( filter := IsList, element_type := args.2.data_type.signature[2] ) );
    
end );

##
CapJitAddLogicTemplate(
    rec(
        variable_names := [ "M", "func" ],
        variable_filters := [ IsSkeletalFiniteSet, IsObject ],
        src_template := "List( M, func )",
        dst_template := "List( [ 0 .. Length( M ) - 1 ], func )",
    )
);

##
CapJitAddLogicFunction( function ( tree )
  local pre_func;
    
    Info( InfoCapJit, 1, "####" );
    Info( InfoCapJit, 1, "Apply logic for SKELETAL_FIN_SETS_compose_graphs." );
    
    pre_func := function ( tree, additional_arguments )
      local i;
        
        if CapJitIsCallToGlobalFunction( tree, "SKELETAL_FIN_SETS_compose_graphs" ) then
            
            # TODO: generalize
            # SKELETAL_FIN_SETS_compose_graphs( ListWithIdenticalEntries( ), list ) => ListWithIdenticalEntries
            if tree.args.length = 2 and CapJitIsCallToGlobalFunction( tree.args.1, "ListWithIdenticalEntries" ) then
                
                return rec(
                    type := "EXPR_FUNCCALL",
                    funcref := rec(
                        type := "EXPR_REF_GVAR",
                        gvar := "ListWithIdenticalEntries",
                    ),
                    args := AsSyntaxTreeList( [
                        tree.args.1.args.1,
                        rec(
                            type := "EXPR_FUNCCALL",
                            funcref := rec(
                                type := "EXPR_REF_GVAR",
                                gvar := "[]",
                            ),
                            args := AsSyntaxTreeList( [
                                tree.args.2,
                                rec(
                                    type := "EXPR_FUNCCALL",
                                    funcref := rec(
                                        type := "EXPR_REF_GVAR",
                                        gvar := "+",
                                    ),
                                    args := AsSyntaxTreeList( [
                                        rec(
                                            type := "EXPR_INT",
                                            value := 1,
                                        ),
                                        tree.args.1.args.2,
                                    ] ),
                                ),
                            ] ),
                        ),
                    ] ),
                );
                
            fi;
            
            
            # constant lists at the end
            # SKELETAL_FIN_SETS_compose_graphs( ..., [ entry ] ) => ListWithIdenticalEntries
            if Last( tree.args ).type = "EXPR_LIST" and Last( tree.args ).list.length = 1 then
                
                return rec(
                    type := "EXPR_FUNCCALL",
                    funcref := rec(
                        type := "EXPR_REF_GVAR",
                        gvar := "ListWithIdenticalEntries",
                    ),
                    args := AsSyntaxTreeList( [
                        rec(
                            type := "EXPR_FUNCCALL",
                            funcref := rec(
                                type := "EXPR_REF_GVAR",
                                gvar := "Length",
                            ),
                            args := AsSyntaxTreeList( [
                                tree.args.1,
                            ] ),
                        ),
                        Last( tree.args ).list.1,
                    ] ),
                );
                
            # SKELETAL_FIN_SETS_compose_graphs( ..., ListWithIdenticalEntries ) => ListWithIdenticalEntries
            elif CapJitIsCallToGlobalFunction( Last( tree.args ), "ListWithIdenticalEntries" ) then
                
                return rec(
                    type := "EXPR_FUNCCALL",
                    funcref := rec(
                        type := "EXPR_REF_GVAR",
                        gvar := "ListWithIdenticalEntries",
                    ),
                    args := AsSyntaxTreeList( [
                        rec(
                            type := "EXPR_FUNCCALL",
                            funcref := rec(
                                type := "EXPR_REF_GVAR",
                                gvar := "Length",
                            ),
                            args := AsSyntaxTreeList( [
                                tree.args.1,
                            ] ),
                        ),
                        Last( tree.args ).args.2,
                    ] ),
                );
                
            fi;
            
            # flatten
            if ForAny( tree.args, a -> CapJitIsCallToGlobalFunction( a, "SKELETAL_FIN_SETS_compose_graphs" ) ) then
                
                tree := ShallowCopy( tree );
                
                tree.args := ConcatenationForSyntaxTreeLists( AsListMut( List( tree.args, function ( a )
                    
                    if CapJitIsCallToGlobalFunction( a, "SKELETAL_FIN_SETS_compose_graphs" ) then
                        
                        return a.args;
                        
                    else
                        
                        return AsSyntaxTreeList( [ a ] );
                        
                    fi;
                    
                end ) ) );
                
            else
                
                i := 1;
                
                while i <= tree.args.length do
                    
                    # TODO: generalize?
                    
                    tree := ShallowCopy( tree );
                    tree.args := ShallowCopy( tree.args );
                    
                    if i < tree.args.length and tree.args.(i).type in [ "EXPR_RANGE", "EXPR_LIST" ] and CapJitIsCallToGlobalFunction( tree.args.(i + 1), "List" ) and tree.args.(i + 1).args.1.type = "EXPR_RANGE" and tree.args.(i + 1).args.1.first.type = "EXPR_INT" and tree.args.(i + 1).args.1.first.value = 0 then
                        
                        # move literal list or range into list call of next argument
                        
                        tree.args.(i + 1) := ShallowCopy( tree.args.(i + 1) );
                        tree.args.(i + 1).args := ShallowCopy( tree.args.(i + 1).args );
                        
                        tree.args.(i + 1).args.1 := tree.args.(i);
                        
                        Remove( tree.args, i );
                        
                    elif i < tree.args.length and tree.args.(i).type = "EXPR_LIST" and tree.args.(i).list.length = 1 then
                        
                        tree.args.(i + 1) := rec(
                            type := "EXPR_LIST",
                            list := AsSyntaxTreeList( [
                                rec(
                                    type := "EXPR_FUNCCALL",
                                    funcref := rec(
                                        type := "EXPR_REF_GVAR",
                                        gvar := "[]",
                                    ),
                                    args := AsSyntaxTreeList( [
                                        tree.args.(i + 1),
                                        rec(
                                            type := "EXPR_FUNCCALL",
                                            funcref := rec(
                                                type := "EXPR_REF_GVAR",
                                                gvar := "+",
                                            ),
                                            args := AsSyntaxTreeList( [
                                                rec(
                                                    type := "EXPR_INT",
                                                    value := 1,
                                                ),
                                                tree.args.(i).list.1,
                                            ] ),
                                        ),
                                    ] ),
                                ),
                            ] ),
                        );
                        
                        Remove( tree.args, i );
                        
                    elif i = tree.args.length and i >= 2 and tree.args.(i).type = "EXPR_RANGE" and tree.args.(i).first.type = "EXPR_INT" and tree.args.(i).first.value = 0 then
                            
                        # we can only drop
                        Remove( tree.args, i );
                        
                    else
                        
                        i := i + 1;
                        
                    fi;
                    
                od;
                
                if tree.args.length = 1 then
                    
                    return tree.args.1;
                    
                fi;
                
            fi;
            
        fi;
        
        return tree;
        
    end;
    
    return CapJitIterateOverTree( tree, pre_func, CapJitResultFuncCombineChildren, ReturnTrue, true );
    
end );

#CapJitAddLogicTemplate(
#    rec(
#        variable_names := [ "last", "list" ],
#        src_template := "SKELETAL_FIN_SETS_compose_graphs( list, [ 0 .. last ] )",
#        dst_template := "list",
#    )
#);
#
#CapJitAddLogicTemplate(
#    rec(
#        variable_names := [ "last1", "last2", "func" ],
#        src_template := "SKELETAL_FIN_SETS_compose_graphs( [ 0 .. last1 ], List( [ 0 .. last2 ], func ) )",
#        dst_template := "List( [ 0 .. last1 ], func )",
#    )
#);

## for PushoutComplement
CapJitAddLogicTemplate(
    rec(
        variable_names := [ ],
        src_template := "Filtered( [ 0, 1, 2, 3 ], x -> CAP_JIT_INTERNAL_EXPR_CASE( x = 3, 1, true, 0 ) = REM_INT( x, 2 ) )",
        dst_template := "[ 0, 2, 3 ]",
    )
);

## for PushoutComplement
CapJitAddLogicTemplate(
    rec(
        variable_names := [ ],
        src_template := "0 in [ 0, 2, 3 ]",
        dst_template := "true",
    )
);

## for PushoutComplement
CapJitAddLogicTemplate(
    rec(
        variable_names := [ ],
        src_template := "1 in [ 0, 2, 3 ]",
        dst_template := "false",
    )
);

## for PushoutComplement
CapJitAddLogicTemplate(
    rec(
        variable_names := [ ],
        src_template := "2 in [ 0, 2, 3 ]",
        dst_template := "true",
    )
);

## for PushoutComplement
CapJitAddLogicTemplate(
    rec(
        variable_names := [ ],
        src_template := "3 in [ 0, 2, 3 ]",
        dst_template := "true",
    )
);

## for PushoutComplement
CapJitAddLogicTemplate(
    rec(
        variable_names := [ "last" ],
        src_template := "List( [ 0 .. last - 1 ], x -> REM_INT( x, last ) )",
        dst_template := "[ 0 .. last - 1 ]",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "last", "func" ],
        src_template := "List( [ 0 .. last ], x -> List( [ 0 .. last ], func )[1 + x] )",
        dst_template := "List( [ 0 .. last ], func )", # actually: List( List( [ 0 .. last ], func ), x -> x )
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "last", "list_independent_of_x", "func" ],
        src_template := "List( [ 0 .. last ], x -> list_independent_of_x[1 + List( [ 0 .. last ], func )[1 + x]] )",
        dst_template := "List( List( [ 0 .. last ], func ), y -> list_independent_of_x[1 + y] )",
        new_funcs := [ [ "y" ] ],
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "last", "func1", "func2" ],
        src_template := "Filtered( [ 0 .. last ], x -> List( [ 0 .. last ], func1 )[1 + x] = List( [ 0 .. last ], func2 )[1 + x] )",
        dst_template := "Filtered( [ 0 .. last ], x -> func1( x ) = func2( x ) )",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "last", "list" ],
        src_template := "[ 0 .. last ]{1 + list}",
        dst_template := "list",
    )
);

# degenerate case of the rule above
CapJitAddLogicTemplate(
    rec(
        variable_names := [ "last", "list" ],
        src_template := "[ 0 ]{1 + list}",
        dst_template := "list",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "number" ],
        variable_filters := [ IsInt ],
        src_template := "0 + number",
        dst_template := "number",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "number" ],
        variable_filters := [ IsInt ],
        src_template := "number + 0",
        dst_template := "number",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "number" ],
        variable_filters := [ IsInt ],
        src_template := "number * 1",
        dst_template := "number",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "number" ],
        variable_filters := [ IsInt ],
        src_template := "1 * number",
        dst_template := "number",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "number" ],
        variable_filters := [ IsInt ],
        src_template := "0 * number",
        dst_template := "0",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "number" ],
        variable_filters := [ IsInt ],
        src_template := "QUO_INT( number, 1 )",
        dst_template := "number",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "list" ],
        src_template := "list{[ ]}",
        dst_template := "[ ]",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "list" ],
        src_template := "list{[ 1 ]}",
        dst_template := "[ list[1] ]",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "entry", "pos" ],
        src_template := "[ entry ][pos]",
        dst_template := "entry",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ ],
        src_template := "Product( [ ] )",
        dst_template := "1",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "func" ],
        src_template := "Product( [ ], func )",
        dst_template := "1",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "entry" ],
        src_template := "Product( [ entry ] )",
        dst_template := "entry",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "entry1", "entry2" ],
        src_template := "Product( [ entry1, entry2 ] )",
        dst_template := "entry1 * entry2",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "entry", "func" ],
        src_template := "Product( [ entry ], func )",
        dst_template := "func( entry )",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "func" ],
        src_template := "Sum( [ 0, 1 ], func )",
        dst_template := "func( 0 ) + func( 1 )",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "list", "constant" ],
        src_template := "List( list, i -> constant )",
        dst_template := "ListWithIdenticalEntries( Length( list ), constant )",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "length", "constant", "pos" ],
        src_template := "ListWithIdenticalEntries( length, constant )[pos]",
        dst_template := "constant",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "pos_end", "index" ],
        variable_filters := [ IsInt, IsInt ],
        src_template := "[ 0 .. pos_end ][index]",
        dst_template := "index - 1",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "number" ],
        variable_filters := [ IsInt ],
        src_template := "(1 + number) - 1",
        dst_template := "number",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "number1", "number2" ],
        variable_filters := [ IsInt, IsInt ],
        src_template := "number1 in [ number2 ]",
        dst_template := "number1 = number2",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "number" ],
        variable_filters := [ IsInt ],
        src_template := "number ^ 1",
        dst_template := "number",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "entry", "func" ],
        src_template := "ForAll( [ entry ], func )",
        dst_template := "func( entry )",
    )
);

CapJitAddLogicTemplate(
    rec(
        variable_names := [ "entry", "list" ],
        src_template := "entry in SSortedList( list )",
        dst_template := "entry in list",
    )
);
