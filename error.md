Prompt: Strategic Redesign of the "Insights" Page for a Premier Habit-Tracking App
Persona: Act as a Senior UX/UI Designer and Product Strategist. Your expertise lies in data visualization, user motivation, and creating intuitive, data-rich interfaces. You understand that raw data is useless without context and actionable insights.

Context: We are redesigning the "Insights" page for our habit-tracking application. The current page is a mix of basic stats, redundant information, and misplaced features. It lacks a cohesive narrative and fails to provide users with truly meaningful, actionable analysis of their performance. Our goal is to transform this page into a powerful, personalized command center for self-improvement, where users can understand the story behind their habits.

Core Mission: Overhaul the "Insights" page to deliver deep, personalized, and actionable analysis of all user habits and, conditionally, their integrated health data. The new design must be clean, motivating, and focused on revealing trends, correlations, and opportunities for growth.

Detailed Redesign Specifications:
1. Overarching Philosophy: From Data Points to Life Patterns

The new design should be guided by these principles:

Actionable: Every piece of data should suggest a next step or reveal a pattern the user can act upon. Instead of "You completed your run," it should be "You're 75% more likely to complete your evening habits on days you run in the morning."

Contextual: Compare performance over time (week-over-week, month-over-month), and correlate habits with health metrics.

Personalized: Use AI-driven text to generate insights that speak directly to the user's unique journey. The tone should be empowering and non-judgmental.

Visually Compelling: Use modern data visualization techniques to make complex data beautiful and easy to digest.

2. Page Structure & Component Breakdown (Top to Bottom):

[REMOVED] The Today's Health Summary card is to be removed. The page will now begin with a more powerful overview.

A. The "Big Four" Performance Cards:
This section replaces the four simple "chip cards." These should be visually distinct, full-width cards, each with a unique color gradient and icon, similar in style to the cards on our "Yearly Stats" page. They provide a high-level, at-a-glance summary.

Card 1: Overall Completion Rate (Color: Vibrant Green Gradient)

Metric: Show the percentage of all habits completed in the last 30 days. Example: $82\%$.

Micro-Trend: Display a small sparkline chart showing the trend over the last 4 weeks.

Comparative Insight: Add a line of text like: +5% vs. the previous 30 days.

Card 2: Current Streak (Color: Fiery Orange Gradient)

Metric: Display the longest active streak across all habits. Example: 18 Days.

Context: Specify the habit: (for 'Morning Meditation').

Comparative Insight: Add a line of text like: Your best streak ever is 25 days.

Card 3: Consistency Score (Color: Deep Blue Gradient)

Metric: A proprietary score (0−100) that measures how consistently the user performs their habits on their scheduled days, not just completion. This penalizes missing scheduled days more than a simple completion rate would.

Insight: A text label like Highly Consistent or Building Momentum.

Card 4: Most Powerful Day (Color: Royal Purple Gradient)

Metric: Identify the day of the week the user is most successful. Example: Wednesdays.

Insight: Add a line of text like: You complete 22% more habits on this day than your average.

B. Habit Performance Deep Dive:
This is the new core of the page. This section uses dynamic charts and text to analyze all habit data.

Trend Analysis:

Display a line chart showing Weekly Completion Rate (%) over the last 3 months.

Overlay a secondary metric like Total Habits Completed to show volume vs. consistency.

AI-Generated Insights: Below the charts, include a section with 2-3 bullet points of dynamic, text-based insights.

Example 1 (Identifying Patterns): "We've noticed a trend: Your completion rate for 'Read 10 Pages' drops by 40% on weekends. Consider scheduling it earlier in the day."

Example 2 (Positive Reinforcement): "You've successfully completed 'Drink Water' every single morning for the past 2 weeks. Amazing work!"

Example 3 (Identifying Strengths): "Your 'Evening Habits' category has a 95% completion rate, making it your most consistent time of day."

C. Conditional Health Hub: Correlating Effort with Wellness
This section is the most powerful addition and must be designed with clear conditional logic.

Default State (Permissions NOT Granted):

Display a visually appealing, locked-state card.

Headline: "Unlock Deeper Insights into Your Health."

Body Text: "Grant permission to Health Connect / HealthKit to see how your habits impact key metrics like sleep, heart rate, and activity levels. Discover the direct link between your efforts and your well-being."

Call-to-Action Button: "Connect to Health Data."

Active State (Permissions GRANTED):

The card transforms into a rich data hub.

Headline: "Your Health & Habit Connection."

Core Feature: Focus on correlation analysis between user-mapped habits (e.g., 'Go for a Run', 'Meditate', 'Sleep 8 Hours') and the corresponding HealthKit/Health Connect data.

Data Modules (Display 2-3 of the most relevant):

Module: Sleep & Habit Performance:

Visualization: An overlay chart showing Sleep Duration (from health data) and next-day Habit Completion Rate (%).

AI Insight: "On days following 7+ hours of sleep, your overall habit completion rate increases by an average of 18%."

Module: Activity & Energy Levels:

Visualization: A bar chart comparing completion rates for 'Energy' tagged habits (e.g., 'Focus Work,' 'Creative Project') on days with and without a completed 'Workout' habit.

AI Insight: "You're twice as likely to complete 'Focus Work' on days you log a workout of at least 30 minutes."

Module: Mindfulness & Heart Rate:

Visualization: Show a trend line of your Resting Heart Rate (RHR) over the last 30 days. Use annotations to mark the days a 'Meditation' or 'Journaling' habit was completed.

AI Insight: "Your average Resting Heart Rate is 3 bpm lower on days you complete your 'Morning Meditation' habit."

[REMOVED] The Gamification card at the very bottom of the page is to be removed entirely. Its content and functionality are already located in the dedicated 'Achievements' or 'Profile' section of the app.

Final Deliverable:
Provide a detailed text-based description of this new "Insights" page layout, including the exact copy for headlines, insight examples, and CTAs. Describe the interactivity and the logic for conditional displays. Your response should be a comprehensive blueprint that can be handed directly to a development team. Go above and beyond by suggesting subtle animations or micro-interactions that would enhance the user experience.