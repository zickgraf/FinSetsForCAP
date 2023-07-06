# SPDX-License-Identifier: GPL-2.0-or-later
# FinSetsForCAP: The elementary topos of (skeletal) finite sets
#
# Declarations
#

#! @Chapter The category of skeletal finite sets

#! @Section GAP Categories

#! @Description
#! The GAP category of categories
#! of skeletal finite sets.
#! @Arguments object
DeclareCategory( "IsCategoryOfSkeletalFinSets",
                  IsCapCategory );

#! @Description
#! The GAP category of objects in the category
#! of skeletal finite sets.
#! @Arguments object
DeclareCategory( "IsSkeletalFiniteSet",
                 IsCapCategoryObject );

#! @Description
#! The GAP category of morphisms in the category
#! of skeletal finite sets.
#! @Arguments object
DeclareCategory( "IsSkeletalFiniteSetMap",
                 IsCapCategoryMorphism );

#! @Section Attributes

#! @Description
#!  The integer defining the skeletal finite set <A>M</A>, i.e.,
#!  <C>Length( FinSet( n ) ) = n</C>.
#! @Arguments M
#! @Returns an integer
DeclareAttribute( "Length",
        IsSkeletalFiniteSet );

CapJitAddTypeSignature( "Length", [ IsSkeletalFiniteSet ], IsBigInt );

#! @Description
#!  The list associated to a skeletal finite set, i.e.,
#!  <C>AsList( FinSet( n ) ) = [ 0 .. n - 1 ]</C>.
#! @Arguments M
#! @Returns a list
DeclareAttribute( "AsList",
        IsSkeletalFiniteSet );

CapJitAddTypeSignature( "AsList", [ IsSkeletalFiniteSet ], CapJitDataTypeOfListOf( IsBigInt ) );

#! @Description
#!  The graph defining the skeletal finite set morphism <A>phi</A>, see <Ref Oper="MapOfFinSets" Label="for IsSkeletalFiniteSet, IsList, IsSkeletalFiniteSet" />.
#! @Arguments phi
#! @Returns a list
DeclareAttribute( "AsList",
        IsSkeletalFiniteSetMap );

CapJitAddTypeSignature( "AsList", [ IsSkeletalFiniteSetMap ], CapJitDataTypeOfListOf( IsBigInt ) );

#! @Section Constructors

#! @Description
#!  Construct a category of skeletal finite sets.
#! @Returns a &CAP; category
DeclareOperation( "CategoryOfSkeletalFinSets", [ ] );

#! @Description
#!  The default instance of the category of skeletal finite sets.
#!  It is automatically created while loading this package.
DeclareGlobalName( "SkeletalFinSets" );

#! @Description
#!  Construct a skeletal finite set residing in
#!  the default instance of the category of skeletal finite sets <C>SkeletalFinSets</C>
#!  of order given by the nonnegative integer <A>n</A>.
#! @Arguments n
#! @Returns a &CAP; object
DeclareOperation( "FinSet",
        [ IsBigInt ] );
#! @InsertChunk SkeletalFinSet

#! @Description
#!  Construct a skeletal finite set residing in
#!  the given category of skeletal finite sets <A>C</A>
#!  of order given by the nonnegative integer <A>n</A>.
#! @Arguments C, n
#! @Returns a &CAP; object
KeyDependentOperation( "FinSet", IsCategoryOfSkeletalFinSets, IsBigInt, ReturnTrue );

#! @Description
#!  Construct a map $\phi:$<A>s</A>$\to$<A>t</A> of the skeletal finite sets <A>s</A> and <A>t</A>,
#!  i.e., a morphism in the &CAP; category of <A>s</A>, where <A>G</A>
#!  is a list of integers in <A>t</A> describing the graph of $\phi$.
#! @Arguments s, G, t
#! @Returns a &CAP; morphism
DeclareOperation( "MapOfFinSets",
        [ IsSkeletalFiniteSet, IsList, IsSkeletalFiniteSet ] );
#! @InsertChunk  SkeletalMapOfFinSets

#! @Section Tools

#! @Description
#!  Returns <C>List( AsList( <A>s</A> ), <A>f</A> )</C>.
#! @Arguments s, f
#! @Returns a list
DeclareOperation( "ListOp",
        [ IsSkeletalFiniteSet, IsFunction ] );

#! @Description
#!  Construct the embedding $\iota:$<A>s</A>$\to$<A>t</A> of the finite sets <A>s</A> and <A>t</A>,
#!  where <A>s</A> must be subset of <A>t</A>.
#! @Arguments s, t
#! @Returns a &CAP; morphism
DeclareOperation( "EmbeddingOfFinSets",
        [ IsSkeletalFiniteSet, IsSkeletalFiniteSet ] );

#! @Description
#!  Compute the Preimage of <A>t</A> under the morphism <A>phi</A>.
#! @Arguments phi, t
#! @Returns a &CAP; object
DeclareOperation( "Preimage",
        [ IsSkeletalFiniteSetMap, IsList ] );

#! @Description
#!  Compute the image of <A>s_</A> under the morphism <A>phi</A>.
#! @Arguments phi, s_
#! @Returns a &CAP; object
DeclareOperation( "ImageObject",
        [ IsSkeletalFiniteSetMap, IsSkeletalFiniteSet ] );

#! @Description
#!  Returns the image of <C><A>L</A>[1]</C> under the map <A>phi</A> assuming <C><A>L</A>[1]</C> is a nonnegative integer smaller than <C>Length( Source( <A>phi</A> ) )</C>.
#! @Arguments phi, L
#! @Returns a list
# DeclareOperation( "CallFuncList",
#         [ IsSkeletalFiniteSetMap, IsList ] );

# Technical functions
DeclareGlobalFunction( "INSTALL_FUNCTIONS_FOR_SKELETAL_FIN_SETS" );

DeclareGlobalFunction( "SKELETAL_FIN_SETS_ExplicitCoequalizer" );
CapJitAddTypeSignature( "SKELETAL_FIN_SETS_ExplicitCoequalizer", [ IsSkeletalFiniteSet, IsList ], CapJitDataTypeOfListOf( CapJitDataTypeOfListOf( IsBigInt ) ) );

DeclareGlobalFunction( "SKELETAL_FIN_SETS_IsMonomorphism" );
CapJitAddTypeSignature( "SKELETAL_FIN_SETS_IsMonomorphism", [ IsList, IsBigInt ], IsBool );

DeclareGlobalFunction( "SKELETAL_FIN_SETS_IsEpimorphism" );
CapJitAddTypeSignature( "SKELETAL_FIN_SETS_IsEpimorphism", [ IsList, IsBigInt ], CapJitDataTypeOfListOf( IsBool ) );
