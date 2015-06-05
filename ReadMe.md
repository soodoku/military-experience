### Military Experience of US Presidents and UK Prime Ministers

* [Military Experience of US Presidents](military-experience##military-experience-of-us-presidents)
* [Military Experience of UK Prime Ministers](military-experience##military-experience-of-uk-prime-ministers)
* [Graph of Military Experience of UK PMs](military-experience#graph-of-military-experience-of-uk-pms)

----

#### Military Experience of US Presidents

For 137 of the 219 years the country since its independence, US has had a military veteran as a president. 29 of its 43 presidents have been veterans. And the longest time America has gone without electing a veteran was the 32 year period starting with Taft in 1913 and ending with Roosevelt’s death in 1945. (Incredibly, during this time, the country took part in the two World Wars.) [Related article](http://gbytes.gsood.com/2008/04/23/military-experience-of-us-presidents-1789-%E2%80%93-2008/)

**Data on Military Experience of US Presidents** 

[From George Washington till Barack Obama](USPresMilExp.csv). Columns and their description:

| Colulmn Name   	  | Description   | 
| --------------------|---------------|
| ID      			  | Unique ID 	|
| President Number    | Number in sequence of unique presidents since founding     |
| Year 				  | are neat      |
| President 		  | Name of the president|
| Party 			  | Party of the president|
| Mil. Summary 		  | Key positions held in the military|
| Mil. Exp Dummy	  | Whether or not the president had any military experience|
| Start.Month 		  | Month the presidency started|
| Start.Year 		  | Year the presidency started|
| End.Month 		  | Month the presidency ended|
| End.Year 			  | Year the presidency ended|
| Years.Of.Rule 	  | Years of rule|
| Months.Of.Rule   	  | Months of rule|

There are three potential concerns about the numbers. Eight years of George W. Bush's 'service' in the National Guard have been excluded. Five years of Lincoln presidency have been included (Lincoln participated very briefly in the Black Hawk War of 1832). And Millard Fillmore’s tenure isn’t included as his experience in the military was after he had left his presidency. One can raise questions about the inclusion of some other presidents including Madison (whose service was brief again), however, as one can see, such tinkering is unlikely to impact the numbers much.

#### Military Experience of UK Prime Ministers

[From Robert Walpole till Gordon Brown](UKPMMilExp.csv). Columns and their description: 
ID (unique_id), Name (name of the prime minister), Start.Month (month the pmship started), Start.Year (year the pmship began), End.Month (year pm ship ended), End.Year (year pmship ended), Years.of.Rule (years of rule), Dys (total days of rule), PM at Age (at what age the person became pm), Title (any royal titles), Party (title of the pm), Mil. Exp. (had military experience or not), Yr. of Mil (years in  military), Education (education), Mil.Exp.Summary (summary of military experience), Notes (general notes)

#### Graph of Military Experience of UK PMs
* [R Code to generate the graph](mil_plots.R)
* [Graph](ukmil.pdf)

### License
Released under the [Creative Commons License](License.md).
