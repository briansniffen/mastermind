

jcb(Answer) :-
    % 682; 1 right & in place
    mastermind([6,8,2],Answer,1,0),
    % 614; 1 right but wrong place
    mastermind([6,1,4],Answer,0,1),
    % 206; 2 digits right but wrong place
    mastermind([2,0,6],Answer,0,2).
    % 738; all wrong
%    mastermind([7,3,8],Answer,0,0),
    % 380; one right but wrong place
%    mastermind([3,8,0],Answer,0,1).

mastermind(Guess,Answer,Black,White) :-
    layout(Guess),
    layout(Answer),
    all(Guess,digit),
    all(Answer,digit),
    count_blacks(Guess, Answer, Black),
    count_whites(Guess, Answer, N),
    White is N - Black.

layout(X) :- X=[_,_,_].

digit(0).
digit(1).
digit(2).
digit(3).
digit(4).
digit(5).
digit(6).
digit(7).
digit(8).
digit(9).

% check if all elements of a list fulfill certain criteria
all([],_).
all([H|T],Function) :- call(Function,H),all(T,Function).

count_blacks([],[],0).
count_blacks([H1|T1], [H2|T2], Cnt2) :- H1=H2,count_blacks(T1,T2,Cnt1),Cnt2 is Cnt1+1.
count_blacks([H1|T1], [H2|T2], Cnt) :- \+ H1=H2,count_blacks(T1,T2,Cnt).

count_whites(G,A,N) :-
    color_cooccurrence(G,A,0,C0),
    color_cooccurrence(G,A,1,C1),
    color_cooccurrence(G,A,2,C2),
    color_cooccurrence(G,A,3,C3),
    color_cooccurrence(G,A,4,C4),
    color_cooccurrence(G,A,5,C5),
    color_cooccurrence(G,A,6,C6),
    color_cooccurrence(G,A,7,C7),
    color_cooccurrence(G,A,8,C8),
    color_cooccurrence(G,A,9,C9),
    N is C0+C1+C2+C3+C4+C5+C6+C7+C8+C9.
 
% count color cooccurrences in C and G list
color_cooccurrence(C,G,Color,Cnt) :-
countall(C,Color,CCnt),
countall(G,Color,GCnt),
min(GCnt,CCnt,Cnt).
 
% count occurrence in list
count([],X,0).
count([X|T],X,Y):- count(T,X,Z), Y is 1+Z.
count([X1|T],X,Z):- X1\=X,count(T,X,Z).

countall(List,X,0) :-
    sort(List,List1),
    \+ member(X,List1).
countall(List,X,C) :-
    sort(List,List1),
    member(X,List1),
    count(List,X,C).
 
% min of two objects
min(X,Y,X) :- X<Y.
min(X,Y,Y) :- X>=Y.
    
