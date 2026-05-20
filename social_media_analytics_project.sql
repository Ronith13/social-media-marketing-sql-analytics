-- ============================================================
--  PROJECT: Social Media Marketing Analytics
--  Role Target: Data Analyst
--  Skills: CTEs, Window Functions, Aggregations, Subqueries,
--          Cohort Analysis, Funnel Analysis, Optimization
-- ============================================================


-- ============================================================
-- SECTION 1: SCHEMA DESIGN
-- ============================================================

CREATE TABLE users (
    user_id       SERIAL PRIMARY KEY,
    username      VARCHAR(100),
    signup_date   DATE,
    country       VARCHAR(50),
    age_group     VARCHAR(20),   -- '18-24', '25-34', '35-44', '45+'
    platform      VARCHAR(30)    -- 'Instagram', 'Twitter', 'TikTok', 'LinkedIn'
);

CREATE TABLE campaigns (
    campaign_id   SERIAL PRIMARY KEY,
    campaign_name VARCHAR(150),
    platform      VARCHAR(30),
    start_date    DATE,
    end_date      DATE,
    budget        NUMERIC(12,2),
    objective     VARCHAR(50)    -- 'awareness', 'engagement', 'conversion'
);

CREATE TABLE posts (
    post_id       SERIAL PRIMARY KEY,
    campaign_id   INT REFERENCES campaigns(campaign_id),
    posted_at     TIMESTAMP,
    content_type  VARCHAR(30),   -- 'video', 'image', 'carousel', 'story'
    caption_words INT,
    has_hashtags  BOOLEAN,
    has_cta       BOOLEAN        -- call to action
);

CREATE TABLE engagements (
    engagement_id SERIAL PRIMARY KEY,
    post_id       INT REFERENCES posts(post_id),
    user_id       INT REFERENCES users(user_id),
    engaged_at    TIMESTAMP,
    action_type   VARCHAR(20)    -- 'view', 'like', 'comment', 'share', 'save'
);

CREATE TABLE ad_spend (
    spend_id      SERIAL PRIMARY KEY,
    campaign_id   INT REFERENCES campaigns(campaign_id),
    spend_date    DATE,
    amount_spent  NUMERIC(10,2),
    impressions   INT,
    clicks        INT
);

CREATE TABLE conversions (
    conversion_id SERIAL PRIMARY KEY,
    campaign_id   INT REFERENCES campaigns(campaign_id),
    user_id       INT REFERENCES users(user_id),
    converted_at  TIMESTAMP,
    conversion_value NUMERIC(10,2)
);


-- ============================================================
-- SECTION 2: SAMPLE DATA
-- ============================================================

INSERT INTO users (username, signup_date, country, age_group, platform) VALUES
('alex_m',      '2022-01-15', 'India',   '18-24', 'Instagram'),
('priya_k',     '2022-03-22', 'India',   '25-34', 'LinkedIn'),
('sam_t',       '2021-11-05', 'USA',     '35-44', 'Twitter'),
('riya_s',      '2023-06-10', 'India',   '18-24', 'TikTok'),
('james_w',     '2022-08-19', 'UK',      '25-34', 'Instagram'),
('divya_r',     '2023-01-02', 'India',   '25-34', 'Instagram'),
('chen_l',      '2021-07-14', 'USA',     '45+',   'LinkedIn'),
('fatima_a',    '2023-09-30', 'UAE',     '18-24', 'TikTok'),
('michael_b',   '2022-05-25', 'USA',     '35-44', 'Twitter'),
('ananya_p',    '2023-11-11', 'India',   '18-24', 'Instagram');

INSERT INTO campaigns (campaign_name, platform, start_date, end_date, budget, objective) VALUES
('Summer Vibes 2024',       'Instagram', '2024-05-01', '2024-05-31', 50000, 'engagement'),
('LinkedIn Growth Push',    'LinkedIn',  '2024-04-01', '2024-04-30', 30000, 'awareness'),
('TikTok Viral Challenge',  'TikTok',    '2024-06-01', '2024-06-15', 20000, 'engagement'),
('Q2 Conversion Blitz',     'Instagram', '2024-04-15', '2024-05-15', 75000, 'conversion'),
('Brand Awareness Wave',    'Twitter',   '2024-03-01', '2024-03-31', 25000, 'awareness');

