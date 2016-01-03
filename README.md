# StudentRegulations

Reliably you need swi-prolog installed to compile and run this program. 

What this program does is check if a list of pre-defined students in kb_transcripts.pl satisfy set requirements in kb_degrees.pl. The program regulations.pl checks if these requirements are fulfilled and then lists for each student what they qualify for. The currently listed requirements are below:

```
In order to complete the degree of a Bachelor of Information Technology (BIT) in the Department of Computing, a student must
satsify the following general requirements:
  Minimum number of credit points for the degree 	72
  Minimum number of credit points at 200 level or above 	42
  Minimum number of credit points at 300 level or above 	18
  Completion of specified foundation unit 	9
  Completion of a Qualifying Major for the Bachelor of Information Technology 	
  Completion of a designated People unit 	
  Completion of a designated Planet unit 	
  Completion of a designated PACE unit
  
Students must complete one designated People unit and one designated Planet unit. Those units must be taken in two different
Faculties. Any unit which is part of the student's qualifying major will not satisfy the People unit requirement or Planet unit
requirement.
```

When you run the program  you only need to compile regulations.pl and entering the command 'check_transcripts().' will run the program with the students already define in kb_transcripts.pl and display the bare minimum required to state if a student has satisfied a requirement and what major they qualify for.

Running the command 'check_transcripts_ex().' will also display how many credit points the student needs to satisfy the requirements, what unit(s) they need to qualify for a major, and what people and planet units, etc they can complete. For simplicity sake it currently only performs this check for the very first major defined in kb_transcripts.pl, but it wouldn't be too much extra work to make it check for all or to find the major a given student is most likely to complete.
