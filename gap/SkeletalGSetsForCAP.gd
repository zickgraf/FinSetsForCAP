#
# FinSetsForCAP: The elementary topos of finite sets
#
# Declarations
#

#! @Chapter The skeletal category of G-sets

DeclareRepresentation( "IsSkeletalGSetRep",
        IsAttributeStoringRep and
        IsCapCategoryObjectRep and
	IsCellOfSkeletalCategory,
        [ ] );

BindGlobal( "TheTypeOfSkeletalGSets",
         NewType( TheFamilyOfCapCategoryObjects,
                 IsSkeletalGSetRep ) );

DeclareRepresentation( "IsSkeletalGSetMapRep",
        IsAttributeStoringRep and
        IsCapCategoryMorphismRep,
        [ ] );

BindGlobal( "TheTypeOfMapsOfSkeletalGSets",
         NewType( TheFamilyOfCapCategoryMorphisms,
                 IsSkeletalGSetMapRep ) );


#! @Section Attributes

#! @Description
#!  The &GAP; set of the list used to construct a finite $G$-set <A>Omega</A>, i.e.,
#!  <C>AsList( GSet( G, <A>L</A> ) ) = <A>L</A></C>.
#! @Arguments Omega
#! @Returns a &GAP; set
DeclareAttribute( "AsList",
        IsSkeletalGSetRep );

#! @Description
#!  The group $G$ underlying the $G$-set <A>Omega</A>.
#! @Arguments Omega
#! @Returns a group
DeclareAttribute( "UnderlyingGroup",
        IsSkeletalGSetRep );

#! @Description
#!  The table of marks of the group $G$ underlying the $G$-set <A>Omega</A>.
#! @Arguments Omega
#! @Returns a table of marks
DeclareAttribute( "TableOfMarks",
        IsSkeletalGSetRep );

#! @Description
#!  The number of conjugacy classes of subgroups of the group underlying the $G$-set <A>Omega</A>.
#! @Arguments Omega
#! @Returns a positive integer
DeclareAttribute( "NrConjugacyClassesOfSubgroups",
        IsSkeletalGSetRep );

#! @Description
#! TODO.
#! @Arguments two group elements and a Subgroup
#! @Returns a positive integer
DeclareOperation( "IsEqualModSubgroup",
         [ IsObject, IsObject, IsObject ] );

#! @Description
#!  The number of conjugacy classes of subgroups of the group underlying the $G$-set <A>Omega</A>.
#! @Arguments TODOO
#! @Returns a positive integer
DeclareAttribute( "PositionOfSubgroup",
        IsObject );

# TODO: DeclareAttribute vs DeclareOperation

#! @Description
#! ToDO.
#! @Arguments TODO
#! @Returns a positive integer
DeclareAttribute( "RepresentativeOfSubgroupsUpToConjugation",
        IsInt );

#! @Description
#!  ToDO.
#! @Arguments TODO
#! @Returns a positive integer
DeclareAttribute( "OrbitsOfActionOnCartesianProduct",
        IsList );

#! @Description
#!  The number of conjugacy classes of subgroups of the group underlying the $G$-set <A>Omega</A>.
#! @Arguments TODO
#! @Returns a positive integer
DeclareAttribute( "ToBeNamed",
        IsList );

#! @Description
#!  The number of conjugacy classes of subgroups of the group underlying the $G$-set <A>Omega</A>.
#! @Arguments TODO
#! @Returns a positive integer
DeclareAttribute( "IntZeroVector",
        IsInt );

#! @Description
#!  The number of conjugacy classes of subgroups of the group underlying the $G$-set <A>Omega</A>.
#! @Arguments TODO
#! @Returns a positive integer
DeclareOperation( "ProjectionOfASingleBinaryProduct",
        [ IsInt, IsInt, IsInt, IsInt, IsSkeletalGSetRep ] );

#! @Description
#! TODO.
#! @Arguments TODO
#! @Returns a positive integer
DeclareOperation( "OffsetInCartesianProduct",
         [ IsList, IsList, IsInt, IsInt, IsInt, IsInt ] );

#! @Section Constructors

#! @Description
#!  Construct an object in the skeletal category of G sets
#!  out of the group <A>G</A> and a List <A>L</A>, i.e.,
#!  an object in the &CAP; category <C>SkeletalGSets</C>.
#! @Arguments G, M
#! @Returns a &CAP; object
DeclareOperation( "GSet",
        [ IsGroup, IsList ] );
#! @InsertSystem GSet

#! @Description
#!  Construct a map $\phi:$<A>s</A>$\to$<A>t</A> of the skeletal G sets <A>s</A> and <A>t</A>,
#!  i.e., a morphism in the &CAP; category <C>SkeletalGSets</C>, where <A>G</A>
#!  is a list of XXX describing the graph of $\phi$.
#! @Arguments s, G, t
#! @Returns a &CAP; morphism
DeclareOperation( "MapOfGSets",
        [ IsSkeletalGSetRep, IsList, IsSkeletalGSetRep ] );
#! @InsertSystem  MapOfGSets

#! @Description
#! The argument is a group $G$.
#! The output is the skeletal category of finite $G$-Sets.
#! @Returns a category
#! @Arguments G
DeclareAttribute( "SkeletalGSets",
                  IsGroup );

#! @Section Tools
