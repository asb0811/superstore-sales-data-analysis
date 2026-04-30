USE superstore;

-- Q1 Layer 1: category overview
SELECT 
    category,
    COUNT(*) AS line_items,
    COUNT(DISTINCT order_id) AS distinct_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(sales) * 100 / SUM(SUM(sales)) OVER (), 1) AS revenue_share
FROM orders
GROUP BY category
ORDER BY total_sales DESC;


-- Q1 Layer 2: sub-category breakdown
SELECT 
    category,
    sub_category,
    COUNT(*) AS line_items,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(sales) * 100 / SUM(SUM(sales)) OVER (), 1) AS revenue_share
FROM orders
GROUP BY category, sub_category
ORDER BY total_sales DESC;


-- Q1 Layer 3: pareto cut with rank and cumulative share
SELECT 
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(sales) * 100 / SUM(SUM(sales)) OVER (), 1) AS revenue_share,
    ROUND(SUM(SUM(sales)) OVER (ORDER BY SUM(sales) DESC) * 100 / SUM(SUM(sales)) OVER (), 1) AS cumulative_share,
    RANK() OVER (ORDER BY SUM(sales) DESC) AS sales_rank
FROM orders
GROUP BY category, sub_category
ORDER BY total_sales DESC;