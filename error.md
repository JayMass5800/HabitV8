 Concise Bug Report Title & Description
This is suitable for a Bug Title and a Brief Description field.

Title
Calendar/Timeline: RRule Refactor causes incorrect day offsets (e.g., displaying day before) for recurring habits.

Description
Following the recent RRule refactor, habits utilizing the new recurring rule logic are incorrectly plotted on both the Calendar and Timeline screens. The habit display seems to be consistently off by one day (showing on the day before) the correct recurrence date, and sometimes affecting the day after as well.

Example:

A monthly habit set to occur on the 5th, 10th, and 15th is displaying on the 4th, 5th, 9th, 10th, 14th, and 15th.

This suggests a potential issue in the filtering, date calculation, or saving/persistence logic for the new RRule implementation. Given the nature of the bug, it is highly likely that all RRule frequency types are affected and requires a focused, surgical fix to prevent cascading breakages.

Option 2: Detailed Developer Investigation Prompt
This is a comprehensive request suitable for a full issue ticket or a detailed message to a core team member.

Bug: RRule Refactor Causing Off-by-One Day Slot Errors on Calendar/Timeline
1. Priority
High (Core functionality/data integrity is affected)

2. Context
This bug has appeared following the recent RRule refactoring (specifically the introduction/update of the new RRule type/implementation).

3. Observed Behavior
Habit occurrences are being displayed in the wrong day slots on both the Calendar and Timeline screens. The core error appears to be an off-by-one-day calculation, often resulting in the habit being displayed on the day before its scheduled occurrence, but sometimes affecting the subsequent day as well.

4. Reproduction Example
Setting	Expected Display Dates	Actual Display Dates
Monthly Habit set for the 5th, 10th, 15th, etc.	5th, 10th, 15th	4th, 5th, 9th, 10th, 14th, 15th

Export to Sheets
5. Scope & Suspected Cause
Affected Components: Calendar Screen, Timeline Screen, and any service consuming the new RRule output.

Suspected Issue: The problem is likely rooted in a miscalculation or misinterpretation of time/date boundaries when generating or filtering recurrence dates. This could be due to:

Timezone handling errors (e.g., UTC vs. local time).

An indexing error (±1 day offset) in the RRule generation logic.

A flaw in the persistence/saving of the recurrence start date.

Wider Impact: It's hypothesized that all frequency types (DAILY, WEEKLY, MONTHLY, etc.) using the new RRule logic are affected and need to be verified.

6. Action Requested
Investigate the new RRule generation, filtering, and persistence logic.

Identify and surgically fix the source of the day offset error (e.g., the timezone or off-by-one calculation).

Thoroughly test against all RRule frequency types to ensure the fix is complete.

Critical Requirement: The fix must not introduce breaking changes to existing habit data or legacy recurrence logic.