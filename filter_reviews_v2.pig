-- Load the cleaned CSV from HDFS
raw_data = LOAD 'C:/Users/zinya/Downloads/Amazon_Reviews_Cleaned.csv' USING PigStorage(',') 
    AS (
        id:chararray,
        name:chararray,
        asins:chararray,
        brand:chararray,
        categories:chararray,
        primaryCategories:chararray,
        manufacturer:chararray,
        manufacturerNumber:chararray,
        reviews_doRecommend:chararray,
        reviews_numHelpful:chararray,
        reviews_rating:chararray,
        reviews_text:chararray,
        reviews_title:chararray,
        reviews_username:chararray
    );

-- Filter out rows with empty titles, and remove neutral ratings '3'
filtered_reviews = FILTER raw_data BY 
    reviews_rating IS NOT NULL AND
    reviews_rating != '3';

-- Extract just title and rating
extracted = FOREACH filtered_reviews GENERATE
    reviews_title AS title,
    reviews_rating AS rating;

-- Store result in HDFS (delete existing output before re-running)
STORE extracted INTO '/user/zinya/output/filtered_reviews'
    USING PigStorage(',');

-- Show 20 sample results in terminal
sample_output = LIMIT extracted 20;
DUMP sample_output;
