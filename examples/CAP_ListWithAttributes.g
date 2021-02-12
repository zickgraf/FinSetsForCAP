LoadPackage( "FinSetsForCAP" );

test := function( obj, cat )

Display( "test0" );

Display( DirectProduct( obj, obj ) );

Display( "test1" );

Display( DirectProduct( [ obj ] ) );

Display( "test2" );

Display( DirectProduct( ListOfObjectsInCategory( [ obj ], cat ) ) );

Display( "test3" );

Display( DirectProduct( ListOfObjectsInCategory( [ ], cat ) ) );

Display( "test4" );

Display( ProjectionInFactorOfDirectProduct( [ obj ], 1 ) );

Display( "test5" );

Display( ProjectionInFactorOfDirectProduct( ListOfObjectsInCategory( [ obj ], cat ), 1 ) );

Display( "test6" );

Display( ProjectionInFactorOfDirectProductWithGivenDirectProduct( [ obj ] , 1, DirectProduct( [ obj ] ) ) );

Display( "test7" );

Display( ProjectionInFactorOfDirectProductWithGivenDirectProduct( ListOfObjectsInCategory( [ obj ], cat ), 1, DirectProduct( [ obj ] ) ) );

Display( "test8" );

Display( UniversalMorphismIntoDirectProduct( [ IdentityMorphism( obj ) ] ) );

Display( "test9" );

Display( UniversalMorphismIntoDirectProduct( [ obj ], [ IdentityMorphism( obj ) ] ) );

Display( "test10" );

Display( UniversalMorphismIntoDirectProduct( IdentityMorphism( obj ) ) );

Display( "test11" );

Display( UniversalMorphismIntoDirectProduct( ListOfObjectsInCategory( [ obj ], cat ), ListOfMorphismsInCategory( [ IdentityMorphism( obj ) ], cat ) ) );

Display( "test12" );

Display( UniversalMorphismIntoDirectProduct( ListOfObjectsInCategory( [ ], cat ), ListOfMorphismsInCategory( [ ], cat, Source, obj ) ) );

Display( "test13" );

Display( UniversalMorphismIntoDirectProductWithGivenDirectProduct( [ obj ], [ IdentityMorphism( obj ) ], DirectProduct( [ obj ] ) ) );

Display( "test14" );

Display( UniversalMorphismIntoDirectProductWithGivenDirectProduct( ListOfObjectsInCategory( [ obj ], cat ), ListOfMorphismsInCategory( [ IdentityMorphism( obj ) ], cat ), DirectProduct( [ obj ] ) ) );

Display( "test15" );

Display( UniversalMorphismIntoDirectProductWithGivenDirectProduct( ListOfObjectsInCategory( [ ], cat ), ListOfMorphismsInCategory( [ ], cat, Source, obj ), DirectProduct( ListOfObjectsInCategory( [ ], cat ) ) ) );

end;

test( FinSet( [ "x", "y" ] ), FinSets );
test( FinSet( 2 ), SkeletalFinSets );
