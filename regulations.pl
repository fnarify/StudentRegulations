% Name:           Bao-lim Smith
% Student Number: 43277047

% Import our required files.
:- consult('kb_degrees.pl').
:- consult('kb_transcripts.pl').

% Style checking.
:- style_check([-singleton, -discontiguous]).

/*
 * 100 level credit points.
 */
check_cp([], X, X).

% Checks how many credit points are satisfied in a list.
% Works by recursively iterating through a given list and if it a unit
% has a passing mark, then add the amount of credit points it is worth
% to a running total.
check_cp([[_, _, Mark, Pts] | Tail], InitialVal, NumCredPts) :-
	( Mark >= 50 ->
	    NumCredPts2 is InitialVal + Pts,
	    check_cp(Tail, NumCredPts2, NumCredPts)
	;
	    check_cp(Tail, InitialVal, NumCredPts)
	).

% Does this list contain required character code.
% If so unify the amount of Pts it gives with our result.
% If not just give 0 back.
contains2([_, _, _, 50 | _], Pts, Pts).
contains2([_, _, _, _, 50 | _], Pts, Pts).
contains2(_, _, 0).

contains3([_, _, _, 51 | _], Pts, Pts).
contains3([_, _, _, _, 51 |_], Pts, Pts).
contains3(_, _, 0).

/*
 * 200 level credit points.
 */
check_cp2([], X, X).

% Checks how many 200 level units are satisfied and gives their total
% credit point value. This rule considers if the fourth or fifth
% character in the unit name has character code 50 == '2'.
%
% This works off the assumption that the numeric part of each unit name
% occurs after the fouth of fifth character, which is standardised for
% each unit in kb_degrees. If this is not true a different (sub-string
% type) method will be needed.
check_cp2([[Unit, _, Mark, Pts] | Tail], InitialVal, NumCredPts) :-
	( Mark >= 50 ->
	    string_to_list(Unit, List),
	    contains2(List, Pts, Value),
	    NumCredPts2 is InitialVal + Value,
	    % The cut prevents us attempting other solutions that aren't needed.
	    check_cp2(Tail, NumCredPts2, NumCredPts), !
	;
	    check_cp2(Tail, InitialVal, NumCredPts), !
        ).

/*
 * 300 level credit points.
 */
check_cp3([], X, X).

% Similar to check_cp3, except for 300-level units, so checks if the
% fourth or fifth character has character code 51 == '3'.
%
% We also have assumption that there are no units to consider above 300
% level. E.g, no postgraduate/honours level units. But this can be
% easily fixed.
check_cp3([[Unit, _, Mark, Pts] | Tail], InitialVal, NumCredPts) :-
	( Mark >= 50 ->
	    string_to_list(Unit, List),
	    contains3(List, Pts, Value),
            NumCredPts2 is InitialVal + Value,
            check_cp3(Tail, NumCredPts2, NumCredPts), !
	;
	    check_cp3(Tail, InitialVal, NumCredPts), !
	).

/*
 * Foundation Units
 */
check_found(_, [], X, X).

% Checks how many credit points of foundation units are completed.
check_found(DegID, [[Unit, _, Mark, Pts] | Tail], InitialVal, NumCredPts) :-
	( Mark >= 50, foundation_unit(DegID, Unit) ->
	    NumCredPts2 is InitialVal + Pts,
	    check_found(DegID, Tail, NumCredPts2, NumCredPts)
	;
	    check_found(DegID, Tail, InitialVal, NumCredPts)
	).
/*
 * Major and pace units.
 */
% Either no more units to check or we have checked as many units as we
% need to, then unify our result.
check_major([], _, _, X, X).
check_major(_, _, 0, X, X).
check_major_units([], _, X, X).

% For just the end elements of the tail of a list.
check_major([Unit], Results, Counter, InitialVal, NumMajorPts) :-
	check_major(Unit, Results, Counter, InitialVal, NumMajorPts).

% Unify to a list. If the unit given is a member of our list of results,
% and we have passed that unit then decrement the counter and add the
% credit point value of that unit to our running total.
% Else, check the other units in the list.
check_major([Unit | Rest], Results, Counter, InitialVal, NumMajorPts) :-
	( member([Unit, _, Mark, Pts], Results), Mark >= 50 ->
	    Counter2 is Counter - 1,
	    CurrentPts is InitialVal + Pts,
	    check_major(Rest, Results, Counter2, CurrentPts, NumMajorPts), !
	;
	    check_major(Rest, Results, Counter, InitialVal, NumMajorPts)
	).

