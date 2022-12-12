# SPDX-License-Identifier: GPL-2.0-or-later
# FinSetsForCAP: The elementary topos of (skeletal) finite sets
#
# Implementations
#

##
# we use other method to suppress a warning due to FinSet being a KeyDependentOperation
InstallOtherMethod( FinSet,
        [ IsJuliaObject ],
        
  function ( list )
    
    # integers are converted automatically -> we only have to handle lists here
    
    return FinSet( JuliaToGAP( IsList, list ) );
    
end );

##
InstallMethod( MapOfFinSets,
        [ IsFiniteSet, IsJuliaObject, IsFiniteSet ],
        
  function ( source, graph, range )
    
    graph := JuliaToGAP( IsList, graph );
    
    graph := List( graph, x -> JuliaToGAP( IsList, x ) );
    
    return MapOfFinSets( source, graph, range );
    
end );

##
InstallMethod( MapOfFinSets,
        [ IsSkeletalFiniteSet, IsJuliaObject, IsSkeletalFiniteSet ],
        
  function ( source, graph, range )
    
    return MapOfFinSets( source, ConvertJuliaToGAP( graph ), range );
    
end );
