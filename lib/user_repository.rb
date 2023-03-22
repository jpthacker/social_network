require_relative "user"

class UserRepository
    def all
        users = []
        sql = 'SELECT id, username, email_address FROM users;'
        results = DatabaseConnection.exec_params(sql, [])
        results.each do |record|
            user = User.new
            user.id = record['id']
            user.username = record['username']
            user.email_address = record['email_address']
            users << user
        end
        users
    end

    def find(id)
        sql = 'SELECT id, username, email_address FROM users WHERE id = $1;'
        params = [id]
        results = DatabaseConnection.exec_params(sql, params)
        record = results[0]
        user = User.new
        user.id = record['id']
        user.username = record['username']
        user.email_address = record['email_address']
        user
    end

    def create(user)
        sql = 'INSERT INTO users (username, email_address) VALUES ($1, $2);'
        params = [user.username, user.email_address]
        DatabaseConnection.exec_params(sql, params)
        return nil
    end

    def delete(id)
        sql = 'DELETE FROM users WHERE id = $1;'
        params = [id]
        DatabaseConnection.exec_params(sql, params)
        return nil
    end

    def update(user)
        sql = 'UPDATE users SET username = $1, email_address = $2 WHERE id = $3;'
        params = [user.username, user.email_address, user.id]
        DatabaseConnection.exec_params(sql, params)
        return nil
    end
end