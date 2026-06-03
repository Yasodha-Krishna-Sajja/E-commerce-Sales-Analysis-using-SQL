CREATE TABLE list_of_orders (
    order_id TEXT PRIMARY KEY,
    order_date DATE,
    customer_name TEXT,
    state_name TEXT,
	city TEXT
);

CREATE TABLE order_details (
    order_id TEXT,
    amount NUMERIC,
	profit NUMERIC,
	quantity INTEGER,
    category TEXT,
    sub_category TEXT,
    FOREIGN KEY (order_id) REFERENCES list_of_orders(order_id)
);

CREATE TABLE sales_target (
    month_of_order_date TEXT,
    category TEXT,
    target NUMERIC
);
