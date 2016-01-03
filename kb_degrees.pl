% ===================================================================================
% Project: COMP329 - Assignment 2
% File:    kb_degrees.pl
%
% Author:  Rolf Schwitter
% Date:    2015-10-16
% ===================================================================================


% -----------------------------------------------------------------------------------
% Style checking
% -----------------------------------------------------------------------------------

:- style_check([-singleton, -discontiguous]).


% -----------------------------------------------------------------------------------
% Bachelor of Information Technology
%
%   degree(DegreeID, DegreeName, Department, Faculty, ListOfCP).
% -----------------------------------------------------------------------------------

degree('INTE07',
       'Bachelor of Information Technology',
       'Computing',
       'Science and Engineering',
       [72, 42, 18, 9]).


%------------------------------------------------------------------------------------
% Bachelor of Information Technology
%
% required foundation units
%
%   foundation_unit(DegreeID, UnitCode).
% -----------------------------------------------------------------------------------

foundation_unit('INTE07', 'COMP115').
foundation_unit('INTE07', 'ISYS114').
foundation_unit('INTE07', 'COMP247').


%------------------------------------------------------------------------------------
% Qualifying Majors for a Bachelor of Information Technology
%
%   qualifying_major(DegreeID, MajorID, MajorName, CreditPoints).
% -----------------------------------------------------------------------------------

qualifying_major('INTE07', 'INSY01', 'Information Systems and Business Analysis', 36).
qualifying_major('INTE07', 'SOT02',  'Software Technology', 36).
qualifying_major('INTE07', 'WEB02',  'Web Design and Development', 36).


%------------------------------------------------------------------------------------
% Information Systems and Business Analysis
%
% required major units and required pace unit
%
%   major_unit(MajorID, UnitCode)
%   pace_unit(MajorID, UnitCode)
% -----------------------------------------------------------------------------------

major_unit('INSY01', 'ISYS104').
major_unit('INSY01', 'ISYS114').
major_unit('INSY01', one_of(['ACCG100', 'ACCG106'])).
major_unit('INSY01', one_of(['STAT170', 'STAT171'])).

major_unit('INSY01', 'ACCG250').
major_unit('INSY01', 'ISYS224').
major_unit('INSY01', 'ISYS254').
major_unit('INSY01', 'COMP247').

major_unit('INSY01', 'ACCG355').
major_unit('INSY01', 'ACCG358').
major_unit('INSY01', one_of(['ISYS301', 'ISYS302'])).

pace_unit('INSY01', 'ISYS358').


%------------------------------------------------------------------------------------
% Software Technology
%
% required major units and required pace unit
%
%   major_unit(MajorID, UnitCode)
%   pace_unit(MajorID, UnitCode)
% -----------------------------------------------------------------------------------

major_unit('SOT02', 'COMP115').
major_unit('SOT02', 'COMP125').
major_unit('SOT02', 'DMTH137').
major_unit('SOT02', 'ISYS114').

major_unit('SOT02', 'COMP255').
major_unit('SOT02', 'DMTH237').
major_unit('SOT02', two_of(['COMP202', 'COMP225', 'COMP229'])).

major_unit('SOT02', three_of(['COMP329', 'COMP330', 'COMP332', 'COMP333',
                              'COMP343', 'COMP344', 'COMP347', 'COMP348',
                              'COMP350', 'COMP388', 'ISYS326'])).

pace_unit('SOT02', 'COMP355').


%------------------------------------------------------------------------------------
% Web Design and Development
%
% required major units and required pace unit
%
%   major_unit(MajorID, UnitCode)
%   pace_unit(MajorID, UnitCode)
% -----------------------------------------------------------------------------------

major_unit('WEB02', 'COMP115').
major_unit('WEB02', 'DMTH137').
major_unit('WEB02', 'ISYS114').
major_unit('WEB02', 'MAS110').

major_unit('WEB02', 'COMP247').
major_unit('WEB02', 'COMP249').
major_unit('WEB02', 'ISYS224').
major_unit('WEB02', 'MAS241').

major_unit('WEB02', 'COMP344').
major_unit('WEB02', 'COMP348').
major_unit('WEB02', 'MAS340').

pace_unit('WEB02', 'COMP356').


%------------------------------------------------------------------------------------
% People units
%
%   people_unit(UnitCode, Faculty)
%-------------------------------------------------------------------------------------

people_unit('ABST100', 'Faculty of Arts').
people_unit('COGS202', 'Faculty of Human Science').
people_unit('GEOS251', 'Faculty of Science and Engineering').