INSERT INTO posts (campaign_id, posted_at, content_type, caption_words, has_hashtags, has_cta) VALUES
(1, '2024-05-02 09:00:00', 'video',    45, TRUE,  TRUE),
(1, '2024-05-07 12:00:00', 'carousel', 60, TRUE,  FALSE),
(1, '2024-05-14 18:00:00', 'image',    30, FALSE, TRUE),
(2, '2024-04-03 10:00:00', 'image',    80, FALSE, TRUE),
(2, '2024-04-10 11:00:00', 'carousel', 100,TRUE,  TRUE),
(3, '2024-06-02 15:00:00', 'video',    20, TRUE,  TRUE),
(3, '2024-06-05 16:00:00', 'video',    25, TRUE,  FALSE),
(4, '2024-04-16 08:00:00', 'image',    50, TRUE,  TRUE),
(4, '2024-04-22 09:00:00', 'carousel', 70, TRUE,  TRUE),
(5, '2024-03-05 14:00:00', 'image',    40, FALSE, FALSE);

INSERT INTO engagements (post_id, user_id, engaged_at, action_type) VALUES
(1,1,'2024-05-02 09:30:00','view'),  (1,2,'2024-05-02 10:00:00','like'),
(1,3,'2024-05-02 10:15:00','share'), (1,4,'2024-05-02 11:00:00','comment'),
(2,1,'2024-05-07 12:30:00','like'),  (2,5,'2024-05-07 13:00:00','save'),
(3,6,'2024-05-14 18:30:00','view'),  (3,7,'2024-05-14 19:00:00','like'),
(4,2,'2024-04-03 10:30:00','like'),  (4,8,'2024-04-03 11:00:00','comment'),
(5,9,'2024-04-10 11:30:00','share'), (5,10,'2024-04-10 12:00:00','like'),
(6,4,'2024-06-02 15:30:00','view'),  (6,1,'2024-06-02 16:00:00','like'),
(7,3,'2024-06-05 16:30:00','share'), (8,5,'2024-04-16 08:30:00','view'),
(9,6,'2024-04-22 09:30:00','like'),  (9,7,'2024-04-22 10:00:00','comment'),
(10,8,'2024-03-05 14:30:00','view'), (10,2,'2024-03-05 15:00:00','like');

INSERT INTO ad_spend (campaign_id, spend_date, amount_spent, impressions, clicks) VALUES
(1,'2024-05-01',1800,95000,3200), (1,'2024-05-02',2100,110000,4100),
(1,'2024-05-03',1950,102000,3700),(2,'2024-04-01',1000,60000,1800),
(2,'2024-04-02',1200,72000,2100), (3,'2024-06-01',1500,130000,5500),
(3,'2024-06-02',1650,142000,6000),(4,'2024-04-15',2500,80000,4500),
(4,'2024-04-16',2700,85000,4800), (5,'2024-03-01',800,50000,1200);

INSERT INTO conversions (campaign_id, user_id, converted_at, conversion_value) VALUES
(1,1,'2024-05-03 10:00:00',1200), (1,4,'2024-05-04 11:00:00',850),
(4,2,'2024-04-17 09:00:00',2200), (4,5,'2024-04-18 14:00:00',1750),
(4,6,'2024-04-20 16:00:00',3100), (3,3,'2024-06-03 17:00:00',500),
(2,9,'2024-04-05 10:00:00',900);


-- ============================================================
-- SECTION 3: ADVANCED ANALYTICAL QUERIES
-- ============================================================

-- ---------------------------------------------------------------
-- QUERY 1: Campaign ROI Analysis
-- Business Question: Which campaigns delivered the best return
--                    on ad spend (ROAS)?
-- Skills: CTEs, aggregation, computed metrics
-- ---------------------------------------------------------------

