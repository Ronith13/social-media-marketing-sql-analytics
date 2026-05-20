# 📊 Social Media Marketing Analytics — SQL Portfolio Project

## Project Overview
An end-to-end SQL analytics project simulating a real-world **Marketing Data Analyst** workflow.
Analyzes campaign performance, user engagement, content effectiveness, and ROI across social media platforms.

---

## 🗃️ Database Schema (6 Tables)

| Table | Description |
|---|---|
| `users` | Platform users with demographics |
| `campaigns` | Ad campaigns with budget & objective |
| `posts` | Individual content pieces per campaign |
| `engagements` | User interactions (view/like/comment/share/save) |
| `ad_spend` | Daily spend, impressions, and clicks |
| `conversions` | Revenue events linked to users & campaigns |

---

## 🔍 10 Analytical Queries & Business Questions

| # | Query | Key Skill |
|---|---|---|
| 1 | **Campaign ROI Analysis** — Which campaigns had the best ROAS? | Multi-CTE, computed metrics |
| 2 | **Engagement Funnel** — How do users move through view→like→share? | Conditional aggregation, pivot |
| 3 | **Content Type Performance** — Which formats drive most engagement per platform? | `RANK()`, `PERCENT_RANK()`, `SUM() OVER()` |
| 4 | **Cohort Retention Analysis** — What % of signup cohorts stayed active? | Cohort logic, `DATE_TRUNC`, self-join |
| 5 | **Running Spend & Revenue** — How did cumulative spend vs revenue track? | Running totals, `SUM() OVER (ORDER BY)` |
| 6 | **Outlier Post Detection** — Which posts over/under-perform statistically? | Z-score, `STDDEV()`, window functions |
| 7 | **Age Group Heatmap** — Which demographics engage on which platform? | Pivot, conditional aggregation |
| 8 | **Customer LTV Segmentation** — Who are Champions vs At-Risk users? | `NTILE()`, revenue share, segmentation |
| 9 | **Week-over-Week Growth** — Is engagement growing or declining? | `LAG()`, growth rate calculation |
| 10 | **Composite Efficiency Score** — Which campaign is truly the most efficient? | Min-max normalization, weighted scoring, `RANK()` |

---

## 💡 Advanced SQL Concepts Demonstrated

- ✅ **CTEs** (multi-step, chained)
- ✅ **Window Functions**: `RANK`, `PERCENT_RANK`, `NTILE`, `LAG`, `SUM OVER`, `STDDEV`
- ✅ **Cohort Analysis** with `DATE_TRUNC` and `AGE()`
- ✅ **Funnel Analysis** with conditional aggregation
- ✅ **Statistical Outlier Detection** (Z-score)
- ✅ **Min-Max Normalization** for composite KPIs
- ✅ **NULL-safe division** with `NULLIF()`
- ✅ **COALESCE** for default value handling

---

## 🛠️ How to Run

1. Install **PostgreSQL** (v13+) or use a free cloud DB like [Supabase](https://supabase.com) / [Neon](https://neon.tech)
2. Run schema creation first (Section 1)
3. Load sample data (Section 2)
4. Run any query from Section 3 independently — each is self-contained

---

## 🎯 Resume Bullet Points (copy-paste ready)

- Designed a 6-table normalized PostgreSQL schema for social media marketing analytics
- Built 10 advanced SQL queries using CTEs, window functions (LAG, RANK, NTILE), and cohort analysis to uncover campaign ROI and user engagement trends
- Developed a composite efficiency scoring model using min-max normalization across CTR, ROAS, and engagement rate to rank campaigns objectively
- Implemented Z-score based outlier detection to identify statistically high-performing content
- Conducted user LTV segmentation (Champions / Loyal / At-Risk) using NTILE() quartile analysis

---

## 📁 Suggested GitHub README Tags
`SQL` `PostgreSQL` `Data Analysis` `Marketing Analytics` `Window Functions` `Cohort Analysis` `Portfolio Project`
