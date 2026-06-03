Overview
---
This is a self-made project using public e-commerce data.

The queries have been saved under screenshots and are segmented in the .sql file into their own respective section and their responsibilities.

Google BigQuery/SQL was used to determine answers to solve several business intelligence/marketing questions that would take place in a real-life scenario.

Aim
-----
The aim of this project was to strengthen my SQL proficiency using Google BigQuery while applying analytical techniques commonly used in industry. 
By analysing user behaviour across a sales funnel, the project measures conversion rates, revenue generation, and customer progression through each stage of the journey. 
The analysis identifies points of user drop-off, evaluates purchasing behaviour, and demonstrates how data can be used to support business decisions, optimise conversion performance, and drive revenue growth.


Business Questions
----
1. What different event types are there?
2. What are the conversion rates (%) from transitioning through each event type?
3. What type of marketing traffic sources are there and how many users are there for the different event types?
4. What are the conversion rates (%) within these different traffic sources?
5. How long does it take for users to complete the 'purchasing' lifecycle and how long is it per step?
6. How much total revenue is generated?
7. How much revenue is generated per customer?
8. What is the highest selling product?

Schema overview for table: user_events
-------------------------------------------------------------------------------
| Column | Type | Description |
|----------|----------|----------|
| event_id | INTEGER | Unique event identifier |
| user_id | INTEGER | Unique user identifier |
| event_type | STRING | User action performed |
| event_date | TIMESTAMP | Time of event |
| product_id | INTEGER | Unique product identifier |
| amount | FLOAT | Purchase value |
| traffic_source | STRING | Types of marketing channels |
-------------------------------------------------------------------------------

Key Findings
---
The overall conversion rate from website visit to purchase was 16.5% (826 purchases from 5,000 visitors).
The largest drop-off occurred between the page view and add to cart stages, where only 31.1% of users progressed.
Users who reached the payment stage showed a high intent to purchase, with 91.9% completing their transaction.
Funnel analysis highlighted the early stages of the customer journey as the greatest opportunity for optimisation.
Revenue analysis identified the total value generated from completed purchases and can be used to assess marketing channel effectiveness.
