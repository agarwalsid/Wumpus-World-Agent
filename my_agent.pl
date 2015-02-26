%my_agent.pl

%   this procedure requires the external definition of two procedures:
%
%     init_agent: called after new world is initialized.  should perform
%                 any needed agent initialization.
%
%     run_agent(percept,action): given the current percept, this procedure
%                 should return an appropriate action, which is then
%                 executed.
%
% This is what should be fleshed out

init_agent:-
  format('\n=====================================================\n'),
  format('This is init_agent:\n\tIt gets called once, use it for your initialization\n\n'),
  format('=====================================================\n\n'),

  retractall(agentLocation(_,_)),
  retractall(agentOrientation(_)),
  retractall(pitAt(_,_)),
  retractall(wumpusAt(_,_)),
  retractall(safeAt(_,_)),
  retractall(wallsAt(_,_)),
  retractall(lossAt(_,_)),
  retractall(remLoc(_,_)),
  retractall(preLoc(_,_)),
  retractall(goldGrabbed(_)),
  retractall(flagF(_)),
  retractall(goldHeld(_)),
  assert(agentLocation(1,1)),
  assert(agentOrientation(0)),
  assert(safeAt(1,1)).


run_agent(Percept,Action):-
format('\n=====================================================\n'),
  format('This is run_agent(.,.):\n\t It gets called each time step.\n\t\n'),
  format('You might find "display_world" useful, for your debugging.\n'),
  display_world,
  format('=====================================================\n\n'),
  assert(flagF(1)),
    agentOrientation(U),
  nth1(1, Percept, A),
  nth1(2, Percept, B),
  nth1(3, Percept, C),
  nth1(4, Percept, D),
  nth1(5, Percept, E),
  (D == yes -> preLoc(M,N), write('p'); agentLocation(M,N), write('al')),

  M1 is M+1,
  M2 is M-1,
  N1 is N+1,
  N2 is N-1,

 write($M),write($N),
 retractall(preLoc(_,_)),
 K is M, L is N,
 assert(preLoc(K,L)),
 
 write('Gold:'), write(C),


 (M == 1, N == 1, goldHeld(1) -> Action=climb, retractall(flagF(_)), Q is M, R is N; F = no),


  write('Wumpus:'),write(A),
  (A == yes -> assert(wumpusAt(M1,N)),assert(wumpusAt(M2,N)),assert(wumpusAt(M,N1)),assert(wumpusAt(M,N2)), assert(lossAt(M,N)); A = no),

  write('Pit:'),write(B),
  (B == yes -> assert(pitAt(M1,N)),assert(pitAt(M2,N)),assert(pitAt(M,N1)),assert(pitAt(M,N2)), assert(lossAt(M,N)); B = no),

  (C == yes -> Action=grab, assert(goldGrabbed(1)), assert(goldHeld(1)), retractall(flagF(_)), V is U, write($U), retractall(agentOrientation(_)), assert(agentOrientation(V)), Q is M, R is N, retractall(lossAt(_,_)); F = no),
 (goldGrabbed(1), flagF(1) -> Action=turnright, write('Exec1'), retractall(goldGrabbed(_)), assert(goldGrabbed(2)), retractall(flagF(_)), V is U-90, write($U), retractall(agentOrientation(_)), assert(agentOrientation(V)), Q is M, R is N; F = no),
(goldGrabbed(2), flagF(1) -> Action=turnright, retractall(goldGrabbed(_)), assert(goldGrabbed(3)), retractall(flagF(_)), V is U-90, write($U), retractall(agentOrientation(_)), assert(agentOrientation(V)), Q is M, R is N; F = no),




  (A == no, B == no -> assert(safeAt(M1,N)),assert(safeAt(M2,N)),assert(safeAt(M,N1)),assert(safeAt(M,N2)); F = no),

  (D == no -> (agentOrientation(0)->S is M1, T is N; F = no), (agentOrientation(90)->S is M, T is N1; F = no), (agentOrientation(180)->S is M2, T is N; F = no), (agentOrientation(-90)->write('print'), S is M, T is N2; F = no), (agentOrientation(270)->S is M, T is N2; F = no); write('Work'), remLoc(W,Z), write($W), write($Z), S is W, T is Z),
  (pitAt(S,T), wumpusAt(S,T) -> assert(safeAt(S,T)); F = no),

  write('Wall:'),write(D),
  write($S),write($T),
  I = S, J = T,
  retractall(remLoc(_,_)),
  assert(remLoc(I,J)),
    (safeAt(S,T), D == no, not(lossAt(S,T)), flagF(1) -> Action=goforward, Q is S, R is T;Action=turnright, V is U-90, write($U), retractall(agentOrientation(_)), assert(agentOrientation(V)), Q is M, R is N; F = no),

  (agentOrientation(-90)->retractall(agentOrientation(_)), assert(agentOrientation(270)) ; F = no),
  retractall(agentLocation(_,_)),
  assert(agentLocation(Q,R)).