% -----------------------------------------------------------------------------------
% Planet units
%
%   planet_unit(UnitCode, Faculty)
% -----------------------------------------------------------------------------------

planet_unit('ACCG260', 'Faculty of Business and Economics').
planet_unit('STAT170', 'Faculty of Science and Engineering').
planet_unit('ISYS100', 'Faculty of Science and Engineering').


% -----------------------------------------------------------------------------------
% Units
%
%   unit(UnitCode, UnitName, Level, CreditPoints)
% -----------------------------------------------------------------------------------

unit('ACCG100', 'Accounting IA', 100, 3).
unit('ACCG106', 'Accounting Information Decision-Making', 100, 3).
unit('ACCG250', 'Accounting Systems Design and Development', 200, 3).
unit('ACCG355', 'Information Systems for Management', 300, 3).
unit('ACCG358', 'Information Systems Audit and Assurance', 300, 3).

unit('COMP111', 'Introduction to Video Games', 100, 3).
unit('COMP115', 'Introduction to Computer Science', 100, 3).
unit('COMP125', 'Fundamentals of Computer Science', 100, 3).
unit('COMP188', 'Enrichment Topics in Computing', 100, 3).
unit('COMP202', 'System Programming', 200, 3).
unit('COMP225', 'Algorithms and Data Structures', 200, 3).
unit('COMP226', 'Computer Architecture', 200, 3).
unit('COMP229', 'Object-Oriented Programming Practices', 200, 3).
unit('COMP247', 'Data Communications', 200, 3).
unit('COMP249', 'Web Technology', 200, 3).
unit('COMP255', 'Software Engineering', 200, 3).
unit('COMP260', 'Game Design', 200, 3).
unit('COMP329', 'Knowledge Systems', 300, 3).
unit('COMP330', 'Computer Graphics', 300, 3).
unit('COMP332', 'Programming Languages', 300, 3).
unit('COMP333', 'Algorithm Theory and Design', 300, 3).
unit('COMP343', 'Cryptography and Information Security', 300, 3).
unit('COMP344', 'E-Commerce Technology', 300, 3).
unit('COMP347', 'Computer Networks', 300, 3).
unit('COMP348', 'Document Processing and the Semantic Web', 300, 3).
unit('COMP350', 'Special Topics in Computing and Information Systems', 300, 3).
unit('COMP352', 'Videogames Project', 300, 3).
unit('COMP355', 'Information Technology Project', 300, 3).
unit('COMP356', 'Web Design and Development Project', 300, 3).
unit('COMP365', 'Systems Engineering Project', 300, 3).
unit('COMP388', 'Advanced Topics in Computing and Information Ssytems', 300, 3).

unit('DMTH137', 'Discrete Mathematics I', 100, 3).
unit('DMTH237', 'Discrete Mathematics II', 200, 3).

unit('ISYS104', 'Introduction to Business Information Systems', 100, 3).
unit('ISYS114', 'Introduction to Systems Design and Data Management', 100, 3).
unit('ISYS224', 'Database Systems', 200, 3).
unit('ISYS254', 'Applications Modelling and Development', 200, 3).
unit('ISYS301', 'Enterprise Systems Integration', 300, 3).
unit('ISYS302', 'Management of IT Systems and Projects', 300, 3).
unit('ISYS303', 'Advanced Applications Development', 300, 3).
unit('ISYS326', 'Advanced Databases and Enterprise Systems', 300, 3).
unit('ISYS355', 'Information Systems Project', 300, 3).
unit('ISYS358', 'Business Information Systems Project', 300, 3).
unit('ISYS360', 'Technology Management', 300, 3).


unit('MAS110',  'Introduction to Digital Media', 100, 3).
unit('MAS241',  'Interactive Web Design', 200, 3).
unit('MAS340',  'Advanced Interactivity', 300, 3).

%%% People units
unit('ABST100', 'Introducing Indigenous Australia', 100, 3).
unit('COGS202', 'Brain and Language', 200, 3).
unit('GEOS251', 'Minerals, Energy and the Environment', 200, 3).

%%% Planet Units
unit('ACCG260', 'Measuring Sustainability', 200, 3).
unit('ISYS100', 'IT & Society', 100, 3).
unit('STAT170', 'Introductory Statistics', 100, 3).


unit('STAT171', 'Statistical Data Analysis', 100, 3).


unit('BIOL114', 'Evolution and Biodiversity', 100, 3).
unit('BIOL115', 'The Thread of Life', 100, 3).
