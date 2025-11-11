# Store-Level Demand Forecasting & Commercial Performance Optimisation

## Project Overview
This project aims to improve demand forecasting and commercial performance for a retail chain operating five stores with 20 key products across multiple regions. The main goals are:

- Increase store-level demand forecast accuracy.
- Quantify the impact of pricing, promotions, and competitor actions.
- Provide actionable insights to optimize inventory, pricing, and promotional strategies.

---

## Business Context
The retail chain faced three main challenges:

1. **Inaccurate demand forecasts** → leading to stockouts or overstocking.  
2. **Unoptimized discount and promotion strategies** → reducing margins or failing to drive sales.  
3. **Inconsistent profitability** across stores and regions.

**Central Question:**  
*“How can improved store-level demand forecasting enable smarter inventory planning, optimized pricing and promotions, and stronger profitability?”*

---

## Tools & Approach

| Stage | Tool | Purpose | Business Justification |
|-------|------|--------|----------------------|
| Data Modelling & Forecasting | Python (ARIMA, SARIMA, ARIMAX) | Forecast store-level units sold | ARIMAX incorporates trends + external factors (price, discount, promotion, competitor pricing), achieving lowest MAPE → actionable for commercial planning |
| Scenario Analysis | Python (What-if simulations) | Simulate pricing, promotion, and competitor changes | Quantifies store sensitivity and tests elasticity for strategic levers |
| Performance Analysis | MySQL | Evaluate revenue, profitability, and operational metrics | Advanced SQL (CTEs, window functions, conditional logic) surfaces actionable business insights |
| Reporting & Visualization | Power BI (DAX, KPI cards, gauges) | Create executive-ready dashboards | Provides clear decision-ready KPIs: Forecast Accuracy, Revenue Growth, Promotion ROI, Relative Performance % |

<img width="900" height="600" alt="python" src="https://github.com/user-attachments/assets/c938e8e2-0bcd-49df-b3cf-0149e587ef2d" />

---

## Key Analyses & Insights

### Forecasting
- **Model Comparison:** ARIMA, SARIMA, ARIMAX → ARIMAX achieved lowest MAPE.  
- **Results:** Forecast error reduced by 20% vs ARIMA, 30% vs SARIMA.  
- **Impact:** More reliable inventory planning, fewer stockouts, better working capital allocation.

### Scenario Analysis (What-If)
| Lever | Finding | Business Implication |
|-------|--------|--------------------|
| Price (-5%) | Store 3: +3% units sold; Store 1: -14% | Tailor pricing per store; maximize revenue without margin erosion |
| Promotions (removed) | Store 1: +13%; Store 2: -19% | Optimize promotional strategies, target high-impact stores/products |
| Discount (+10%) | Store 5: +1%; Store 2: -8% | Avoid blanket discounts; focus on ROI-positive initiatives |
| Competitor Price (-5%) | Store 1: +5%; Store 3: -12% | Implement defensive pricing where exposure is high |

### SQL Performance Insights
- **Revenue & Sales:** Store 5 (+5.55% MoM), Store 3 (+5.39%), slower growth in Store 4 → inform promotions and product strategy.  
- **Top Products:** Product 20 dominates 3 regions; Products 13–16 strong in 2 regions → guide procurement and national marketing.  
- **Promotion ROI:** Store 2 +1.2%, Store 1 −4.5%, Store 5 −1.3% → selective, data-driven promotions recommended.  
- **Inventory Efficiency:** YoY turnover improved; forecast accuracy 96%, but only ~50% inventory utilized → optimize reorder points.  
- **Profitability & Market Positioning:** Margins vs competitors 0.01–0.07 → margin growth requires cost or bundling strategies; top 4 products ~80% revenue → diversify portfolio to reduce concentration risk.

<img width="900" height="600" alt="sql" src="https://github.com/user-attachments/assets/b505ab0d-faa7-44c7-a8c8-83fd3b16f583" />


---

## Power BI Dashboard Highlights
- **Forecast Accuracy (MAPE)** → guides inventory planning.  
- **Promotion ROI (%)** → informs marketing spend.  
- **Revenue by Region/Season** → identifies profitable markets and optimal timing.  
- **Top 5 Products / Relative Performance %** → guides marketing, shelf-space allocation, and procurement.  

**DAX Patterns Used:** `AVERAGEX`, `SUMX`, `IF FILTER`, `VAR`, `DIVIDE`, `ISBLANK` for safe, efficient, and readable calculations.

<img width="900" height="600" alt="image" src="https://github.com/user-attachments/assets/f8c305ef-efaa-4964-a726-fce7c38ef392" />



---

## Executive Summary
- **Revenue Growth:** Stores 3 & 5 lead growth; Product 20 dominates cross-region; targeted promotions outperform blanket discounts.  
- **Operational Efficiency:** Turnover and forecast accuracy improved; overstock remains → optimize reorder points and release working capital.  
- **Profitability & Market Positioning:** Competitive pricing parity limits margin; top 4 products dominate revenue → diversify to stabilize long-term growth.  

**Business Impact:**  
- Improved forecasting → reduced stockouts and holding costs → frees working capital.  
- Optimized pricing & promotions → margin protection & incremental revenue.  
- SKU focus → portfolio optimization reduces concentration risk.

---

## Conclusion
This project demonstrates a **complete end-to-end commercial analytics workflow**: data extraction, advanced forecasting, scenario analysis, operational efficiency insights, and executive-level visualization. It is ready for deployment in decision-making contexts and supports strategic growth and profitability optimization.