% Unify a single element. Perform similar operations to above, except we
% don't care about the counter here, and since there is only one element
% when we call the function again it is on an empty list.
check_major(Unit, Results, _, InitialVal, NumMajorPts) :-
        ( member([Unit, _, Mark, Pts], Results), Mark >= 50 ->
	    CurrentPts is InitialVal + Pts,
	    check_major([], _, 0, CurrentPts, NumMajorPts), !
	;
	    check_major([], _, 0, InitialVal, NumMajorPts)
	).

% Split up any atoms in our list of major units. Then call check_major
% on the units in the atom, with a counter value corresponding to the
% atom. Then attempt to break up the rest of the list.
check_major_units([one_of(Units) | Rest], Results, InitialVal, NumMajorPts2) :-
	check_major(Units, Results, 1, InitialVal, NumMajorPts),
	check_major_units(Rest, Results, NumMajorPts, NumMajorPts2).
check_major_units([two_of(Units) | Rest], Results, InitialVal, NumMajorPts2) :-
	check_major(Units, Results, 2, InitialVal, NumMajorPts),
	check_major_units(Rest, Results, NumMajorPts, NumMajorPts2).
check_major_units([three_of(Units) | Rest], Results, InitialVal, NumMajorPts2) :-
	check_major(Units, Results, 3, InitialVal, NumMajorPts),
	check_major_units(Rest, Results, NumMajorPts, NumMajorPts2).

% Break up our list of major units, and get our total amount of points
% satisfied towards the given major.
check_major_units([Unit | Rest], Results, InitialVal, NumMajorPts2) :-
	check_major(Unit, Results, -1, InitialVal, NumMajorPts),
	check_major_units(Rest, Results, NumMajorPts, NumMajorPts2).

% If the given pace unit for our major has been passed then return how
% many credit points it is worth, otherwise return 0.
% Works off the assumption that only one pace unit exists per major.
check_pace(MajorID, Results, PaceCredPts, SatisfyPace) :-
	pace_unit(MajorID, PaceUnit),
	( member([PaceUnit, _, Mark, Pts], Results), Mark >= 50 ->
	    PaceCredPts = Pts,
	    SatisfyPace = "yes"
	;
	    % We bind the "no" variant of SatisfyPace late so that it
	    % doesn't get bound before it is actually needed.
	    PaceCredPts = 0
	).

% Base case, only occurs if we can find no qualifying major.
complete_major([], _, "no", _, "--").

% For the end element in the tail of the list, so it can unify.
complete_major([[MajorID, MajorName, CredPtMajor]], Results, Satisfy, SatisfyPace, CompletedMajorName) :-
	complete_major([MajorID, MajorName, CredPtMajor], Results, Satisfy, SatisfyPace, CompletedMajorName).

% Check each major and linked pace unit to see if it can be
% satisfied and if one is satisfied then say so and return.
complete_major([[MajorID, MajorName, CredPtMajor] | Tail], Results, Satisfy, SatisfyPace, CompletedMajorName) :-
	% Collect all units in our major.
	findall(X, major_unit(MajorID, X), MajorUnitCodes),
	check_major_units(MajorUnitCodes, Results, 0, NumMajorPts),
	check_pace(MajorID, Results, PaceCredPts, SatisfyPace),
	( NumMajorPts + PaceCredPts >= CredPtMajor ->
	    % If we can satisfy a major no need to backtrack.
	    Satisfy = "yes",
	    CompletedMajorName = MajorName, !
	;
	    % Otherwise check if we can complete other majors, we should never need to backtrack.
	    complete_major(Tail, Results, Satisfy, SatisfyPace, CompletedMajorName), !
	).

/*
 * People and planet units.
 */
% No people units found, return "no".
check_people([], _, _, _, "no").

% Given a list of people units and respective faculties, check if a
% student has succesfully completed one.
check_people([[PeopleUnit, Faculty] | Rest], Results, MajorID, PeopleFaculty, SatisfyPeople) :-
	( major_unit(MajorID, PeopleUnit) ->
	    % If this people unit is part of the students major program	it is not valid.
	    check_people(Rest, Results, MajorID, PeopleFaculty, SatisfyPeople)
	;
	  member([PeopleUnit, _, Mark, _], Results), Mark >= 50 ->
	    PeopleFaculty = Faculty,
	    SatisfyPeople = "yes"
	;
	    check_people(Rest, Results, MajorID, PeopleFaculty, SatisfyPeople)
	).

