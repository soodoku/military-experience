# Data dictionary

Both maintained CSVs have the same schema. They are UTF-8, with blank cells for
missing values. `data/snapshot.csv` records the roster review date (`as_of`) as
an ISO date. The checked-in snapshot is deliberately independent of the computer's
clock: rebuilding the charts does not silently claim a new data review.

| Column | Type | Meaning |
| --- | --- | --- |
| `term_id` | integer | Chronological continuous period in office, unique within country. For the US this is the conventional presidency number. |
| `leader_id` | integer | The person's first `term_id`; repeated on a return to office. Not a dense person count. |
| `name` | text | Consistent name for the person across periods. UK historical names follow GOV.UK, including some titles. |
| `party` | text | Broad party affiliation; historical labels are largely inherited, not a time-varying affiliation history. |
| `start_year` | integer | Calendar year this period in office began. |
| `end_year` | integer or missing | Calendar year it ended; missing only for the incumbent at `as_of`. |
| `military_experience` | integer or missing | `1`: military service before first taking office; `0`: negative classification; missing: unknown. |
| `military_summary` | text or missing | Short service description or explanation. An administrative post does not establish military service. Historical descriptions may be inherited. |
| `military_evidence` | text | `sourced`: classification supported by the cited source; `legacy`: inherited classification not independently verified; `unknown`: unresolved. |
| `military_source` | URL or missing | Classification source, or the original file for an inherited blank. This is separate from the source for officeholding. |
| `tenure_source` | URL | Source for the name and tenure years. This does not imply that the source verifies military service or every party label. |
| `legacy_id` | integer or missing | Row ID in the corresponding original CSV. US repeated-election rows are consolidated into the first row for each presidency. New leaders have no legacy ID. |

Regular forces, militia, reserves, the Territorial Army and National Guard count.
Combat is not required. Civilian defense administration, school cadet training,
and service beginning only after office do not count. The classification is not
an assessment of statutory veteran eligibility.

Use `leader_id` to count people. Use `term_id` to study arrivals in office. Do not
subtract the tenure years to estimate precise durations: a same-year premiership
is not a zero-duration premiership. The 1834 Wellington caretaker period is retained,
consistent with his GOV.UK biography. The roster begins with Walpole and spans
Great Britain and the later United Kingdom; it is not a list of English medieval
chief ministers.

## Historical fields

`data-raw/USPresMilExp.csv` and `data-raw/UKPMMilExp.csv` preserve the original source files. Their mixed-case headers are intentionally
preserved. They are archival inputs, not the maintained data interface.

The maintained tables omit the original month fields, age, education, title,
free-form personal notes, military years and tenure-duration columns. The original
months contain errors, `Dys` is not consistently total days, and some duration
values combine multiple nonconsecutive periods. Maintained tenure fields have year
resolution; these tables must not be used for person-day totals.
All original information remains in the archived CSVs and Git history.

## Update procedure

1. Check the current [US presidency](https://www.whitehouse.gov/administration/donald-j-trump/)
   and [UK prime minister](https://www.gov.uk/government/ministers/prime-minister),
   then compare the rosters with the linked official historical lists.
2. Close the outgoing incumbent's `end_year` and append the new period. Reuse
   `leader_id` for a returning person; consecutive re-election does not create
   a new period. Keep a single blank end year per country.
3. Research military service separately. Record evidence in `military_source`
   and `military_summary`. A biography that does not mention service cannot by
   itself justify a zero. Use unknown when evidence is insufficient.
4. Change `as_of` only after checking both rosters. Update the relevant source
   citations and roster regression expectations in the tests.
5. Run `make check`; inspect the charts. Commit the CSVs,
   generated README and charts together. Tests validate data and calculations;
   they cannot certify the historical truth of a new classification.

No live scraper runs during builds or CI. Updating is an explicit, sourced review,
so a changed webpage cannot silently change a published classification.
