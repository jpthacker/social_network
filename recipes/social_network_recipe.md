# {{TABLE NAME}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE

Table: user

Columns:
id | username | email_address

Table: posts

Columns
id | title | content | no_of_views | user_id
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE users, posts RESTART IDENTITY;

INSERT INTO users (username, email_address) VALUES ('Ray', 'ray@makers.com');
INSERT INTO users (username, email_address) VALUES ('Jack', 'jack@makers.com');



TRUNCATE TABLE users, posts RESTART IDENTITY;

INSERT INTO users (username, email_address) VALUES ('Ray', 'ray@makers.com');
INSERT INTO users (username, email_address) VALUES ('Jack', 'jack@makers.com');

INSERT INTO posts (title, content, no_of_views, user_id) VALUES ('baby photos', 'six months progress', 5, 1);
INSERT INTO posts (title, content, no_of_views, user_id) VALUES ('cat photos', 'two years old', 3, 2);
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: students

class User
end

class UserRepository
end

class Post
end

class PostRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: students

# Model class
# (in lib/student.rb)

class User

  # Replace the attributes by your own columns.
  attr_accessor :id, :username, :email_address
end

class Post

  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :content, :no_of_views, :user_id
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# student = Student.new
# student.name = 'Jo'
# student.name
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: students

# Repository class
# (in lib/student_repository.rb)

class UserRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, username, email_address FROM users;

    # Returns an array of User objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, username, email_address FROM users WHERE id = $1;

    # Returns a single User object.
  end

  # Add more methods below for each operation you'd like to implement.

  def create(user)
    # Executes the SQL query:
    # INSERT INTO users (username, email_address) VALUES ($1, $2);
    # Returns nil
  end

  def update(user)
    # UPDATE users SET username = $1, email_address = $2 WHERE id = $3;
  end

  def delete(id)
  # DELETE FROM users WHERE id = $1;
  end
end

class PostRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, content, no_of_views, user_id FROM posts;

    # Returns an array of Post objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, title, content, no_of_views, user_id FROM posts WHERE id = $1;

    # Returns a single Post object.
  end

  # Add more methods below for each operation you'd like to implement.

  def create(user)
    # Executes the SQL query:
    # INSERT INTO posts (title, content, no_of_views, user_id) VALUES ($1, $2, $3, $4);
    # Returns nil
  end

  def update(user)
    # UPDATE posts SET title = $1, content = $2, no_of_views = $3, user_id = $4 WHERE id = $5;
  end

  def delete(id)
  # DELETE FROM posts WHERE id = $1;
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1 UserRepository
# Get all users

repo = UserRepository.new

users = repo.all

users.length # =>  2

users[0].id # =>  1
users[0].username # =>  'Ray'
users[0].email_address # =>  'Ray@makers.com'

users[1].id # =>  2
users[1].username # =>  'Jack'
users[1].email_address # =>  'jack@makers.com'


# Get a single user

repo = UserRepository.new

user = repo.find(1)

user.id # =>  1
user.username # =>  'Ray'
user.email_address # =>  'Ray@makers.com'

user = repo.find(2)

user.id # =>  2
user.username # =>  'Jack'
user.email_address # =>  'jack@makers.com'

# Create a new user
repo = UserRepository.new

user = User.new

user.username = 'Jay'
user.email_address = 'jay@makers.com'

repo.create(user)
users = repo.all

users.last.username # => 'Jay'
users.last.email_address # => 'jay@makers.com'

# Delete a user
repo = UserRepository.new

user = repo.find(1)

user.id # =>  1
user.username # =>  'Ray'
user.email_address # =>  'Ray@makers.com'

repo.delete(user.id)

users = repo.all

users.length # =>  1

users[0].id # =>  2
users[0].username # =>  'Jack'
users[0].email_address # =>  'jack@makers.com'

# Update a user
repo = UserRepository.new

user = repo.find(1)

user.id # =>  1
user.username # =>  'Ray'
user.email_address # =>  'Ray@makers.com'

user.email_address = 'Ray2@makers.com'

repo.update(user)

updated_user = repo.find(1)

updated_user.id # =>  1
updated_user.username # =>  'Ray'
updated_user.email_address # =>  'Ray2@makers.com'

# 2 PostRepository
# Get all posts

repo = PostRepository.new

posts = repo.all

posts.length # =>  2

posts[0].id # =>  1
posts[0].title # =>  'baby photos'
posts[0].content # =>  'six months progress'
posts[0].no_of_views # => 5
posts[0].user_id # => 1

posts[1].id # =>  2
posts[1].title # =>  'cat photos'
posts[1].content # =>  'two years old'
posts[1].no_of_views # => 3
posts[1].user_id # => 2

# Get a single post

repo = PostRepository.new

post = repo.find(1)

post.id # =>  1
post.title # =>  'baby photos'
post.content # =>  'six months progress'
post.no_of_views # => 5
post.user_id # => 1

post = repo.find(2)

post.id # =>  2
post.title # =>  'cat photos'
post.content # =>  'two years old'
post.no_of_views # => 3
post.user_id # => 2

# Create a new post

repo = PostRepository.new

post = Post.new

post.title = 'dog photos'
post.content = 'five years old'
post.no_of_views = 6
post.user_id = 1

repo.create(post)
posts = repo.all

posts.last.title # =>  'dog photos'
posts.last.content # =>  'five years old'
posts.last.no_of_views # => 6
posts.last.user_id # => 1

# Delete a user
repo = PostRepository.new

post = repo.find(1)

post.id # =>  1
post.title # =>  'baby photos'
post.content # =>  'six months progress'
post.no_of_views # => 5
post.user_id # => 1

repo.delete(post.id)

posts = repo.all

posts.length # =>  1

posts[0].id # =>  2
posts[0].title # =>  'cat photos'
posts[0].content # =>  'two years old'
posts[0].no_of_views # => 3
posts[0].user_id # => 2

# Update a user
repo = PostRepository.new

post = repo.find(1)

post.id # =>  1
post.title # =>  'baby photos'
post.content # =>  'six months progress'
post.no_of_views # => 5
post.user_id # => 1

post.content = 'first birthday!'
post.no_of_views = 20

repo.update(post)

updated_post = repo.find(1)

updated_post.id # =>  1
updated_post.title # =>  'baby photos'
updated_post.content # =>  'first birthday!'
updated_post.no_of_views # => 20
updated_post.user_id # => 1

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_users_table
  seed_sql = File.read('spec/seeds_users.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do 
    reset_users_table
  end

  # (your tests will go here).
end

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._