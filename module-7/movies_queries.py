# Author: Joseph Ayo
# Assignment: CSD310 Assignment 7.2
import mysql.connector
from mysql.connector import errorcode
config = {
    "user": "movies_user",
    "password": "popcorn",
    "host": "127.0.0.1",
    "database": "movies",
    "raise_on_warnings": True
}
try:
    db = mysql.connector.connect(**config)
    print("\n Database user {} connected to MySQL on host {} with database {}".format(config["user"], config["host"], config["database"]))
    input("\n\n Press any key to continue...")
except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print(" The supplied username or password are invalid")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print(" The supplied username or password are invalid")
    else:
        print(err)
cursor = db.cursor()
# Query 1: Select all fields from the 'studio' table
query_1 = "SELECT * FROM studio;"
cursor.execute(query_1)
studio_results = cursor.fetchall()
print("-- DISPLAYING Studio RECORDS --")
for row in studio_results:
    studio_id = row[0]  # Grabs the studio ID from the first column
    studio_name = row[1]  # Grabs the studio name from the second column
    print(f"Studio ID: {studio_id}")
    print(f"Studio Name: {studio_name}")
    print()  # Adds a blank line
# Query 2: Select all fields from the 'genre' table
query_2 = "SELECT * FROM genre;"
cursor.execute(query_2)
genre_results = cursor.fetchall()
print("\n--DISPLAYING Genre RECORDS--")
for row in genre_results:
    genre_id = row[0]  # Grabs the genre ID from the first column
    genre_name = row[1]  # Grabs the Genre Name from the second column
    print(f"Genre ID: {genre_id}")
    print(f"Genre Name: {genre_name}")
    print()  # Adds a blank line

# Query 3: Select movie names for movies with a runtime of less than two hours (120 minutes)
query_3 = "SELECT film_name, film_runtime FROM film WHERE film_runtime < 120;"
cursor.execute(query_3)
short_movies = cursor.fetchall()
print("\n-- DISPLAYING Short Film RECORDS --")
for row in short_movies:
    film_name = row[0]  # Grabs the genre ID from the first column
    runtime = row[1]  # Grabs the Genre Name from the second column
    print(f"Film Name: {film_name}")
    print(f"Runtime: {runtime}")
    print()  # Adds a blank line

# Query 4: Get a list of film names and directors, grouped by director
query_4 = "SELECT film_name, film_director FROM film ORDER BY film_director, film_name;"
cursor.execute(query_4)
directors_movies = cursor.fetchall()
print("\n-- DISPLAYING Director RECORDS in Order --")
for row in directors_movies:
    print(f"Film Name: {row[0]}")
    print(f"Director: {row[1]}")
    print()  # Adds a blank line

db.close()