% No planet units found, return "no".
check_planet([], _, _, _, "no").

% Similar to check_people except that it also checks if the faculty of a
% completed planet unit cannot be the same as that of a people unit.
check_planet([[PlanetUnit, Faculty] | Rest], Results, MajorID, PeopleFaculty, SatisfyPlanet) :-
	( major_unit(MajorID, PlanetUnit) ->
	   check_planet(Rest, Results, MajorID, PeopleFaculty, SatisfyPlanet)
	;
	  Faculty == PeopleFaculty ->
	    % If this faculty is the same as the faculty of a completed people unit
	    % skip to the next element of the list.
	    check_planet(Rest, Results, MajorID, PeopleFaculty, SatisfyPlanet)
	;
	  member([PlanetUnit, _, Mark, _], Results), Mark >= 50 ->
	    SatisfyPlanet = "yes"
	;
	    check_planet(Rest, Results, MajorID, PeopleFaculty, SatisfyPlanet)
	).

% For converting a result into a string.
greater_equal(A, B, Answer) :-
	( A >= B ->
	    Answer = "yes"
	;
	    Answer = "no"
	).

print_results([]).

% Print out the results related to the students given.
print_results([[ID, FirstName, LastName, DegID, Results] | Rest]) :-
	degree(DegID, DegName, _, _, [MinCredPt, CredPt200, CredPt300, FndCredPt]),
	% Whether the requisite amount of credit points are met.
	check_cp(Results, 0, NumCredPts),
	greater_equal(NumCredPts, MinCredPt, SatisfyMinCred),
	% Calculate the amount of credit points at 200 and 300 level.
	check_cp2(Results, 0, NumCredPts200),
	check_cp3(Results, 0, NumCredPts300),
	greater_equal(NumCredPts200 + NumCredPts300, CredPt200, Satisfy2),
	greater_equal(NumCredPts300, CredPt300, Satisfy3),
	% Calculate the amount of credit points towards foundation units.
	check_found(DegID, Results, 0, NumFoundPts),
	greater_equal(NumFoundPts, FndCredPt, SatisfyFnd),
	% Now we check if we qualify for any majors.
	findall([X, Y, Z], qualifying_major(DegID, X, Y, Z), MajorIDs),
	complete_major(MajorIDs, Results, SatisfyMajor, SatisfyPace, CompletedMajorName),
	% Bound SatisfyPace, with a default case only if it hasn't already been bound.
	( string(SatisfyPace) ->
	    true
	;
	    SatisfyPace = "no"
	),
	% Check if we've satisfied our people and planet units.
	findall([Name, Faculty], people_unit(Name, Faculty), PeopleUnits),
	findall([Name, Faculty], planet_unit(Name, Faculty), PlanetUnits),
	check_people(PeopleUnits, Results, MajorID, PeopleFaculty, SatisfyPeople),
	check_planet(PlanetUnits, Results, MajorID, PeopleFaculty, SatisfyPlanet),
	% Print out how the student satisfies the requirements.
	format("~n~nStudent Number: ~17| ~d ~n", ID),
	format("First Name: ~17| ~s ~n", FirstName),
	format("Last Name: ~17| ~s ~n", LastName),
	format("Degree: ~17| ~s ~n", DegName),
	format("Qualifying Major: ~s ~n", CompletedMajorName),
	format("Completed Min CP Degree: ~32| ~s ~n", SatisfyMinCred),
	format("Completed Min CP @ 200 or above: ~s ~n", Satisfy2),
	format("Completed Min CP @ 300 or above: ~s ~n", Satisfy3),
	format("Completed Foundation Units: ~32| ~s ~n", SatisfyFnd),
        format("Completed Qualifying Major: ~32| ~s ~n", SatisfyMajor),
	format("Completed People Unit: ~32| ~s ~n", SatisfyPeople),
	format("Completed Planet Unit: ~32| ~s ~n", SatisfyPlanet),
        format("Completed PACE Unit: ~32| ~s ~n", SatisfyPace),
	print_results(Rest).


% Check the requirements given by kb_degrees on the transcripts as
% listed in kb_transcript.
check_transcripts() :-
	findall([A, B, C, D, E], student(A, B, C, D, E), StudentList),
	print_results(StudentList).

/*
 * Extended Version methods.
 */