WITH spend_summary AS (
    SELECT
        campaign_id,
        SUM(amount_spent)  AS total_spend,
        SUM(impressions)   AS total_impressions,
        SUM(clicks)        AS total_clicks
    FROM ad_spend
    GROUP BY campaign_id
),
conversion_summary AS (
    SELECT
        campaign_id,
        COUNT(*)                    AS total_conversions,
        SUM(conversion_value)       AS total_revenue
    FROM conversions
    GROUP BY campaign_id
)
SELECT
    c.campaign_name,
    c.platform,
    c.objective,
    c.budget,
    ROUND(ss.total_spend, 2)                                    AS actual_spend,
    ss.total_impressions,
    ss.total_clicks,
    ROUND(ss.total_clicks::NUMERIC / NULLIF(ss.total_impressions,0) * 100, 2) AS ctr_pct,
    COALESCE(cs.total_conversions, 0)                           AS conversions,
    COALESCE(ROUND(cs.total_revenue, 2), 0)                     AS revenue,
    COALESCE(ROUND(cs.total_revenue / NULLIF(ss.total_spend,0), 2), 0) AS roas,
    ROUND((c.budget - ss.total_spend) / c.budget * 100, 1)      AS budget_utilization_pct
FROM campaigns c
LEFT JOIN spend_summary ss     ON c.campaign_id = ss.campaign_id
LEFT JOIN conversion_summary cs ON c.campaign_id = cs.campaign_id
ORDER BY roas DESC;


-- ---------------------------------------------------------------
-- QUERY 2: Engagement Funnel by Campaign
-- Business Question: How do users move from view → like →
--                    comment → share → save per campaign?
-- Skills: Conditional aggregation, funnel logic, CTEs
-- ---------------------------------------------------------------

WITH funnel AS (
    SELECT
        c.campaign_id,
        c.campaign_name,
        e.action_type,
        COUNT(DISTINCT e.user_id) AS unique_users
    FROM engagements e
    JOIN posts p       ON e.post_id = p.post_id
    JOIN campaigns c   ON p.campaign_id = c.campaign_id
    GROUP BY c.campaign_id, c.campaign_name, e.action_type
),
pivoted AS (
    SELECT
        campaign_id,
        campaign_name,
        MAX(CASE WHEN action_type = 'view'    THEN unique_users ELSE 0 END) AS views,
        MAX(CASE WHEN action_type = 'like'    THEN unique_users ELSE 0 END) AS likes,
        MAX(CASE WHEN action_type = 'comment' THEN unique_users ELSE 0 END) AS comments,
        MAX(CASE WHEN action_type = 'share'   THEN unique_users ELSE 0 END) AS shares,
        MAX(CASE WHEN action_type = 'save'    THEN unique_users ELSE 0 END) AS saves
    FROM funnel
    GROUP BY campaign_id, campaign_name
)
SELECT
    campaign_name,
    views,
    likes,
    comments,
    shares,
    saves,
    ROUND(likes::NUMERIC    / NULLIF(views,0) * 100, 1) AS like_rate_pct,
    ROUND(comments::NUMERIC / NULLIF(views,0) * 100, 1) AS comment_rate_pct,
    ROUND(shares::NUMERIC   / NULLIF(views,0) * 100, 1) AS share_rate_pct
FROM pivoted
ORDER BY views DESC;


-- ---------------------------------------------------------------
-- QUERY 3: Content Type Performance with Window Functions
-- Business Question: Which content types drive the most
--                    engagement, and how do they rank within
--                    each platform?
-- Skills: Window functions (RANK, PERCENT_RANK, SUM OVER)
-- ---------------------------------------------------------------

WITH content_stats AS (
    SELECT
        c.platform,
        p.content_type,
        COUNT(DISTINCT p.post_id)      AS total_posts,
        COUNT(e.engagement_id)         AS total_engagements,
        COUNT(DISTINCT e.user_id)      AS unique_engagers,
        ROUND(COUNT(e.engagement_id)::NUMERIC / NULLIF(COUNT(DISTINCT p.post_id),0), 1) AS avg_eng_per_post
    FROM posts p
    JOIN campaigns c   ON p.campaign_id = c.campaign_id
    LEFT JOIN engagements e ON p.post_id = e.post_id
    GROUP BY c.platform, p.content_type
)
SELECT
    platform,
    content_type,
    total_posts,
    total_engagements,
    avg_eng_per_post,
    RANK() OVER (PARTITION BY platform ORDER BY avg_eng_per_post DESC)   AS rank_within_platform,
    ROUND(PERCENT_RANK() OVER (ORDER BY avg_eng_per_post) * 100, 1)      AS overall_percentile,
    ROUND(total_engagements::NUMERIC /
          SUM(total_engagements) OVER (PARTITION BY platform) * 100, 1)  AS pct_of_platform_eng
