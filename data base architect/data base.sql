-- Media table
CREATE TABLE Media (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255),
    year INTEGER,
    language VARCHAR(255),
    country VARCHAR(255),
    producer_id INTEGER,
    image_id INTEGER 
);

-- Film table
CREATE TABLE Film (
    id INTEGER PRIMARY KEY,
    media_id INTEGER ,
    duration INTEGER,
    genre_id INTEGER ,
    video_id INTEGER ,
    synopsis_id INTEGER 
);

-- Serie table
CREATE TABLE Serie (
    id INTEGER PRIMARY KEY,
    media_id INTEGER ,
    producer_id INTEGER ,
    synopsis_id INTEGER , 
    genre_id INTEGER
);

-- Season table
CREATE TABLE Season (
    id INTEGER PRIMARY KEY,
    serie_id INTEGER ,
    numero INTEGER,
    start_date DATE,
    media_id INTEGER ,
    synopsis_id INTEGER 
);

-- Episode table
CREATE TABLE Episode (
    id INTEGER PRIMARY KEY,
    season_id INTEGER ,
    title VARCHAR(255),
    air_date DATE,
    media_id INTEGER ,
    video_id INTEGER ,
    synopsis_id INTEGER 
);

-- Genre table
CREATE TABLE Genre (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255)
);

-- Actor table
CREATE TABLE Actor (
    id INTEGER,
    name VARCHAR(255),
    email VARCHAR(255),
    birthdate DATE,  
    PASSWORD VARCHAR(255),
    PRIMARY KEY (id)
);

-- Role table
CREATE TABLE Role (
    id INTEGER PRIMARY KEY,
    actor_id INTEGER ,
    media_id INTEGER ,
    name VARCHAR(255)
);


-- Users table
CREATE TABLE Users(
    id INTEGER PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    PASSWORD VARCHAR(255),
    birthdate DATE
    
);

-- Comments table
CREATE TABLE Comments (
    id INTEGER PRIMARY KEY,
    Comments VARCHAR(255),
    Users_id INTEGER ,
    media_id INTEGER 
);

-- Rating table
CREATE TABLE Rating (
    id INTEGER PRIMARY KEY,
    score INTEGER,
    Users_id INTEGER ,
    media_id INTEGER
);

-- Notification table
CREATE TABLE Notification (
    id INTEGER PRIMARY KEY,
    message VARCHAR(255),
    Users_id INTEGER ,
    media_id INTEGER 
);

-- Preferences table
CREATE TABLE Preferences (
    id INTEGER PRIMARY KEY,
    Users_id INTEGER ,
    genre_id INTEGER 
);

-- Producer table
CREATE TABLE Producer (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    PASSWORD VARCHAR(255),
    birthdate DATE
);

-- Admin table
CREATE TABLE Admin (
    Users_id INTEGER ,
    id integer,
    PRIMARY KEY (id)
);
-- Favorite table
CREATE TABLE Favorite (
    Users_id INTEGER ,
    media_id INTEGER ,
    id INTEGER,
    PRIMARY KEY (id)
);

-- Synopsis table
CREATE TABLE Synopsis (
    id INTEGER PRIMARY KEY,
    text VARCHAR(255),
    video_id INTEGER 
);

-- Video table
CREATE TABLE Video (
    id INTEGER PRIMARY KEY,
    video BLOB
);

-- Image table
CREATE TABLE Image (
    id INTEGER PRIMARY KEY,
    image BLOB
);

