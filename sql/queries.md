## SQL Task:

- Restore 5 tables from the backup file (db01-2022_04_24_17_44_44-dump.sql.zip) on your local MySQL Server (of course it should be already installed)
- You need to create 3 a bit different queries, but all of them need to select 5 fields: product_name gift_name, product_img_url, product_url, product_price_min, and product_short_description.
- The first query has to return all products connected with the sub_category “Jewelry”.
- The second query has to return all products connected with the keyword “Hair accessor”.
- The third query has to return all products connected either with sub_categories “Beauty & Personal Care” and “Skincare” (any of them!) or with the keyword “Aromatherapy”.
- In all these queries, we want to see only products which are not sold out yet.

## Queries

3
```
SELECT product_name gift_name, product_img_url, product_url, product_price_min, product_short_description FROM
jai_scraper_development.grommet_products
INNER JOIN grommet_product_categories ON grommet_product_categories.product_id = grommet_products.id
INNER JOIN grommet_gifts_categories ON grommet_gifts_categories.id = grommet_product_categories.product_category_id
where grommet_products.is_sold_out=false and grommet_gifts_categories.sub_category="Jewelry" ;
```

4
```
SELECT product_name gift_name, product_img_url, product_url, product_price_min, product_short_description FROM
jai_scraper_development.grommet_products
INNER JOIN grommet_product_to_keyword ON grommet_product_to_keyword.product_id = grommet_products.id
INNER JOIN grommet_product_keywords ON grommet_product_keywords.id = grommet_product_to_keyword.keyword_id
where grommet_products.is_sold_out=false and grommet_product_keywords.keyword="Hair accessor" ;
```

5
```
SELECT DISTINCT product_name gift_name, product_img_url, product_url, product_price_min, product_short_description FROM
jai_scraper_development.grommet_products
LEFT OUTER JOIN grommet_product_categories ON grommet_product_categories.product_id = grommet_products.id
LEFT OUTER JOIN grommet_gifts_categories ON grommet_gifts_categories.id = grommet_product_categories.product_category_id
LEFT OUTER JOIN grommet_product_to_keyword ON grommet_product_to_keyword.product_id = grommet_products.id
LEFT OUTER JOIN grommet_product_keywords ON grommet_product_keywords.id = grommet_product_to_keyword.keyword_id
WHERE grommet_products.is_sold_out=false and (grommet_gifts_categories.sub_category IN ("Beauty & Personal Care", "Skincare") or grommet_product_keywords.keyword="Aromatherapy")
```

Above includes 1, 2 and 6 points

