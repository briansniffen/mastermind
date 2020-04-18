?- use_module(library(clpfd)).

% Jeff's specific problem

jcb_rules([mastermind([6,8,2],1,0),
	   mastermind([6,1,4],0,1),
	   mastermind([2,0,6],0,2),
	   mastermind([7,3,8],0,0),
	   mastermind([3,8,0],0,1)]).

jcb(Answer,RuleNumbers) :- maplist(jcb_helper(Answer),RuleNumbers).

jcb_helper(Answer,RuleNumber) :- jcb_rules(Rules),
				 nth0(RuleNumber,Rules,Rule),
				 call(Rule,Answer).

jcb(Answer) :- jcb(Answer,[0,1,2,3,4]).

% How to play Mastermind

mastermind(Guess,Black,White,Answer) :-
    layout(Guess),
    layout(Answer),
    digits(Guess),
    digits(Answer),
    count_blacks(Guess, Answer, Black),
    count_whites(Guess, Answer, N),
    N #= White + Black.

layout([_,_,_]).

digits(X) :- X ins 0..9.

count_blacks([],[],0).
count_blacks([H1|T1], [H2|T2], Cnt2) :- H1#=H2,
					Cnt2 #= Cnt1+1,
					count_blacks(T1,T2,Cnt1).
count_blacks([H1|T1], [H2|T2], Cnt) :- H1#\=H2,
				       count_blacks(T1,T2,Cnt).

count_whites(G,A,N) :- numlist(0,9,Ds),
		       pairs_keys(Gcard,Ds), pairs_keys(Acard,Ds),
		       pairs_values(Gcard,Gvals), pairs_values(Acard,Avals),
		       % https://www.swi-prolog.org/pldoc/doc_for?object=global_cardinality/2
		       global_cardinality(G,Gcard), global_cardinality(A,Acard),
		       foldl(mins_,Gvals,Avals,0,N).

mins_(Gval,Aval,V0,V) :- V #= V0 + min(Gval,Aval).

% What's the shortest set of constraints that actually solves it?

powerset([], []).
powerset([_|T], P) :- powerset(T,P).
powerset([H|T], [H|P]) :- powerset(T,P).

which_rules(Answers) :-
    numlist(0,4,Rules),
    powerset(Rules,Rule_Set),
    findall(Rule_Set-Answer,(jcb(Answer,Rule_Set),
			     no_hanging_goals(Answer)),
	    Answers).

% https://www.swi-prolog.org/pldoc/man?predicate=copy_term/3
no_hanging_goals(X) :- copy_term(X,X,[]).

shortest_rules(Shortest) :- findall(L-R,(which_rules([R-_]),
					 length(R,L),
					 L > 0),
				    X),
			    keysort(X,Xsort),
			    group_pairs_by_key(Xsort,[_-Shortest|_]).
