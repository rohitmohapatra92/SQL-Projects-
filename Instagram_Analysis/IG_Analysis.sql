

/* We want to reward the users who have been around the longest.
Finding the 5 oldest users. */

SELECT 
    *
FROM
    users
ORDER BY created_at
LIMIT 5;



/*What day of the week do most users register on?
We need to figure out when to schedule an ad campgain*/

SELECT 
    DAYNAME(created_at) AS day_of_week, 
    COUNT(*) AS total
FROM
    users
GROUP BY day_of_week
ORDER BY total DESC
;


/*We want to target our inactive users with an email campaign.
Find the users who have never posted a photo*/

SELECT 
    u.id AS user_id,
    u.username AS username,
    p.id AS photo_id
FROM
    users u
        LEFT JOIN
    photos p ON u.id = p.user_id
WHERE
    p.id IS NULL;
    
/*We're running a new contest to see who can get the most likes on a single photo.
WHO WON??!!*/

SELECT 
    p.user_id AS user_id,
    u.username AS username,
    p.id AS photo_id,
    COUNT(*) AS total_likes
FROM
    likes l
        INNER JOIN
    photos p ON p.id = l.photo_id
        INNER JOIN
    users u ON u.id = p.user_id
GROUP BY p.id
ORDER BY total_likes DESC
LIMIT 1;

/*Our Investors want to know...
How many times does the average user post?*/
/*total number of photos/total number of users*/

SELECT 
	ROUND((select count(*) from photos)/(select count(*) from users),1) as average_user_post;


/*user ranking by postings higher to lower*/

SELECT 
    p.user_id AS user_id,
    u.username AS username,
    COUNT(*) AS total_posts
FROM
    photos p
        INNER JOIN
    users u ON u.id = p.user_id
GROUP BY user_id
ORDER BY total_posts DESC;


/*A brand wants to know which hashtags to use in a post
What are the top 5 most commonly used hashtags?*/

SELECT 
    pt.tag_id as tag_id, 
    t.tag_name as tag_name, 
    COUNT(*) as hashtag_count
FROM
    photo_tags pt
        INNER JOIN
    tags t ON pt.tag_id = t.id
GROUP BY tag_id
ORDER BY tag_id DESC;



/*We have a small problem with bots on our site...
Find users who have liked every single photo on the site*/

SELECT 
    l.user_id AS user_id,
    u.username AS username,
    COUNT(*) AS total_likes
FROM
    likes l
        INNER JOIN
    users u ON u.id = l.user_id
GROUP BY user_id
HAVING total_likes = (SELECT 
        COUNT(*)
    FROM
        photos);
        










    