% We can satisfy this atom, just return an empty list.
check_major_atom(_, _, 0, _, []).
% Otherwise there are some elements in this atom that can't be satisfied
% so create a new atom, that corresponds to the counter.
check_major_atom([], _, Counter, CurrentList, FinalList) :-
	( Counter == 1 ->
	    FinalList = one_of(CurrentList)
	;
	  Counter == 2 ->
	    FinalList = two_of(CurrentList)
	;
	  Counter == 3 ->
	    FinalList = three_of(CurrentList)
	).


% Collect all units that are not satisfied in a given atom.
check_major_atom([Unit | Rest], Results, Counter, InitialList, FinalList) :-
	( member([Unit, _, Mark, _], Results), Mark >= 50 ->
	    Counter2 is Counter - 1,
	    check_major_atom(Rest, Results, Counter2, InitialList, FinalList)
	;
	    append([Unit], InitialList, InitialList2),
	    check_major_atom(Rest, Results, Counter, InitialList2, FinalList)
	).

% Checked all units, unify our results.
check_major_ex([], _, X, X).

% Break up the major units for a given ID based on what it can be, then
% create a list that collects all units that are not satisfied in the
% major.
check_major_ex([Unit | Rest], Results, CurrentList, MajorUnits) :-
	( Unit = one_of(Units) ->
	    check_major_atom(Units, Results, 1, [], AtomList),
	    ( AtomList == [] ->
	        check_major_ex(Rest, Results, CurrentList, MajorUnits)
	    ;
		append([AtomList], CurrentList, MajorUnits2),
	        check_major_ex(Rest, Results, MajorUnits2, MajorUnits)
	    )
	;
	  Unit = two_of(Units) ->
	    check_major_atom(Units, Results, 1, [], AtomList),
	    append([AtomList], CurrentList, MajorUnits2),
	    ( AtomList == [] ->
	        check_major_ex(Rest, Results, CurrentList, MajorUnits)
	    ;
		append([AtomList], CurrentList, MajorUnits2),
	        check_major_ex(Rest, Results, MajorUnits2, MajorUnits)
	    )
	;
	  Unit = three_of(Units) ->
	    check_major_atom(Units, Results, 3, [], AtomList),
	    append([AtomList], CurrentList, MajorUnits2),
	    ( AtomList == [] ->
	        check_major_ex(Rest, Results, CurrentList, MajorUnits)
	    ;
		append([AtomList], CurrentList, MajorUnits2),
	        check_major_ex(Rest, Results, MajorUnits2, MajorUnits)
	    )
	;
	  member([Unit, _, Mark, _], Results), Mark >= 50 ->
	    check_major_ex(Rest, Results, CurrentList, MajorUnits)
	;
	    append([Unit], CurrentList, MajorUnits2),
	    check_major_ex(Rest, Results, MajorUnits2, MajorUnits)
	).

% Given a student's results, calculate what is needed to finish the
% first major in our knowledge base.
to_complete_major([[MajorID, MajorName, _] | _], Results, MajorName, MajorID, MajorUnits) :-
	findall(X, major_unit(MajorID, X), MajorUnitCodes),
	check_major_ex(MajorUnitCodes, Results, [], MajorUnits).

complete_people([], _, _, _).

complete_people([[PeopleUnit, Faculty] | Rest], Results, PeopleFaculty, CompletePeopleUnit) :-
	( member([PeopleUnit, _, Mark, _], Results), Mark >= 50 ->
	    complete_people(Rest, Results, PeopleFaculty, CompletePeopleUnit)
	;
	    PeopleFaculty = Faculty,
	    CompletePeopleUnit = PeopleUnit
	).

complete_planet([], _, _, _).

complete_planet([[PlanetUnit, Faculty] | Rest], Results, PeopleFaculty, CompletePlanetUnit) :-
	( member([PlanetUnit, _, Mark, _], Results), Mark >= 50 ->
	    complete_people(Rest, Results, PeopleFaculty, CompletePlanetUnit)
	;
	  Faculty == PeopleFaculty ->
	    complete_people(Rest, Results, PeopleFaculty, CompletePlanetUnit)
	;
	    CompletePlanetUnit = PlanetUnit
	).

print_results_ex([]).

