# Ecommerce Return Prediction

This project analyzes and predicts product return behavior in e-commerce orders using SQL Server, Python (Logistic Regression), and Power BI. The goal is to uncover return patterns and help reduce unnecessary refunds through data-driven insights.

## 🔍 Problem Statement

High return rates in e-commerce impact profitability. Understanding which products or customer behaviors lead to returns can help businesses proactively reduce them. This project aims to identify key return drivers and predict the likelihood of a return.

## 🧰 Tools & Technologies

- **SQL Server Management Studio (SSMS)** – Data cleaning, preprocessing, and trend analysis  
- **Python (Jupyter Notebook)** – Logistic Regression modeling and feature importance  
- **Power BI** – Interactive dashboards and business insights  

## 📊 Dataset Overview

The dataset includes 70,000+ records with the following columns:

- Item Name, Category, Version, Item Code  
- Item ID, Buyer ID, Transaction ID  
- Date, Final Quantity, Total/Final Revenue  
- Refunds, Sales Tax, Overall Revenue  
- Refunded Item Count, Purchased Item Count  
- `Is_Returned` (target)  

## 🔢 Key Steps

1. **Data Cleaning & Preprocessing (SQL + Python)**  
2. **Feature Engineering and Model Building (Logistic Regression)**  
3. **Return Rate Analysis by Category, Item, and Date**  
4. **Power BI Dashboard with KPIs, charts, and trend lines**  
5. **Final Business Recommendations**

## ✅ Results

- Achieved 100% model accuracy on the test set  
- Identified top features influencing returns: `Refunded_Item_Count`, `Final_Quantity`, and `Refunds`  
- Visual dashboards to track returns by category, time, and item  

## 📁 Folder Structure
├── data/
│ └── order_dataset_cleaned.csv
├── notebooks/
│ └── Ecommerce_Return_Prediction_LogisticRegression.ipynb
├── reports/
│ ├── Final Summary Report.docx
│ └── Power BI Dashboard Screenshot.png
├── sql/
│ └── Orders_Analytics.sql
└── README.md


## 📌 Insights

- Certain products and categories consistently drive higher return rates  
- Return rates peak after festive seasons and drop over time  
- Key features related to quantity and refunds heavily influence return behavior

## 📈 Power BI Dashboard

- KPIs: Total Orders, Revenue, Refunds  
- Return Trends by Category & Item  
- Yearly return rate comparison  
- Buyer return patterns (Is_Returned)

---

This project demonstrates how combining SQL, Python, and Power BI can deliver complete business intelligence solutions from raw data to prediction and visualization.



