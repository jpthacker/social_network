require_relative "post"

class PostRepository
    def all
        posts = []
        sql = 'SELECT id, title, content, no_of_views, user_id FROM posts;'
        results = DatabaseConnection.exec_params(sql, [])
        results.each do |record|
            post = Post.new
            post.id = record['id']
            post.title = record['title']
            post.content = record['content']
            post.no_of_views = record['no_of_views']
            post.user_id = record['user_id']
            posts << post
        end
        posts
    end

    def find(id)
        sql = 'SELECT id, title, content, no_of_views, user_id FROM posts WHERE id = $1;'
        params = [id]
        results = DatabaseConnection.exec_params(sql, params)
        record = results[0]
        post = Post.new
        post.id = record['id']
        post.title = record['title']
        post.content = record['content']
        post.no_of_views = record['no_of_views']
        post.user_id = record['user_id']
        post
    end

    def create(post)
        sql = 'INSERT INTO posts (title, content, no_of_views, user_id) VALUES ($1, $2, $3, $4);'
        params = [post.title, post.content, post.no_of_views, post.user_id]
        DatabaseConnection.exec_params(sql, params)
        return nil
    end

    def delete(id)
        sql = 'DELETE FROM posts WHERE id = $1;'
        params = [id]
        DatabaseConnection.exec_params(sql, params)
        return nil
    end

    def update(post)
        sql = 'UPDATE posts SET title = $1, content = $2, no_of_views = $3, user_id = $4 WHERE id = $5;'
        params = [post.title, post.content, post.no_of_views, post.user_id, post.id]
        DatabaseConnection.exec_params(sql, params)
        return nil
    end
end