% Print out the results related to the students given.
% Extended Version:
% Displays what is needed to finish any of the requirements.
print_results_ex([[ID, FirstName, LastName, DegID, Results] | Rest]) :-
	degree(DegID, DegName, _, _, [MinCredPt, CredPt200, CredPt300, FndCredPt]),
	% Whether the requisite amount of credit points are met.
	check_cp(Results, 0, NumCredPts),
	greater_equal(NumCredPts, MinCredPt, SatisfyMinCred),
	% Calculate the amount of credit points at 200 and 300 level.
	check_cp2(Results, 0, NumCredPts200),
	check_cp3(Results, 0, NumCredPts300),
	greater_equal(NumCredPts200 + NumCredPts300, CredPt200, Satisfy2),
	greater_equal(NumCredPts300, CredPt300, Satisfy3),
	% Calculate the amount of credit points towards foundation units.
	check_found(DegID, Results, 0, NumFoundPts),
	greater_equal(NumFoundPts, FndCredPt, SatisfyFnd),
	% Now we check if we qualify for any majors.
	findall([X, Y, Z], qualifying_major(DegID, X, Y, Z), MajorIDs),
	complete_major(MajorIDs, Results, SatisfyMajor, SatisfyPace, CompletedMajorName),
	% Bound SatisfyPace, with a default case only if it hasn't already been bound.
	( string(SatisfyPace) ->
	    true
	;
	    SatisfyPace = "no"
	),
	% Check if we've satisfied our people and planet units.
	findall([Name, Faculty], people_unit(Name, Faculty), PeopleUnits),
	findall([Name, Faculty], planet_unit(Name, Faculty), PlanetUnits),
	check_people(PeopleUnits, Results, MajorID, PeopleFaculty, SatisfyPeople),
	check_planet(PlanetUnits, Results, MajorID, PeopleFaculty, SatisfyPlanet),

	% Print out how the student satisfies the requirements.
	format("~n~nStudent Number: ~17| ~d ~n", ID),
	format("First Name: ~17| ~s ~n", FirstName),
	format("Last Name: ~17| ~s ~n", LastName),
	format("Degree: ~17| ~s ~n", DegName),
	format("Qualifying Major: ~s ~n", CompletedMajorName),

	format("Completed Min CP Degree: ~32| ~s ~n", SatisfyMinCred),
	( SatisfyMinCred == "no" ->
	    format("~2|You need ~d credit points ", MinCredPt - NumCredPts),
	    format("to complete the min amount of credit points ~n")
	;
	    true
	),

	format("Completed Min CP @ 200 or above: ~s ~n", Satisfy2),
	( Satisfy2 == "no" ->
	    format("~2|You need ~d credit points ", CredPt200 - (NumCredPts200 + NumCredPts300)),
	    format("to complete the min amount of CP @ 200 or above ~n")
	;
	    true
	),

	format("Completed Min CP @ 300 or above: ~s ~n", Satisfy3),
	( Satisfy3 == "no" ->
	    format("~2|You need ~d credit points ", CredPt300 - NumCredPts300),
	    format("to complete the min amount of CP @ 300 ~n")
	;
	    true
	),

	format("Completed Foundation Units: ~32| ~s ~n", SatisfyFnd),
        ( SatisfyFnd == "no" ->
	    format("~2|You need to complete ~d foundation units ", (FndCredPt - NumFoundPts)/3),
	    format("to satisfy the amount of foundation units required ~n")
	;
	    true
	),

        format("Completed Qualifying Major: ~32| ~s ~n", SatisfyMajor),
	( SatisfyMajor = "no" ->
	    once(to_complete_major(MajorIDs, Results, CanCompleteMajorName, CanCompleteMajorID, MajorUnits)),
	    format("~2|To complete major: ~s ~n", CanCompleteMajorName),
	    format("~2|You need to finish: "),
	    write(MajorUnits),
	    pace_unit(CanCompleteMajorID, PaceUnit),
	    format("~n~2|And respective PACE unit: ~s ~n", PaceUnit)
	;
	    true
	),

	format("Completed People Unit: ~32| ~s ~n", SatisfyPeople),
	format("Completed Planet Unit: ~32| ~s ~n", SatisfyPlanet),
	( SatisfyPeople = "no" ->
	    complete_people(PeopleUnits, Results, CompletedFaculty, CompletedPeopleUnit),
	    format("~2|You can complete: ~s as your people unit ~n", CompletedPeopleUnit)
	;
	    true
	),
	( SatisfyPlanet == "no" ->
	    complete_planet(PlanetUnits, Results, CompletedFaculty, CompletedPlanetUnit),
	    format("~2|You can complete: ~s as your planet unit ~n", CompletedPlanetUnit)
	;
	    true
	),

        format("Completed PACE Unit: ~32| ~s ~n", SatisfyPace),
	print_results_ex(Rest).


% Run the extended version of check_transcripts.
check_transcripts_ex() :-
	findall([A, B, C, D, E], student(A, B, C, D, E), StudentList),
	print_results_ex(StudentList).
