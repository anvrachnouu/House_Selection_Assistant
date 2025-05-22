%Δημιουργία βάσης δεδομένων σπιτιών, όπου για κάθε σπίτι έχει τα εξής χαρακτηριστικά:
% το ID του, το εμβαδόν του (m2), τον αριθμό δωματίων,
% αν είναι καινούριο ή παλιό, αν είναι πολυκατοικία ή μεζονέτα, αν έχει χώρο στάθμευσης (parking),
% την περιοχή στην οποία βρίσκεται, και την τιμή του.
house(1, 95, 3, old, p, n, kalamaria, 190000).
house(2, 105, 2, old, m, y, pylaia, 189000).
house(3, 111, 3, new, p, y, toumpa, 177600).
house(4, 84, 2, old, p, n, anopoli, 142800).
house(5, 97, 2, new, m, n, agios_pavlos, 145500).
house(6, 93, 2, new, p, n, sykies, 120900).
house(7, 120, 3, new, m, n, stavroupoli, 144000).
house(8, 130, 4, new, p, y, evosmos, 130000).
house(9, 92, 2, old, p, n, menemeni, 128800).
house(10, 115, 3, new, p, y, pylaia, 210000).
house(11, 140, 2, new, p, y, kifisia, 270000).

% Κατηγορήματα για ερωτήσεις στον χρήστη και εισαγωγή δεδομένων από τον χρήστη
%μέγεθος του σπιτιού
ask_size(Size) :-
    write('Theleis mikro, mesaio h megalo spiti? '),
    read(Size).

%περιοχή που προτιμάει
ask_area(Area) :-
    write('Se poia perioxi (anatolika/kentro/dytika)? '),
    read(Area).

%καινούριο ή παλιό σπίτι
ask_condition(Condition) :-
    write('Theleis kainoyrio h palio spiti (new/old)? '),
    read(Condition).

%πολυκατοικία ή μεζονέτα
ask_type(Type) :-
    write('Theleis Polykatoikia h mezoneta (p/m)? '),
    read(Type).

%πόσα μέλη έχει η οικογένειά του χρήστη
ask_family_members(Members) :-
    write('Posa melh exei h oikogeneia? '),
    read(Members).

%αν έχει αυτοκίνητο
ask_car(Car) :-
    write('Exeis amaksi (y/n)? '),
    read(Car).

%μέγιστο ποσό που μπορεί να διαθέσει
ask_budget(Budget) :-
    write('Poio einai to megisto poso poy mporeis na diatheseis? '),
    read(Budget).

% Συνάρτηση για την καταλληλότητα μεγέθους σπιτιού ανάλογα με τα μέλη της οικογένειας
%Μικρό σπίτι: <25 m2 ανά άτομο
suitable_size(mikro, HouseSize, Members) :-
    TotalSize is HouseSize / Members,
    TotalSize < 25.

%Μεσαίο σπίτι: >25 και <35 m2 ανά άτομο
suitable_size(mesaio, HouseSize, Members) :-
    TotalSize is HouseSize / Members,
    TotalSize >= 25,
    TotalSize =< 35.

%Μεγάλο σπίτι: >35 m2 ανά άτομο
suitable_size(megalo, HouseSize, Members) :-
    TotalSize is HouseSize / Members,
    TotalSize > 35.

% Συνάρτηση για τον έλεγχο καταλληλότητας δωματίων
%μέγιστος αριθμός δωματίων:n-1, και ο ελάχιστος είναι το αποτέλεσμα της διαίρεσης των μελών δια 2
suitable_rooms(Members, Rooms) :-
    MaxRooms is Members - 1,
    MinRooms is ceil(Members / 2),
    Rooms =< MaxRooms,
    Rooms >= MinRooms.