FROM content_stats
ORDER BY platform, rank_within_platform;


-- ---------------------------------------------------------------
-- QUERY 4: User Cohort Retention Analysis
-- Business Question: Of users who signed up each quarter,
--                    what % remained active (engaged) in
--                    subsequent months?
-- Skills: Cohorts, DATE_TRUNC, window functions, self-join
-- ---------------------------------------------------------------

WITH user_cohorts AS (
    SELECT
        user_id,
        DATE_TRUNC('quarter', signup_date)::DATE AS cohort_quarter
    FROM users
),
user_activity AS (
    SELECT
        e.user_id,
        DATE_TRUNC('month', e.engaged_at)::DATE AS activity_month
    FROM engagements e
    GROUP BY e.user_id, activity_month
),
cohort_activity AS (
    SELECT
        uc.cohort_quarter,
        ua.activity_month,
        COUNT(DISTINCT uc.user_id) AS active_users,
        EXTRACT(MONTH FROM AGE(ua.activity_month, uc.cohort_quarter))::INT AS months_since_signup
    FROM user_cohorts uc
    JOIN user_activity ua ON uc.user_id = ua.user_id
    GROUP BY uc.cohort_quarter, ua.activity_month
),
cohort_sizes AS (
    SELECT cohort_quarter, COUNT(*) AS cohort_size
    FROM user_cohorts
    GROUP BY cohort_quarter
)
SELECT
    ca.cohort_quarter,
    cs.cohort_size,
    ca.months_since_signup,
    ca.active_users,
    ROUND(ca.active_users::NUMERIC / cs.cohort_size * 100, 1) AS retention_pct
FROM cohort_activity ca
JOIN cohort_sizes cs ON ca.cohort_quarter = cs.cohort_quarter
ORDER BY ca.cohort_quarter, ca.months_since_signup;


-- ---------------------------------------------------------------
-- QUERY 5: Running Spend & Cumulative Conversion Tracking
-- Business Question: How did cumulative ad spend and revenue
--                    evolve over time per campaign?
-- Skills: Running totals with SUM() OVER (ORDER BY), CTEs
-- ---------------------------------------------------------------

WITH daily_metrics AS (
    SELECT
        s.campaign_id,
        s.spend_date,
        SUM(s.amount_spent) AS daily_spend,
        COUNT(cv.conversion_id)   AS daily_conversions,
        COALESCE(SUM(cv.conversion_value), 0) AS daily_revenue
    FROM ad_spend s
    LEFT JOIN conversions cv
        ON  s.campaign_id = cv.campaign_id
        AND cv.converted_at::DATE = s.spend_date
    GROUP BY s.campaign_id, s.spend_date
)
SELECT
    c.campaign_name,
    dm.spend_date,
    ROUND(dm.daily_spend, 2)                                              AS daily_spend,
    ROUND(SUM(dm.daily_spend) OVER (
        PARTITION BY dm.campaign_id ORDER BY dm.spend_date), 2)           AS cumulative_spend,
    dm.daily_conversions,
    SUM(dm.daily_conversions) OVER (
        PARTITION BY dm.campaign_id ORDER BY dm.spend_date)               AS cumulative_conversions,
    ROUND(dm.daily_revenue, 2)                                            AS daily_revenue,
    ROUND(SUM(dm.daily_revenue) OVER (
        PARTITION BY dm.campaign_id ORDER BY dm.spend_date), 2)           AS cumulative_revenue
FROM daily_metrics dm
JOIN campaigns c ON dm.campaign_id = c.campaign_id
ORDER BY c.campaign_name, dm.spend_date;


-- ---------------------------------------------------------------
-- QUERY 6: Top Performing Posts (with Z-Score Outlier Detection)
-- Business Question: Which posts are statistically high
--                    performers vs. the campaign average?
-- Skills: Window functions, stddev, z-score calculation
-- ---------------------------------------------------------------

