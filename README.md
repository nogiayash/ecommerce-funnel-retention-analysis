# Cosmetic E-commerce Performance Dashboard
### Funnel, Retention & Customer Segmentation Insights

---

## Overview

This project presents a comprehensive analytics dashboard built for a cosmetic e-commerce platform. It provides actionable insights across three key areas: **sales funnel performance**, **customer retention**, and **user segmentation**, enabling data-driven decision-making for marketing and product teams.

---

## Key Metrics (Summary)

| Metric | Value |
|---|---|
| Total Users | 390K |
| Total Revenue | $1.21M |
| Product Views | 2M |
| Total Purchases | 242K |
| Conversion Rate (CVR) | 12% |

---

## Dashboard Screenshots

### 1. Summary Dashboard — Funnel, Segmentation & Conversion

<img width="1311" height="729" alt="summary_dashboard" src="https://github.com/user-attachments/assets/54d36ac7-3863-4dcd-9fad-d1852b8ced4d" />


This dashboard provides a high-level snapshot of the business performance:

- **Funnel**: Tracks user journey from Product Views (1.95M) → Add to Cart (1.15M) → Purchases (0.24M), with an overall funnel completion rate of 12.4%.
- **Revenue and Target**: Compares actual revenue contributions across customer segments — Power Users, Buyers, and Shoppers.
- **Customer Segmentation (Donut Chart)**: Breaks down the user base:
  - 🔴 Browser — **77.03%** (largest segment, low conversion opportunity)
  - 🟡 Shopper — **16.37%**
  - 🟢 Power User — **4.38%** (highest revenue contributors)
  - 🔵 Buyer — small share
- **User Base vs Revenue Contribution by Segment**: Bubble chart showing that Power Users, despite low count, drive the majority of revenue.
- **Views vs Purchases by Product Conversion**: Scatter plot identifying high-view / low-purchase outliers.
- **Top 5 Products by Conversion Rate**: Products `5894916`, `5670722`, `5685888`, `5866151`, and `5899513` lead with conversion rates between 6–8%.

---

### 2. Retention Dashboard — Cohort Heatmap & Decay Curve

<img width="1305" height="720" alt="retention_dashboard" src="https://github.com/user-attachments/assets/795889a9-ee21-4bd0-a5e2-d16b86916bba" />


This dashboard focuses on user retention behaviour over time:

- **Cohort Retention Heatmap (Feb 2020)**: Day-by-day retention rates for each daily cohort over 9 days. Day 1 retention ranges from **6.0% to 12.0%**, declining steadily across days — typical e-commerce drop-off pattern.
- **User Retention Decay Curve**: Shows the average retention curve dropping sharply from ~7% on Day 1 to ~2% by Day 5, then stabilising — indicating a loyal returning user base forms quickly.

#### Key Insights (from dashboard annotations):
> *"77% users are Browsers → low conversion opportunity"*

> *"High drop from Cart to Purchase → checkout friction"*

> *"Power Users contribute majority of revenue"*

---

### 3. Sample Raw Data

<img width="923" height="206" alt="sample_data" src="https://github.com/user-attachments/assets/1c9a0f3c-c98d-4284-9e8b-00d1bbcd0876" />


The underlying dataset contains event-level tracking data with the following fields:

| Column | Description |
|---|---|
| `event_time` | Timestamp of the event (UTC) |
| `event_type` | Type of event — `view`, `cart`, `purchase` |
| `product_id` | Unique product identifier |
| `category_code` | Product category |
| `brand` | Product brand (e.g., `ingarden`, `roubloff`, `bpw.style`, `dewal`) |
| `price` | Product price at time of event |
| `user_id` | Unique user identifier |
| `user_session` | Session ID for grouping user activity |

**Sample period:** February 2020 | **Event types captured:** `view`, `cart`,`purchase`

---

## Recommendations

Based on dashboard insights:

1. **Reduce Cart-to-Purchase Drop-off** — Streamline checkout; consider one-click purchasing or saved payment methods.
2. **Convert Browsers to Shoppers** — 77% of users never buy. Target with retargeting ads, personalised recommendations, and limited-time offers.
3. **Retain Power Users** — Loyalty programmes or early-access perks for the 4.38% Power Users who drive the most revenue.
4. **Optimise Top-Converting Products** — Promote products `5894916` and `5670722` more prominently as they show the highest CVR.
5. **Improve Day-1 Retention** — Onboarding emails or push notifications within the first 24 hours could help arrest the steep decay curve.

---

## Tech Stack

- **Data Source:** E-commerce event log (user sessions, product views, cart adds, purchases)
- **Visualisation Tool:** Power BI
- **Data Engineering:** SQL
- **Data Period:** February 2020

---

*Dashboard created for Cosmetic E-commerce Performance Analysis — Funnel, Retention & Customer Segmentation Insights.*
