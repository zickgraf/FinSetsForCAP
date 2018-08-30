# SetUserPreference("ReproducibleBehaviour", true);

input_stream := InputTextFile( "/dev/urandom" );
initial_seed := Sum( List( [ 1 .. 6 ], i -> ReadByte( input_stream ) * 256^( i - 1 ) ) );

LoadPackage( "FinSetsForCAP" );
# DeactivateCachingOfCategory( FinSets );
# SetCachingOfCategoryCrisp( FinSets );

SetAssertionLevel( 4 );

FinSet_elements_preset := [ 1, 2, "a", "b", 'a', 'b', [ 1 ], [ 2 ], FinSets, SkeletalFinSets, FinSet( [ ] ), FinSet( [ 1 ] ), IdentityMorphism( FinSet( [ ] ) ), IdentityMorphism( FinSet( [ 1 ] ) ) ];
# FinSet_elements_preset := [ 1, 2, "a", "b", 'a', 'b', "c", "d", "e", "f", "g", "h", "i", "j" ];

############### FinSets
RandomObject := function()
	local length, elements;
	
	length := Random( [ 0 .. 5 ] );
	
	elements := List( [ 1 .. length ], i -> [ i, Random( FinSet_elements_preset ) ] );
	
	return FinSetNC( elements );
	
end;

RandomNonEmptyObject := function()
	local length, elements;
	
	length := Random( [ 1 .. 5 ] );
	
	elements := List( [ 1 .. length ], i -> [ i, Random( FinSet_elements_preset ) ] );
	
	return FinSetNC( elements );
	
end;


IntersectionOfFinSets := function( L )
	local intersection, l, i;
	
	intersection := L[ 1 ];
	
	for l in L{ [ 2 .. Length( L ) ] } do
		i := 1;
		while i <= Length( intersection ) do
			if not intersection[ i ] in l then
				intersection := ShallowCopy( AsList( intersection ) );
				Remove( intersection, i );
				intersection := FinSetNC( intersection );
				i := i - 1;
			fi;
			i := i + 1;
		od;
	od;
	
	return intersection;
	
end;


RandomCommonRangeForSources := function( sources )
	if ForAny( sources, s -> Length( s ) > 0 ) then
		return RandomNonEmptyObject();
	fi;
	
	return RandomObject();
end;

RandomCommonSourceForRanges := function( ranges )
	if ForAny( ranges, r -> Length( r ) = 0 ) then
		return FinSet( [] );
	fi;
	
	return RandomObject();
end;

RandomMorphismWithGivenSourceAndRange := function( source, range )
	local graph;
	
	if Length( range ) = 0 then
		return IdentityMorphism( range );
	fi;
	
	graph := List( source, x -> [ x, Random( AsList( range ) ) ] );
	
	return MapOfFinSetsNC( source, graph, range );

end;

RandomMorphismWithGivenRange := function( range )
	local source;

	source := RandomObject( );
	
	return RandomMorphismWithGivenSourceAndRange( source, range );

end;

RandomMorphismWithGivenSource := function( source )
	local range;

	if Length( source ) <> 0 then
		range := RandomNonEmptyObject( );
	else
		range := RandomObject( );
	fi;
	
	return RandomMorphismWithGivenSourceAndRange( source, range );

end;


###################### SkeletalFinSets
RandomObject := function()
	local length, elements;
	
	length := Random( [ 0 .. 9 ] );
	
	return FinSet( length );
	
end;

RandomNonEmptyObject := function()
	local length, elements;
	
	length := Random( [ 1 .. 9 ] );
	
	return FinSet( length );
	
end;


RandomCommonRangeForSources := function( sources )
	if ForAny( sources, s -> Length( s ) > 0 ) then
		return RandomNonEmptyObject();
	fi;
	
	return RandomObject();
end;

RandomCommonSourceForRanges := function( ranges )
	if ForAny( ranges, r -> Length( r ) = 0 ) then
		return FinSet( 0 );
	fi;
	
	return RandomObject();
end;

RandomMorphismWithGivenSourceAndRange := function( source, range )
	local graph;
	
	if Length( range ) = 0 then
		return IdentityMorphism( range );
	fi;
	
	graph := List( source, x -> Random( AsList( range ) ) );
	
	return MapOfFinSets( source, graph, range );

end;