WITH post_eng AS (
    SELECT
        p.post_id,
        p.campaign_id,
        p.content_type,
        p.has_hashtags,
        p.has_cta,
        COUNT(e.engagement_id) AS total_engagements
    FROM posts p
    LEFT JOIN engagements e ON p.post_id = e.post_id
    GROUP BY p.post_id, p.campaign_id, p.content_type, p.has_hashtags, p.has_cta
),
stats AS (
    SELECT
        campaign_id,
        AVG(total_engagements)    AS avg_eng,
        STDDEV(total_engagements) AS std_eng
    FROM post_eng
    GROUP BY campaign_id
)
SELECT
    c.campaign_name,
    pe.post_id,
    pe.content_type,
    pe.has_hashtags,
    pe.has_cta,
    pe.total_engagements,
    ROUND(s.avg_eng, 2)                                                   AS campaign_avg,
    ROUND((pe.total_engagements - s.avg_eng) / NULLIF(s.std_eng, 0), 2)  AS z_score,
    CASE
        WHEN (pe.total_engagements - s.avg_eng) / NULLIF(s.std_eng, 0) > 1  THEN 'High Performer'
        WHEN (pe.total_engagements - s.avg_eng) / NULLIF(s.std_eng, 0) < -1 THEN 'Under Performer'
        ELSE 'Average'
    END AS performance_label
FROM post_eng pe
JOIN stats s       ON pe.campaign_id = s.campaign_id
JOIN campaigns c   ON pe.campaign_id = c.campaign_id
ORDER BY z_score DESC;


-- ---------------------------------------------------------------
-- QUERY 7: Platform-wise Age Group Engagement Heatmap
-- Business Question: Which age groups are most active on
--                    each platform?
-- Skills: Conditional aggregation (pivot), grouping
-- ---------------------------------------------------------------

SELECT
    u.platform,
    COUNT(DISTINCT u.user_id)                               AS total_users,
    COUNT(DISTINCT e.engagement_id)                         AS total_engagements,
    SUM(CASE WHEN u.age_group = '18-24' THEN 1 ELSE 0 END) AS eng_18_24,
    SUM(CASE WHEN u.age_group = '25-34' THEN 1 ELSE 0 END) AS eng_25_34,
    SUM(CASE WHEN u.age_group = '35-44' THEN 1 ELSE 0 END) AS eng_35_44,
    SUM(CASE WHEN u.age_group = '45+'   THEN 1 ELSE 0 END) AS eng_45_plus,
    ROUND(SUM(CASE WHEN u.age_group = '18-24' THEN 1 ELSE 0 END)::NUMERIC /
          NULLIF(COUNT(e.engagement_id),0) * 100, 1)        AS pct_18_24,
    ROUND(SUM(CASE WHEN u.age_group = '25-34' THEN 1 ELSE 0 END)::NUMERIC /
          NULLIF(COUNT(e.engagement_id),0) * 100, 1)        AS pct_25_34
FROM users u
LEFT JOIN engagements e ON u.user_id = e.user_id
GROUP BY u.platform
ORDER BY total_engagements DESC;


-- ---------------------------------------------------------------
-- QUERY 8: Customer Lifetime Value (LTV) Segmentation
-- Business Question: Segment users by total conversion value
--                    and identify high-value customer profiles.
-- Skills: NTILE, window functions, subquery, CASE
-- ---------------------------------------------------------------

WITH user_ltv AS (
    SELECT
        u.user_id,
        u.username,
        u.age_group,
        u.country,
        u.platform,
        COUNT(cv.conversion_id)          AS total_conversions,
        COALESCE(SUM(cv.conversion_value), 0) AS lifetime_value
    FROM users u
    LEFT JOIN conversions cv ON u.user_id = cv.user_id
    GROUP BY u.user_id, u.username, u.age_group, u.country, u.platform
),
ltv_with_tile AS (
    SELECT
        *,
        NTILE(4) OVER (ORDER BY lifetime_value DESC) AS ltv_quartile
    FROM user_ltv
)
SELECT
    user_id,
    username,
    age_group,
    country,
    platform,
    total_conversions,
    ROUND(lifetime_value, 2)    AS lifetime_value,
    ltv_quartile,
    CASE ltv_quartile
        WHEN 1 THEN 'Champions'
        WHEN 2 THEN 'Loyal'
        WHEN 3 THEN 'At Risk'
        WHEN 4 THEN 'Inactive'
    END AS customer_segment,
    ROUND(lifetime_value / NULLIF(SUM(lifetime_value) OVER (), 0) * 100, 2) AS pct_of_total_revenue
FROM ltv_with_tile
ORDER BY lifetime_value DESC;


