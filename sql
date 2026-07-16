
 -- View First Few Rows 

SELECT * FROM financial_fraud LIMIT 5;


-- Data Clean 
-- View All Columns 

DESCRIBE financial_fraud;


-- 1. Average Transaction Amount --

SELECT 
    ROUND(AVG(transaction_amount), 2) AS avg_transaction_amount
FROM financial_fraud;


-- 2. Transaction Count By Type:

SELECT 
    transaction_type,
    COUNT(*) AS total_transactions
FROM financial_fraud
GROUP BY transaction_type
ORDER BY total_transactions DESC;


-- 3. Total Transaction Amount By Type:

SELECT 
    transaction_type,
    ROUND(SUM(transaction_amount), 2) AS total_transaction_amount
FROM financial_fraud
GROUP BY transaction_type
ORDER BY total_transaction_amount DESC;


-- 4, Total Fraud Transactions:

SELECT 
    COUNT(*) AS total_fraud_transactions
FROM financial_fraud
WHERE is_fraud = 1;


-- 5. Fraud Transactions By Transaction Type:

SELECT 
    transaction_type,
    COUNT(*) AS total_fraud_transactions
FROM financial_fraud
WHERE is_fraud = 1
GROUP BY transaction_type
ORDER BY total_fraud_transactions DESC;


-- 6. Fraud Rate By Transaction Type:

SELECT 
    transaction_type,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(
        SUM(is_fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate
FROM financial_fraud
GROUP BY transaction_type
ORDER BY fraud_rate DESC;

-- 7. Fraud vs Non-Fraud Transaction Summary:

SELECT 
    is_fraud,
    COUNT(*) AS total_transactions,
    ROUND(SUM(transaction_amount), 2) AS total_transaction_amount,
    ROUND(AVG(transaction_amount), 2) AS avg_transaction_amount
FROM financial_fraud
GROUP BY is_fraud
ORDER BY is_fraud DESC;


-- 8. High-Value Fraud Transactions:

SELECT 
    sender_account,
    receiver_account,
    transaction_type,
    transaction_amount,
    is_fraud
FROM financial_fraud
WHERE is_fraud = 1
  AND transaction_amount > 1000000
ORDER BY transaction_amount DESC;


-- 9. Fraud Amount By Transaction Type:

SELECT 
    transaction_type,
    COUNT(*) AS total_fraud_transactions,
    ROUND(SUM(transaction_amount), 2) AS total_fraud_amount,
    ROUND(AVG(transaction_amount), 2) AS avg_fraud_amount
FROM financial_fraud
WHERE is_fraud = 1
GROUP BY transaction_type
ORDER BY total_fraud_amount DESC;




-- 10. Flagged Fraud vs Actual Fraud Comparison:

SELECT 
    is_fraud,
    is_flagged_fraud,
    COUNT(*) AS total_transactions
FROM financial_fraud
GROUP BY is_fraud, is_flagged_fraud
ORDER BY is_fraud DESC, is_flagged_fraud DESC;


-- 11. Top 10 Highest Fraud Transactions:

SELECT 
    sender_account,
    receiver_account,
    transaction_type,
    transaction_amount
FROM financial_fraud
WHERE is_fraud = 1
ORDER BY transaction_amount DESC
LIMIT 10;


-- 12. How Does Fraud Activity Change Across Different Transaction Steps?

SELECT 
    step,
    COUNT(*) AS total_fraud_transactions,
    ROUND(SUM(transaction_amount), 2) AS total_fraud_amount
FROM financial_fraud
WHERE is_fraud = 1
GROUP BY step
ORDER BY step;


-- 15. Which Transaction Types Have the Highest Fraud Risk?

WITH fraud_analysis AS (
    SELECT 
        transaction_type,
        COUNT(*) AS total_transactions,
        SUM(is_fraud) AS total_fraud_transactions
    FROM financial_fraud
    GROUP BY transaction_type
)

SELECT 
    transaction_type,
    total_transactions,
    total_fraud_transactions,
    ROUND(
        total_fraud_transactions * 100.0 / total_transactions,
        2
    ) AS fraud_rate
FROM fraud_analysis
ORDER BY fraud_rate DESC;

-- 16. Which Sender Accounts Are Involved In Multiple Fraudulent Transactions?

SELECT 
    sender_account,
    COUNT(*) AS fraud_transaction_count,
    ROUND(SUM(transaction_amount), 2) AS total_fraud_amount
FROM financial_fraud
WHERE is_fraud = 1
GROUP BY sender_account
HAVING COUNT(*) > 1
ORDER BY fraud_transaction_count DESC,
         total_fraud_amount DESC;