-- Foreign key relationships
ALTER TABLE Film ADD CONSTRAINT fk_film_media FOREIGN KEY (media_id) REFERENCES Media(id) ON DELETE SET NULL;
ALTER TABLE Serie ADD CONSTRAINT fk_serie_media FOREIGN KEY (media_id) REFERENCES Media(id) ON DELETE SET NULL;
ALTER table media ADD CONSTRAINT fk_media_producer FOREIGN KEY (producer_id) REFERENCES producer(id) ON DELETE SET NULL;
ALTER TABLE Season ADD CONSTRAINT fk_season_serie FOREIGN KEY (serie_id) REFERENCES Serie(id) ON DELETE SET NULL;
ALTER TABLE Episode ADD CONSTRAINT fk_episode_season FOREIGN KEY (season_id) REFERENCES Season(id) ON DELETE SET NULL;
ALTER TABLE Serie ADD CONSTRAINT fk_serie_genre FOREIGN KEY (genre_id) REFERENCES Genre(id) ON DELETE SET NULL;
ALTER TABLE Role ADD CONSTRAINT fk_role_actor FOREIGN KEY (actor_id) REFERENCES Actor(id) ON DELETE SET NULL;
ALTER TABLE Comments ADD CONSTRAINT fk_Comments_users FOREIGN KEY (Users_id) REFERENCES Users(id) ON DELETE SET NULL;
ALTER TABLE Comments ADD CONSTRAINT fk_Comments_media FOREIGN KEY (Media_id) REFERENCES media(id) ON DELETE SET NULL;
ALTER TABLE Rating ADD CONSTRAINT fk_rating_users FOREIGN KEY (Users_id) REFERENCES Users(id) ON DELETE SET NULL;
ALTER TABLE Rating ADD CONSTRAINT fk_rating_media FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE SET NULL;
ALTER TABLE Notification ADD CONSTRAINT fk_notification_users FOREIGN KEY (Users_id) REFERENCES Users(id) ON DELETE SET NULL;
ALTER TABLE Notification ADD CONSTRAINT fk_notification_media FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE SET NULL;
ALTER TABLE Preferences ADD CONSTRAINT fk_preferences_users FOREIGN KEY (Users_id) REFERENCES Users(id) ON DELETE SET NULL;
ALTER TABLE Role ADD CONSTRAINT fk_role_media FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE SET NULL;
ALTER TABLE Film ADD CONSTRAINT fk_film_genre FOREIGN KEY (genre_id) REFERENCES Genre(id) ON DELETE SET NULL;
ALTER TABLE Episode ADD CONSTRAINT fk_episode_media FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE SET NULL;
ALTER TABLE Season ADD CONSTRAINT fk_season_media FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE SET NULL;
ALTER TABLE Admin ADD CONSTRAINT fk_admin_users FOREIGN KEY (Users_id) REFERENCES Users(id) ON DELETE SET NULL;
ALTER TABLE Favorite ADD CONSTRAINT fk_favorite_users FOREIGN KEY (Users_id) REFERENCES Users(id) ON DELETE SET NULL;
ALTER TABLE Favorite ADD CONSTRAINT fk_favorite_media FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE SET NULL;
ALTER TABLE Episode ADD CONSTRAINT fk_synopsis_Episode FOREIGN KEY (synopsis_id) REFERENCES synopsis(id) ON DELETE SET NULL;
ALTER TABLE Film ADD CONSTRAINT fk_synopsis_film FOREIGN KEY (synopsis_id) REFERENCES synopsis(id) ON DELETE SET NULL;
ALTER TABLE Season ADD CONSTRAINT fk_synopsis_season FOREIGN KEY (synopsis_id) REFERENCES synopsis(id) ON DELETE SET NULL;
ALTER TABLE Serie ADD CONSTRAINT fk_synopsis_serie FOREIGN KEY (synopsis_id) REFERENCES synopsis(id) ON DELETE SET NULL;
ALTER TABLE Synopsis ADD CONSTRAINT fk_synopsis_video FOREIGN KEY (Video_id) REFERENCES Video(id) ON DELETE SET NULL;
ALTER TABLE Episode ADD CONSTRAINT fk_episode_video FOREIGN KEY (video_id) REFERENCES Video(id) ON DELETE SET NULL;
ALTER TABLE Film ADD CONSTRAINT fk_film_video FOREIGN KEY (video_id) REFERENCES Video(id) ON DELETE SET NULL;
ALTER TABLE media ADD CONSTRAINT fk_media_image FOREIGN KEY (image_id) REFERENCES image(id) ON DELETE SET NULL;
ALTER TABLE preferences ADD CONSTRAINT fk_preferences_genre FOREIGN KEY (genre_id) REFERENCES genre(id) ON DELETE SET NULL;


-- adding image_id field to users table
ALTER TABLE users ADD COLUMN image_id INTEGER;
ALTER TABLE users ADD CONSTRAINT fk_users_image FOREIGN KEY (image_id) REFERENCES image(id) ON DELETE SET NULL;

-- adding image_id field to producer table
ALTER TABLE producer ADD COLUMN image_id INTEGER;
ALTER TABLE producer ADD CONSTRAINT fk_producer_image FOREIGN KEY (image_id) REFERENCES image(id) ON DELETE SET NULL;

-- adding image_id field to actor table
ALTER TABLE actor ADD COLUMN image_id INTEGER;
ALTER TABLE actor ADD CONSTRAINT fk_actor_image FOREIGN KEY (image_id) REFERENCES image(id) ON DELETE SET NULL;