-- ---------------------------------------------------------------
-- QUERY 9: Week-over-Week Engagement Growth (LAG Analysis)
-- Business Question: Is engagement growing or declining
--                    week over week per campaign?
-- Skills: DATE_TRUNC, LAG(), growth rate calculation
-- ---------------------------------------------------------------

WITH weekly_eng AS (
    SELECT
        c.campaign_id,
        c.campaign_name,
        DATE_TRUNC('week', e.engaged_at)::DATE  AS week_start,
        COUNT(e.engagement_id)                  AS weekly_engagements
    FROM engagements e
    JOIN posts p      ON e.post_id = p.post_id
    JOIN campaigns c  ON p.campaign_id = c.campaign_id
    GROUP BY c.campaign_id, c.campaign_name, week_start
)
SELECT
    campaign_name,
    week_start,
    weekly_engagements,
    LAG(weekly_engagements) OVER (
        PARTITION BY campaign_id ORDER BY week_start)   AS prev_week_engagements,
    weekly_engagements - LAG(weekly_engagements) OVER (
        PARTITION BY campaign_id ORDER BY week_start)   AS absolute_change,
    ROUND(
        (weekly_engagements - LAG(weekly_engagements) OVER (
            PARTITION BY campaign_id ORDER BY week_start)
        )::NUMERIC /
        NULLIF(LAG(weekly_engagements) OVER (
            PARTITION BY campaign_id ORDER BY week_start), 0) * 100
    , 1)                                                AS wow_growth_pct
FROM weekly_eng
ORDER BY campaign_name, week_start;


-- ---------------------------------------------------------------
-- QUERY 10: Budget Efficiency Score (Composite KPI)
-- Business Question: Rank all campaigns by a composite
--                    efficiency score combining CTR, ROAS,
--                    and engagement rate.
-- Skills: Multi-CTE pipeline, RANK(), composite scoring
-- ---------------------------------------------------------------

WITH spend AS (
    SELECT campaign_id,
           SUM(amount_spent) AS spend,
           SUM(impressions)  AS impressions,
           SUM(clicks)       AS clicks
    FROM ad_spend GROUP BY campaign_id
),
eng AS (
    SELECT p.campaign_id, COUNT(e.engagement_id) AS engagements
    FROM posts p
    LEFT JOIN engagements e ON p.post_id = e.post_id
    GROUP BY p.campaign_id
),
conv AS (
    SELECT campaign_id,
           SUM(conversion_value) AS revenue
    FROM conversions GROUP BY campaign_id
),
metrics AS (
    SELECT
        c.campaign_id,
        c.campaign_name,
        c.platform,
        c.objective,
        ROUND(s.clicks::NUMERIC / NULLIF(s.impressions,0) * 100, 3)  AS ctr,
        ROUND(COALESCE(cv.revenue,0) / NULLIF(s.spend,0), 2)         AS roas,
        ROUND(e.engagements::NUMERIC / NULLIF(s.impressions,0) * 100, 3) AS eng_rate
    FROM campaigns c
    JOIN spend s   ON c.campaign_id = s.campaign_id
    JOIN eng e     ON c.campaign_id = e.campaign_id
    LEFT JOIN conv cv ON c.campaign_id = cv.campaign_id
),
normalized AS (
    SELECT *,
        ROUND((ctr     - MIN(ctr)     OVER()) / NULLIF(MAX(ctr)     OVER() - MIN(ctr)     OVER(),0), 4) AS ctr_score,
        ROUND((roas    - MIN(roas)    OVER()) / NULLIF(MAX(roas)    OVER() - MIN(roas)    OVER(),0), 4) AS roas_score,
        ROUND((eng_rate- MIN(eng_rate)OVER()) / NULLIF(MAX(eng_rate)OVER() - MIN(eng_rate)OVER(),0), 4) AS eng_score
    FROM metrics
)
SELECT
    campaign_name,
    platform,
    objective,
    ctr,
    roas,
    eng_rate,
    ROUND((ctr_score * 0.30 + roas_score * 0.50 + eng_score * 0.20), 4) AS composite_score,
    RANK() OVER (ORDER BY (ctr_score * 0.30 + roas_score * 0.50 + eng_score * 0.20) DESC) AS efficiency_rank
FROM normalized
ORDER BY efficiency_rank;
