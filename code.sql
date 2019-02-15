/* Kyle Norval*/
/* Learn SQL from Scratch*/

--2.1 Survey Table Analysis:All columns from the survey table
SELECT *
FROM survey
LIMIT 10;

--2.2 Create a Quiz funnel: Count of users grouped by question from the survey table taking the Style Quiz
--1-500, 2-475, 3-380, 4-361, 5-270
SELECT question,
       COUNT(DISTINCT user_id)
FROM survey
GROUP BY 1;

--2.3 Analysing the Quiz funnel: Calculate the percentage of users who answer each question
--Question 3 & Question 5 has a lower completion rate

--3.1 Home Try_On Funnel Analysis: Columns of quiz, home_try_on and purchase tables
--columns: user_id, style, fit, shape, color
SELECT *
FROM quiz
LIMIT 5;

--columns: user_id, number_of_pairs, address
SELECT *
FROM home_try_on
LIMIT 5;

--columns: user_id, product_id, style, model_name, color, price
SELECT *
FROM purchase
LIMIT 5;

--3.2 Home Try_On Funnel Analysis: LEFT JOIN of quiz, home_try_on and purchase Tables
SELECT DISTINCT q.user_id,
	        h.user_id IS NOT NULL AS 'is_home_try_on',
                h.number_of_pairs,
                p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
	  ON q.user_id = h.user_id
LEFT JOIN purchase p 
	  ON q.user_id = p.user_id
LIMIT 10;
                
--3.3 Conversion Analysis: Total conversion: quiz purchase
WITH funnel AS (SELECT DISTINCT q.user_id,
                h.user_id IS NOT NULL AS 'is_home_try_on',
                h.number_of_pairs,
                p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
	  ON q.user_id = h.user_id
LEFT JOIN purchase p
	  ON q.user_id = p.user_id)
SELECT COUNT(*) AS 'num_quiz',
       SUM(is_purchase) AS 'num_purchase',
       ROUND(1.0 * SUM(is_purchase) / COUNT(user_id), 2) AS 'to_purchase'
FROM funnel;

--3.4 Conversion Analysis Part 2: Conversion: home_try_on / purchase
WITH funnel AS (SELECT DISTINCT q.user_id,
                h.user_id IS NOT NULL AS 'is_home_try_on',
                h.number_of_pairs,
                p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
          ON q.user_id = h.user_id
LEFT JOIN purchase p
          ON q.user_id = p.user_id)
SELECT COUNT(*) AS 'num_quiz',
       SUM(is_home_try_on) AS 'num_try_on',
       SUM(is_purchase) AS 'num_purchase',
       ROUND(1.0 * SUM(is_home_try_on) / COUNT(user_id), 2) AS 'quiz_to_home_try_on',
       ROUND(1.0 * SUM(is_purchase) / SUM(is_home_try_on), 2) AS 'home_try_on_to_purchase'
FROM funnel;

--3.5 Conversion Analysis Part 3: Conversion by number of pairs
WITH funnel AS (SELECT DISTINCT q.user_id,
                h.user_id IS NOT NULL AS 'is_home_try_on',
                h.number_of_pairs,
                p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
          ON q.user_id = h.user_id
LEFT JOIN purchase p
          ON q.user_id = p.user_id)
SELECT number_of_pairs,
       SUM(is_home_try_on) AS 'num_try_on',
       SUM(is_purchase) AS 'num_purchase',
       ROUND(1.0 * SUM(is_purchase) / SUM(is_home_try_on), 2) AS 'home_try_on_to_purchase'
FROM funnel
WHERE number_of_pairs IS NOT NULL
GROUP BY number_of_pairs;

--4.1 Extra Analysis quiz Table (style, fit, shape, color)

SELECT COUNT(style) AS count_style,
       style
FROM quiz
GROUP BY 2;

SELECT COUNT(fit) AS count_fit,
       fit
FROM quiz
GROUP BY 2;

SELECT COUNT(shape) AS count_shape,
       shape
FROM quiz
GROUP BY 2;

SELECT COUNT(color)AS count_color,
       color
FROM quiz
GROUP BY 2;

--4.2 Extra Analysis purchase Table (product_id, style, model_name, color, price)

SELECT COUNT(product_id) AS count_product_id,
       product_id
FROM purchase
GROUP BY 2;

SELECT COUNT(model_name) AS count_model_name,
       model_name
FROM purchase
GROUP BY 2;

SELECT COUNT(price) AS count_price,
       price
FROM purchase
GROUP BY 2;

SELECT COUNT(color) AS count_color,
       color
FROM purchase
GROUP BY 2;

SELECT COUNT(style) AS count_style,
       style
FROM purchase
GROUP BY 2;