% Συνάρτηση για την καταλληλότητα περιοχής
%ανάλογα περιοχή που προτιμάει ο χρήστης (Ανατολικά, Κέντρο, Δυτικά), επιλέγονται οι αντίστοιχες συνοικίες
suitable_area(anatolika, Area) :-
    member(Area, [kalamaria, kifisia, pylaia, toumpa]).

suitable_area(kentro, Area) :-
    member(Area, [anopoli, agios_pavlos, sykies]).

suitable_area(dytika, Area) :-
    member(Area, [stavroupoli, evosmos, menemeni]).

% Συνάρτηση για την καταλληλότητα του parking
% Αν ο χρήστης έχει αυτοκίνητο (y), το σπίτι πρέπει να έχει parking (y). Αν δεν έχει αυτοκίνητο, αδιαφορεί για το parking.
suitable_parking(y, y).
suitable_parking(n, _).

% Συνάρτηση για την εύρεση σπιτιού που να ταιριάζει με τα χαρακτηριστικά που εισήγαγε ο χρήστης
find_house :-
    ask_size(Size),               % Ερώτηση για το μέγεθος του σπιτιού
    ask_area(Area),               % Ερώτηση για την περιοχή
    ask_condition(Condition),     % Ερώτηση αν το σπίτι είναι καινούριο ή παλιό
    ask_type(Type),               % Ερώτηση αν θέλει πολυκατοικία ή μεζονέτα
    ask_family_members(Members),  % Ερώτηση τον αριθμό των μελών της οικογένειας
    ask_car(Car),                 % Ερώτηση αν έχει αυτοκίνητο
    ask_budget(Budget),           % Ερώτηση για το διαθέσιμο budget

% Εύρεση κατάλληλων σπιτιών βάσει των χαρακτηριστικών που εισήγαγε ο χρήστης
    findall([ID, HouseSize, Rooms, HouseCondition, HouseType, HouseCar, HouseArea, HousePrice], (
        house(ID, HouseSize, Rooms, HouseCondition, HouseType, HouseCar, HouseArea, HousePrice),
        suitable_size(Size, HouseSize, Members),         % Έλεγχος καταλληλότητας μεγέθους
        suitable_rooms(Members, Rooms),                  % Έλεγχος καταλληλότητας δωματίων
        suitable_area(Area, HouseArea),                  % Έλεγχος περιοχής
        suitable_parking(Car, HouseCar),                 % Έλεγχος αν υπάρχει parking
        HouseCondition = Condition,                      % Έλεγχος αν το σπίτι είναι καινούριο ή παλιό
        HouseType = Type,                                % Έλεγχος αν είναι πολυκατοικία ή μεζονέτα
        HousePrice =< Budget                             % Έλεγχος αν η τιμή είναι εντός budget
    ), SuitableHouses),

% Αν δεν υπάρχουν κατάλληλα σπίτια, εμφανίζεται μήνυμα. Αλλιώς, εμφανίζονται τα κατάλληλα σπίτια με τα χαρακτηριστικά τους.
    (SuitableHouses = [] ->
        write('Den yparxei spiti poy na symfwnei me tis prodiagrafes.'), nl;
        write('Ta katallila spitia einai: '), nl, 
        display_houses(SuitableHouses)).

% Συνάρτηση για την εμφάνιση των χαρακτηριστικών των σπιτιών
display_houses([]).
display_houses([[ID, HouseSize, Rooms, HouseCondition, HouseType, HouseCar, HouseArea, HousePrice] | Tail]) :-
    write('Ena katallilo spiti gia sena einai to no '), write(ID), nl,
    write('    Embado: '), write(HouseSize), nl,
    write('    Domatia: '), write(Rooms), nl,
    write('    Hlikia: '), write(HouseCondition), nl,
    write('    Typos: '), write(HouseType), nl,
    write('    Parking: '), write(HouseCar), nl,
    write('    Synoikia: '), write(HouseArea), nl,
    write('    Timh: '), write(HousePrice), nl, nl,
    display_houses(Tail).

% Εκκίνηση του προγράμματος
run :-
    find_house.