RandomMorphismWithGivenRange := function( range )
	local source;

	source := RandomObject( );
	
	return RandomMorphismWithGivenSourceAndRange( source, range );

end;

RandomMorphismWithGivenSource := function( source )
	local range;

	if Length( source ) <> 0 then
		range := RandomNonEmptyObject( );
	else
		range := RandomObject( );
	fi;
	
	return RandomMorphismWithGivenSourceAndRange( source, range );

end;





################ fuzzer

FuzzDirectProduct := function()
	local number_of_factors, factors, common_source, tau, psi, i;

	number_of_factors := Random( [ 1 .. 5 ] );

	Display( number_of_factors );

	factors := List( [ 1 .. number_of_factors ], i -> RandomObject( ) );
	
	Display( List( factors, factor -> Length( factor ) ) );
	
	DirectProduct( factors );
	
	common_source := RandomCommonSourceForRanges( factors );
	
	tau := List( factors, factor -> RandomMorphismWithGivenSourceAndRange( common_source, factor ) );
	
	psi := UniversalMorphismIntoDirectProduct( factors, tau );
	
	for i in [ 1 .. number_of_factors ] do
		Assert( 0, PreCompose( psi, ProjectionInFactorOfDirectProduct( factors, i ) ) = tau[ i ] );
	od;
	
end;


FuzzFiberProduct := function()
	local number_of_morphisms, common_range, morphisms, fiber_product, psi, tau, u;

	number_of_morphisms := Random( [ 1 .. 5 ] );

	Display( number_of_morphisms );

	common_range := RandomObject( );

	morphisms := List( [ 1 .. number_of_morphisms ], i -> RandomMorphismWithGivenRange( common_range ) );
	
	Display( List( morphisms, m -> Length( Source( m ) ) ) );

	fiber_product := FiberProduct( morphisms );
	
	psi := RandomMorphismWithGivenRange( fiber_product );
	
	tau := List( [ 1 .. number_of_morphisms ], i -> PreCompose( psi, ProjectionInFactorOfFiberProduct( morphisms, i ) ) );
	
	u := UniversalMorphismIntoFiberProduct( morphisms, tau );
	
	Assert( 0, psi = u );
	
end;


FuzzCoproduct := function()
	local number_of_cofactors, cofactors, common_range, tau, psi, i;

	number_of_cofactors := Random( [ 1 .. 5 ] );

	Display( number_of_cofactors );

	cofactors := List( [ 1 .. number_of_cofactors ], i -> RandomObject( ) );
	
	Display( List( cofactors, cofactor -> Length( cofactor ) ) );
	
	Coproduct( cofactors );
	
	common_range := RandomCommonRangeForSources( cofactors );
	
	tau := List( cofactors, cofactor -> RandomMorphismWithGivenSourceAndRange( cofactor, common_range ) );
	
	psi := UniversalMorphismFromCoproduct( cofactors, tau );
	
	for i in [ 1 .. number_of_cofactors ] do
		Assert( 0, PreCompose( InjectionOfCofactorOfCoproduct( cofactors, i ), psi ) = tau[ i ] );
	od;
	
end;



FuzzPushout := function()
	local number_of_morphisms, common_source, morphisms, pushout, psi, tau, u;

	number_of_morphisms := Random( [ 1 .. 5 ] );

	Display( number_of_morphisms );

	common_source := RandomObject( );

	morphisms := List( [ 1 .. number_of_morphisms ], i -> RandomMorphismWithGivenSource( common_source ) );
	
	Display( List( morphisms, m -> Length( Range( m ) ) ) );

	pushout := Pushout( morphisms );

	psi := RandomMorphismWithGivenSource( pushout );
	
	tau := List( [ 1 .. number_of_morphisms ], i -> PreCompose( InjectionOfCofactorOfPushout( morphisms, i ), psi ) );
	
	u := UniversalMorphismFromPushout( morphisms, tau );
	
	Assert( 0, psi = u );
	
end;

seed := initial_seed;

# Coproduct
seed := 54647255804181;

while true do

	Display( seed );
	
	Reset( GlobalMersenneTwister, seed );

	# FuzzDirectProduct();
	# FuzzFiberProduct();
	# FuzzCoproduct();
	FuzzPushout();

	seed := Random( [ 0 .. 256^6 - 1 ] );
	
od;
