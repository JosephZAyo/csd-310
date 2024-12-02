import mysql.connector
from mysql.connector import errorcode

# Database configuration
config = {
    "user": "movies_user",
    "password": "popcorn",
    "host": "127.0.0.1",
    "database": "movies",
    "raise_on_warnings": True
}

# Function to display film details in the specified format
def show_films(cursor, title):
    # Query to fetch the film details with inner joins for genre and studio names
    query = """
        SELECT film_name AS Name, 
               film_director AS Director, 
               genre_name AS Genre, 
               studio_name AS 'Studio Name' 
        FROM film
        INNER JOIN genre ON film.genre_id = genre.genre_id
        INNER JOIN studio ON film.studio_id = studio.studio_id;
    """

    cursor.execute(query)
    
    # Fetch all rows from the query result
    films = cursor.fetchall()
    
    # Check if there are results
    if films:
        # Print the header once
        print("\n -- {} --".format(title))
        
        # Iterate over the results and print each film's details in the requested format
        for film in films:
            print("Film Name: {}\nDirector: {}\nGenre Name ID: {}\nStudio Name: {}\n".format(film[0], film[1], film[2], film[3]))
    else:
        print(f"No films found with title containing '{title}'.")

# Main program to connect to the database and call the function
try:
    # Instruction 4 - Using the example code I provided, connect to the movies database.
    db = mysql.connector.connect(**config)
    print("\n Database user {} connected to MySQL on host {} with database {}".format(config["user"], config["host"], config["database"]))
    
    # Create cursor
    cursor = db.cursor()
    
    
    # Instruction 5 - Using the example code I have provided, call the show_films function to display the selected fields and the associated Label.
    show_films(cursor, "DISPLAYING FILMS")
    # Instruction 6 - Insert a new record into the film table using a film of your choice. Do not use 'Star Wars'. (Easier if you use a studio already in use..)
    query = """
            INSERT INTO film (film_id, film_name, film_releaseDate, film_runtime, film_director, studio_id, genre_id)
            VALUES (NULL, 'Deadpool', '2016', 108, 'Tim Miller', 1, 2);
            """
    cursor.execute(query)
    # Instruction 7 - Using the example code I have provided, call the show_films function to display the selected fields and the associated Label.
    show_films(cursor, "DISPLAYING FILMS AFTER INSERT")

    # Instruction 8 - Using the example code I have provided, update the film Alien to being a Horror film.
    query = """
            UPDATE film
            SET genre_id = 1
            WHERE film_name = 'Alien' AND genre_id = 2;
            """
    cursor.execute(query)
    # Instruction 9 - Using the example code I have provided, call the show_films function to display the selected fields and the associated Label.
    show_films(cursor, "DISPLAYING FILMS AFTER UPDATE")

    # Instruction 10 - Using the example code I have provided, delete the movie Gladiator.
    query = """
            DELETE FROM film
            WHERE film_name = 'Gladiator';
            """
    cursor.execute(query)

    # Instruction 11 - Using the example code I have provided, call theshow_films function to display the selected fields and the associated Label.
    show_films(cursor, "DISPLAYING FILMS AFTER DELETE")

    # Close the database connection
    db.close()

except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print(" The supplied username or password are invalid")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print(" The supplied database does not exist")
    else:
        print(err)
