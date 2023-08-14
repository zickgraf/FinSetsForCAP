#! @Chapter Precompilation

#! @Section Precompiling the category of skeletal finite sets

#! @Example

#! #@if ValueOption( "no_precompiled_code" ) <> true

LoadPackage( "FinSetsForCAP", false );
#! true
LoadPackage( "CompilerForCAP", false );
#! true

ReadPackage( "FinSetsForCAP", "gap/CompilerLogic.gi" );
#! true

category_constructor := {} -> SkeletalCategoryOfFiniteSets( );;
given_arguments := [ ];;
compiled_category_name :=
  "SkeletalCategoryOfFiniteSetsWithMorphismsGivenByListsPrecompiled";;
package_name := "FinSetsForCAP";;
primitive_operations :=
  ListPrimitivelyInstalledOperationsOfCategory(
          category_constructor( : no_precompiled_code := true ) );;
list_of_operations :=
  SortedList( Concatenation( primitive_operations, [
          "IsHomSetInhabited",
          "TruthMorphismOfImplies",
          #"HasPushoutComplement",
          "PushoutComplement",
          ] ) );;

CapJitPrecompileCategoryAndCompareResult(
        category_constructor,
        given_arguments,
        package_name,
        compiled_category_name
        : operations := list_of_operations,
        number_of_objectified_objects_in_data_structure_of_object := 1,
        number_of_objectified_morphisms_in_data_structure_of_object := 0,
        number_of_objectified_objects_in_data_structure_of_morphism := 2,
        number_of_objectified_morphisms_in_data_structure_of_morphism := 1
);;

SkeletalCategoryOfFiniteSetsWithMorphismsGivenByListsPrecompiled( );
#! SkeletalFinSets

cat := SkeletalCategoryOfFiniteSets( );
#! SkeletalFinSets

cat!.precompiled_functions_added;
#! true

#! #@fi

#! @EndExample
