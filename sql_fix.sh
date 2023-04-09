PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# rename the weight column to atomic_mass
$PSQL $"ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;"

# rename the melting_point column to melting_point_celsius and the boiling_point column to boiling_point_celsius
$PSQL $"ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;"
$PSQL $"ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;"

# melting_point_celsisus and boiling_point_celsius should not accept NULL
$PSQL $"ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL";
$PSQL $"ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL";

# add unique constraint to the symbola nd name columns in the elements table
$PSQL $"ALTER TABLE elements ADD CONSTRAINT unique_symbol UNIQUE (symbol);"
$PSQL $"ALTER TABLE elements ADD CONSTRAINT unique_name UNIQUE (name);"

# symbol and name columns should have not null constraint
$PSQL $"ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL";
$PSQL $"ALTER TABLE elements ALTER COLUMN name SET NOT NULL";

# set atomic_number column from properties table as foreign key reference in the elements table
$PSQL $"ALTER TABLE properties ADD CONSTRAINT fk_atomic_number FOREIGN KEY (atomic_number) REFERENCES elements (atomic_number);"

# create types table to store three types of elements
# Your types table should have a type_id column that is an integer and the primary key
# Your types table should have a type column that's a VARCHAR and cannot be null. It will store the different types from the type column in the properties table

$PSQL $"CREATE TABLE types (
  type_id int primary key,
  type varchar not null
  );"

# You should add three rows to your types table whose values are the three different types from the properties table
$PSQL $"INSERT INTO types (type_id, type) VALUES (1, 'nonmetal'), (2, 'metal'), (3, 'metalloid');"

# Your properties table should have a type_id foreign key column that references the type_id column from the types table. It should be an INT with the NOT NULL constraint
# Each row in your properties table should have a type_id value that links to the correct type from the types table
$PSQL $"ALTER TABLE properties ADD COLUMN type_id INT;"
$PSQL $"UPDATE properties SET type_id = 1 WHERE type='nonmetal';"
$PSQL $"UPDATE properties SET type_id = 2 WHERE type='metal';"
$PSQL $"UPDATE properties SET type_id = 3 WHERE type='metalloid';"
$PSQL $"ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;"
$PSQL $"ALTER TABLE properties ADD CONSTRAINT fk_type_id FOREIGN KEY (type_id) REFERENCES types (type_id);"


# You should capitalize the first letter of all the symbol values in the elements table. Be careful to only capitalize the letter and not change any others
$PSQL $"UPDATE elements SET symbol=initcap(symbol);"

# You should remove all the trailing zeros after the decimals from each row of the atomic_mass column. You may need to adjust a data type to DECIMAL for this. The final values they should be are in the atomic_mass.txt file
$PSQL $"ALTER TABLE properties ALTER COLUMN atomic_mass TYPE REAL;"

# You should add the element with atomic number 9 to your database. Its name is Fluorine, symbol is F, mass is 18.998, melting point is -220, boiling point is -188.1, and it's a nonmetal
$PSQL $"INSERT INTO elements (atomic_number, symbol, name) VALUES (9, 'F', 'Fluorine'), (10, 'Ne', 'Neon');"
$PSQL $"INSERT INTO properties (atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id)
VALUES (9, 'nonmetal', 18.998, -220, -188.1, 1),
(10, 'nonmetal', 20.18, -248.6, -246.1, 1)"

# You should delete the non existent element, whose atomic_number is 1000, from the two tables
$PSQL $"DELETE FROM properties WHERE atomic_number=1000;"
$PSQL $"DELETE FROM elements WHERE atomic_number=1000;"

# Your properties table should not have a type column
$PSQL $"ALTER TABLE properties DROP COLUMN type;"


# You should add the element with atomic number 10 to your database. Its name is Neon, symbol is Ne, mass is 20.18, melting point is -248.6, boiling point is -246.1, and it's a nonmetal
pg_dump -cC --inserts -U freecodecamp periodic_table > periodic_table.sql



# mkdir periodic_table
# cd periodic_table
# git init
# touch element.sh
# git add element.sh
# git commit -m "feat: created element.sh file"
# git branch main
# chmod +x element.sh
